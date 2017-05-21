class Assetsearch < ActiveRecord::Base
#   attr_accessible :assetcode, :assettype, :name, :purchaseprice, :purchasedate, :startdate, :enddate, :category, :assignedto, :bookable, :loandate, :returndate, :location, :defect_asset,:defect_reporter,:defect_processor,:defect_process,:maintainable 
#   attr_accessible :purchaseprice2, :purchasedate2,:loandate2, :returndate2,:expectedreturndate, :expectedreturndate2
#   attr_accessible :maintname, :maintcode, :disposal, :disposaltype, :discardoption, :disposalreport, :disposalcert, :disposalreport2,:loss_start,:loss_end,:loss_cert,:loanedasset,:alldefectasset
#   #validates_numericality_of :purchaseprice, :message => "not a number"
#   attr_accessor :method, :datetype, :curryear, :locationtype, :defect_type,:persontype,:disposal_for_reports
  
  #:assetcode, :assettype, :name, :purchaseprice, :purchasedate, :startdate, :enddate, :category, :assignedto, :bookable, :loandate, :returndate, :location, :defect_asset, :defect_reporter, :defect_processor, :defect_process, :maintainable, :maintname, :maintcode, :disposal, :disposaltype, :discardoption, :disposalreport, :disposalcert, :disposalreport2, :loss_start, :loss_end, :loss_cert, :loanedasset, :alldefectasset, :purchaseprice2, :purchasedate2, :receiveddate, :receiveddate2, :loandate2, :returndate2, :expectedreturndate, :expectedreturndate2
  
  belongs_to :college
  
  attr_accessor :datetype, :locationtype, :defect_type, :persontype
  
  def assets
    @assets ||= find_assets
  end
  
  SEARCH_TYPE=[
    #display          #stored 
    ["2 & 3", 1],
    ["4 (Harta Modal / Fixed Asset)", 2],
    ["5 (Inventori / Inventory)", 3],
    ["6 (Pergerakan Aset : Peminjaman)", 4],
    ["7 (Penempatan Aset)", 5],
    ["8 (Laporan Tahunan Harta Modal & Inventori)", 6],
    ["9 (Aduan Kerosakan Aset Alih)", 7],
    ["13 (Senarai Aset Alih yang Memerlukan Penyelenggaraan)", 8],
    ["14 (Daftar Penyelenggaraan Harta Modal)", 9],
    ["16 (Perakuan Pelupusan (PEP) Aset Alih Kerajaan)", 10],
    ["17 (Laporan Lembaga Pemeriksa Aset Alih Kerajaan)", 11],
    ["18 (Sijil Penyaksian Pemusnahan Aset Alih Kerajaan)", 12],
    ["19 (Sijil Pelupusan Aset Alih Kerajaan)", 13],
    ["20 (Laporan Tahunan Pemusnahan Aset Alih Kerajaan)", 14],
    ["28 (Laporan Awal Kehilangan Aset Alih Kerajaan)", 15],
    ["30 (Laporan Akhir Kehilangan Aset Alih Kerajaan)", 16],
    ["31 (Sijil Hapus Kira Aset Alih Kerajaan)", 17]
  ]
  
  def render_search_type
    (Assetsearch::SEARCH_TYPE.find_all{|disp, value| value==search_type}).map{|disp, value| disp}[0]
  end
  
  private

  def find_assets
    Asset.where(conditions).order(orders)   
  end
  
  def assetcode_conditions
    ["assetcode ILIKE ?", "%#{assetcode}%"] unless assetcode.blank?   #ok 
  end
  
  def name_conditions
    ["name ILIKE ?", "%#{name}%"] unless name.blank?    
  end

  def purchaseprice_conditions
    ["purchaseprice>=?", purchaseprice] unless purchaseprice.blank?      
  end

  def purchasedate_conditions
    ["purchasedate>=?", purchasedate] unless purchasedate.blank?
  end  
  
  def purchaseprice2_conditions
     ["purchaseprice<=?", purchaseprice2] unless purchaseprice2.blank?      
  end
  
  def purchasedate2_conditions
    ["purchasedate<=?", purchasedate2] unless purchasedate2.blank?
  end 
  
  def startdate_conditions
    ["purchasedate>=?", startdate] unless startdate.blank?
  end
  
  def enddate_conditions  #between 2 dates
    ["purchasedate<?", enddate] unless enddate.blank?
  end

  def receiveddate_conditions
    ["receiveddate>=?", receiveddate] unless receiveddate.blank?
  end
  
  def receiveddate2_conditions  #between 2 dates
    ["receiveddate<=?", receiveddate2] unless receiveddate2.blank?
  end
  
  def assettype_conditions
     ["assettype =?", assettype] unless assettype.blank?
  end
  
  # NOTE - working with date range (2 dates fields) - 19May2017
  #a) date fields in ASSET table - do as usual (refer above : purchasedate(startdate & enddate), receiveddate(receiveddate & receiveddate2)
  #b) date fields in ASSET'S joins table(s) - to ensure AND applied between date range (1st & 2nd date) use below approach (loandate & loandate2 - refer additional ids assignment required for loandate in loandate2, (also applied to expectedreturndate2) which represent existance of both dates)
  
  #A) kewpa 6 - shall limit result to existing asset loan only
#   def loanedasset_conditions
#     if loanedasset==1                                             #*******************search_type==4
#       ids=AssetLoan.pluck(:asset_id).uniq
#       if ids.count > 0
#         a="id=?" 
#         0.upto(ids.count-2) do |x|
#           a+=" OR id=? "
#         end
#         ["("+a+")", ids] 
#       else
#         [" (id=?)", 0]  # NOTE - refer above
#       end
#     end
#   end
  
  #======FOR ASSET LOAN - KEWPA 6---
  #AND is_approved!=?
  #@loanable = AssetLoan.find(:all, :conditions => ['asset_id=? AND is_approved!=?',params[:id], false], :order=>'returned_on ASC')
  #=================================

  def loandate_conditions
    unless loandate.blank?
      if loandate2.blank?
        ids=AssetLoan.where('loaned_on>=? AND is_approved!=?', loandate, false).pluck(:asset_id).uniq 
        if ids.count > 0
          a="id=?" 
          0.upto(ids.count-2) do |x|
            a+=" OR id=? "
          end
          ["("+a+")", ids] 
        else
          [" (id=?)", 0]  # NOTE - refer stationerysearch
        end
      end
    end
  end
  
  def loandate2_conditions
    unless loandate2.blank? 
      if loandate.blank?
        ids=AssetLoan.where('loaned_on<=? AND is_approved!=?', loandate2, false).pluck(:asset_id).uniq 
      else
        ids=AssetLoan.where('loaned_on<=? AND loaned_on >=? AND is_approved!=?', loandate2, loandate, false).pluck(:asset_id).uniq 
      end
      if ids.count > 0
          a="id=?" 
          0.upto(ids.count-2) do |x|
            a+=" OR id=? "
          end
          ["("+a+")", ids] 
        else
          [" (id=?)", 0]  # NOTE - refer above
        end
    end
  end
  
  def returndate_conditions
    unless returndate.blank?
      ids=AssetLoan.where('returned_on>=? AND is_approved!=?', returndate, false).pluck(:asset_id).uniq
      if ids.count > 0
        a="id=?" 
        0.upto(ids.count-2) do |x|
          a+=" OR id=? "
        end
        ["("+a+")", ids] 
      else
        [" (id=?)", 0]  # NOTE - refer above
      end
    end
  end
  
  def returndate2_conditions
    unless returndate2.blank?
      if returndate.blank?
        ids=AssetLoan.where('returned_on<=? AND is_approved!=?', returndate2, false).pluck(:asset_id).uniq
      else
        ids=AssetLoan.where('returned_on<=? AND returned_on>=? AND is_approved!=?', returndate2, returndate, false).pluck(:asset_id).uniq
      end
      if ids.count > 0
        a="id=?" 
        0.upto(ids.count-2) do |x|
          a+=" OR id=? "
        end
        ["("+a+")", ids] 
      else
        [" (id=?)", 0]  # NOTE - refer above
      end
    end
  end

  def expectedreturndate_conditions
    unless expectedreturndate.blank?
      ids=AssetLoan.where('expected_on>=? AND is_approved!=?', expectedreturndate, false).pluck(:asset_id).uniq
      if ids.count > 0
        a="id=?" 
        0.upto(ids.count-2) do |x|
          a+=" OR id=? "
        end
        ["("+a+")", ids] 
      else
        [" (id=?)", 0]  # NOTE - refer above
      end
    end
  end
  
  def expectedreturndate2_conditions
    unless expectedreturndate2.blank?
      if expectedreturndate.blank?
        ids=AssetLoan.where('expected_on<=? AND is_approved!=?', expectedreturndate2, false).pluck(:asset_id).uniq
      else
        ids=AssetLoan.where('expected_on<=? AND expected_on>=? AND is_approved!=?', expectedreturndate2, expectedreturndate, false).pluck(:asset_id).uniq
      end
      if ids.count > 0
        a="id=?" 
        0.upto(ids.count-2) do |x|
          a+=" OR id=? "
        end
        ["("+a+")", ids] 
      else
        [" (id=?)", 0]  # NOTE - refer above
      end
    end
  end  
  #A) kewpa 6 - ends here

  #B) kewpa 7 - to include asset_placement records & shall limit result to existing asset w location
#   def category_conditions
#     if category==1                                                                           #*******************search_type==5
#       ids=AssetPlacement.joins(:asset).pluck(:asset_id).uniq.compact+Asset.where.not(location_id: nil).pluck(:id)
#       if ids.count > 0
#           a="id=?" 
#           0.upto(ids.count-2) do |x|
#             a+=" OR id=? "
#           end
#           ["("+a+")", ids] 
#       else
#           [" (id=?)", 0]  # NOTE - refer above
#       end
#     end
#   end
  
  def location_conditions
    unless location.blank?
      assets_of_location=Asset.where(location_id: location)
      placements=AssetPlacement.joins(:asset)
      placements_of_location=placements.where(location_id: location)
      if assets_of_location.count > 0
        ["location_id=?", location] 
      elsif placements_of_location.count > 0
        ids=placements.pluck(:asset_id)
	if ids.count > 0
          a="id=?" 
          0.upto(ids.count-2) do |x|
            a+=" OR id=? "
          end
          ["("+a+")", ids] 
        else
          [" (id=?)", 0]  # NOTE - refer above
        end
      end
    end
  end
  #B) kewpa 7 - ends here
  
  #multi-usage
  def assignedto_conditions 
    unless assignedto.blank?
      #kewpa7 - start
      if search_type==5
        staff_ids=Asset.where.not(location_id: nil).pluck(:assignedto_id)                                                 #staff_ids of asset w location
        ids=AssetPlacement.joins(:asset).where.not(staff_id: nil).pluck(:asset_id).uniq.compact            #asset_ids of placement containing 'peg bertanggungjawab'
        if ids.count > 0
          a="id=?" 
          0.upto(ids.count-2) do |x|
            a+=" OR id=? "
          end
          if staff_ids.include?(assignedto)
            ["(assignedto_id=? OR "+a+")", assignedto, ids]
          else
            ["("+a+")", ids] 
          end
        else
          ["assignedto_id=?", assignedto]
        end
      else
        ["assignedto_id=?", assignedto] unless assignedto.blank?  #use this condition WITH FILTER FOR asset in ASSETDEFECT DB only - in show page.
      end
      #kewpa7 - end
    end
  end
  
  #COMBINE - (kewpa6: loanedasset==1, kewpa7: category==1, kewpa9: alldefectasset==1, kewpa13/14: maintainable==true)
  def search_type_conditions
    if search_type==4                                           #kewpa6
      ids=AssetLoan.pluck(:asset_id).uniq
    elsif search_type==5                                      #kewpa7
      ids=AssetPlacement.joins(:asset).pluck(:asset_id).uniq.compact+Asset.where.not(location_id: nil).pluck(:id)
    elsif search_type==7                                      #kewpa9
      ids=AssetDefect.pluck(:asset_id).uniq
    elsif search_type==8 || search_type==9        #kewpa13 & 14
      ajob=['is_maintainable=?', true]
    elsif search_type==10                                    #kewpa16
      ids=AssetDisposal.pluck(:asset_id).uniq
    elsif search_type==12                                    #kewpa18
      ids=AssetDisposal.where(is_disposed: true).where(disposal_type: 'discard').pluck(:asset_id).uniq
    elsif search_type==13                                  #kewpa19
      ids=AssetDisposal.where(is_disposed: true).pluck(:asset_id).uniq
    elsif search_type==11                                    #kewpa17
      ids=AssetDisposal.where('is_disposed is not TRUE').pluck(:asset_id).uniq
    elsif search_type==14                                    #kewpa20 
      ids=AssetDisposal.where('is_disposed=? AND disposed_on is not null', true).pluck(:asset_id).uniq          #("View & Close"-> is_disposed & disposed_on)
    elsif search_type==15
      ids=AssetLoss.pluck(:asset_id).uniq
    elsif search_type==16
      ids=AssetLoss.where('endorsed_on IS NOT NULL').pluck(:asset_id).uniq
    end
    if [4, 5, 7, 10, 12, 13, 11, 14, 15, 16].include?(search_type)
      if ids.count > 0
        a="id=?" 
        0.upto(ids.count-2) do |x|
          a+=" OR id=? "
        end
        ["("+a+")", ids] 
      else
        [" (id=?)", 0]  # NOTE - refer above
      end
    else
      ajob
    end
  end
  
  #C) kewpa 9 - starts here
  def defect_asset_conditions
    ["id=?", AssetDefect.find(defect_asset).asset_id] unless defect_asset.blank? 
  end
  
  def defect_reporter_conditions
    unless defect_reporter.blank?
      ids=AssetDefect.where('reported_by=?',defect_reporter).map(&:asset_id).uniq
      if ids.count > 0
        a="id=?" 
        0.upto(ids.count-2) do |x|
          a+=" OR id=? "
        end
        ["("+a+")", ids] 
      else
        [" (id=?)", 0]  # NOTE - refer above
      end
    end
  end
  
  def defect_processor_conditions
    unless defect_processor.blank?
      ids=AssetDefect.where('processed_by=?',defect_processor).map(&:asset_id).uniq
      if ids.count > 0
        a="id=?" 
        0.upto(ids.count-2) do |x|
          a+=" OR id=? "
        end
        ["("+a+")", ids] 
      else
        [" (id=?)", 0]  # NOTE - refer above
      end
    end
  end
  
  def defect_process_conditions
    unless defect_process.blank?
      ids=AssetDefect.where('process_type=?',defect_process).map(&:asset_id).uniq
      if ids.count > 0
        a="id=?" 
        0.upto(ids.count-2) do |x|
          a+=" OR id=? "
        end
        ["("+a+")", ids] 
      else
        [" (id=?)", 0]  # NOTE - refer above
      end
    end
  end
  #C) kewpa 9 - ends here
  
  #D) kewpa 13 & 14 - starts here
  def maintname_conditions
    unless maintname.blank?
      if maintname.include?("|")
        a,b,c=maintname.split(" | ")
        ["(name ILIKE ? OR typename ILIKE ? OR modelname ILIKE ?)", "%#{a}%", "%#{b}%", "%#{c}%"] 
      else
        ["(name ILIKE ? OR typename ILIKE ? OR modelname ILIKE ?)", "%#{maintname}%", "%#{maintname}%", "%#{maintname}%"] 
      end
      #["is_maintainable is TRUE AND (name ILIKE ? OR typename ILIKE ? OR modelname ILIKE ?)", "%#{maintname}%", "%#{maintname}%", "%#{maintname}%"] 
    end
  end
#   def maintainable_conditions
#       ['is_maintainable is TRUE'] unless maintainable.blank?# && maintainable==false
#   end
   
#   def maintcode_conditions
#       ['is_maintainable is TRUE AND assetcode ILIKE ?', "%#{maintcode}%"] unless maintcode.blank?
#   end
   #D) kewpa 13 & 14 ends here
 
  #E) kewpa 16 - starts here - NOTE - refer COMBINE section (search_type)
  #use of maintname & assetcode
#   def disposal_details
#     a='id=? ' if AssetDisposal.all.map(&:asset_id).uniq.count!=0
#     0.upto(AssetDisposal.all.map(&:asset_id).uniq.count-2) do |l|  
#       a=a+'OR id=? '
#     end 
#     return a unless disposal.blank?
#   end
#   
#   def disposal_conditions
#       [" ("+disposal_details+")", AssetDisposal.all.map(&:asset_id).uniq] unless disposal.blank?
#   end
  #E) kewpa 16 - ends here
  #F) kewpa 19 - starts here - NOTE - refer COMBINE section (search_type)
#   def disposalcert_details
#     a='id=? ' if AssetDisposal.where('is_disposed is TRUE').map(&:asset_id).uniq.count!=0
#     0.upto(AssetDisposal.where('is_disposed is TRUE').map(&:asset_id).uniq.count-2) do |l|  
#       a=a+'OR id=? '
#     end 
#     return a unless disposalcert.blank?
#   end
#   
#   def disposalcert_conditions
#     [" ("+disposalcert_details+")", AssetDisposal.where('is_disposed is TRUE').map(&:asset_id).uniq] unless disposalcert.blank?
#   end
  #F) kewpa 19 - ends here
  
  #G) kewpa 17 - starts here NOTE - totally new fields, verified_on means disposal is processed & verified, & awaiting 4 final approval for dispose process
  ##checked_on --> examination date, whereas verified_on-> date verified that examination has taken place
  def examine_start_conditions
    unless examine_start.blank?
      ids=AssetDisposal.where('verified_on >=?', examine_start).pluck(:asset_id).uniq  
      if ids.count > 0
        a="id=?" 
        0.upto(ids.count-2) do |x|
          a+=" OR id=? "
        end
        ["("+a+")", ids] 
      else
        [" (id=?)", 0]  # NOTE - refer above
      end
    end
  end
  
  def examine_end_conditions
    unless examine_end.blank?
      ids=AssetDisposal.where('verified_on <=?', examine_end).pluck(:asset_id).uniq
      if ids.count > 0
        a="id=?" 
        0.upto(ids.count-2) do |x|
          a+=" OR id=? "
        end
        ["("+a+")", ids] 
      else
        [" (id=?)", 0]  # NOTE - refer above
      end
    end
  end
  #G) kewpa 17 - ends here
  
  #H) kewpa 20 - starts here NOTE - rename & chg field type: disposalreport, disposalreport2 to disposalreport_start, disposalreport_end  & string->date
  def disposalreport_start_conditions
    unless disposalreport_start.blank?
      ids=AssetDisposal.where('disposed_on >=?', disposalreport_start).pluck(:asset_id).uniq
      if ids.count > 0
        a="id=?" 
        0.upto(ids.count-2) do |x|
          a+=" OR id=? "
        end
        ["("+a+")", ids] 
      else
        [" (id=?)", 0]  # NOTE - refer above
      end
    end
  end
  
  def disposalreport_end_conditions
    unless disposalreport_end.blank?
      ids=AssetDisposal.where('disposed_on <=?', disposalreport_end).pluck(:asset_id).uniq
      if ids.count > 0
        a="id=?" 
        0.upto(ids.count-2) do |x|
          a+=" OR id=? "
        end
        ["("+a+")", ids] 
      else
        [" (id=?)", 0]  # NOTE - refer above
      end
    end
  end
  #H) kewpa 20 - ends here
  
  #I) kewpa 18 - starts here
  def discardoption_conditions
    unless discardoption.blank?
      ids=AssetDisposal.where('discard_options=?',discardoption).pluck(:asset_id).uniq
      if ids.count > 0
        a="id=?" 
        0.upto(ids.count-2) do |x|
          a+=" OR id=? "
        end
        ["("+a+")", ids] 
      else
        [" (id=?)", 0]  # NOTE - refer above
      end
    end
  end
  #I) kewpa 18 - ends here
  
  def loss_start_details
    a='id=? ' if AssetLoss.all.map(&:asset_id).count!=0
    0.upto(AssetLoss.all.map(&:asset_id).count-2) do |l|  
      a=a+'OR id=? '
    end 
    return a if loss_start== 1 #unless loss_start.blank? 
  end  
  
  def loss_start_conditions
    [" ("+loss_start_details+")",AssetLoss.all.map(&:asset_id)] unless loss_start.blank?
  end
  
  def loss_end_details
    a='id=? ' if AssetLoss.where('endorsed_on IS NOT NULL').map(&:asset_id).count!=0
    0.upto(AssetLoss.where('endorsed_on IS NOT NULL').map(&:asset_id).count-2) do |l|  
      a=a+'OR id=? '
    end 
    return a unless loss_end.blank?
  end  
  
  def loss_end_conditions
    [" ("+loss_end_details+")",AssetLoss.where('endorsed_on IS NOT NULL').map(&:asset_id)] unless loss_end.blank?
  end
  
  def loss_cert_details
    a='id=? ' if AssetLoss.where('document_id=?', loss_cert).map(&:asset_id).uniq.count!=0
    0.upto(AssetLoss.where('document_id=?', loss_cert).map(&:asset_id).uniq.count-2) do |l|  
      a=a+'OR id=? '
    end 
    return a unless loss_cert.blank?
  end
  
  def loss_cert_conditions
    [loss_cert_details,AssetLoss.where('document_id=?', loss_cert).map(&:asset_id)] unless loss_cert.blank?
  end
  
  #def disposaltype_details
    #a='id=? ' if AssetDisposal.find(:all, :conditions=>['disposal_type=?', disposaltype]).map(&:asset_id).uniq.count!=0
    #0.upto(AssetDisposal.find(:all, :conditions=>['disposal_type=?', disposaltype]).map(&:asset_id).uniq.count-2) do |l|  
        #a=a+'OR id=? '
    #end 
    #return a unless disposaltype.blank?
  #end
  
  #def disposaltype_conditions
   # [disposaltype_details, AssetDisposal.find(:all, :conditions=>['disposal_type=?',disposaltype]).map(&:asset_id)] unless disposaltype.blank?
  #end
    
  def orders
    "assetcode ASC"# "staffgrade_id ASC"
  end  

  def conditions
    [conditions_clauses.join(' AND '), *conditions_options] #works like OR?????
  end

  def conditions_clauses
    conditions_parts.map { |condition| condition.first }
  end

  def conditions_options
    conditions_parts.map { |condition| condition[1..-1] }.flatten
  end

  def conditions_parts
    private_methods(false).grep(/_conditions$/).map { |m| send(m) }.compact
  end
 
end
