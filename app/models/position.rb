class Position < ActiveRecord::Base
  
  before_save :set_combo_code, :titleize_name
  has_ancestry :cache_depth => true
  
  validates_uniqueness_of :combo_code
  validates_presence_of   :name
  
  belongs_to :staff
  belongs_to :staffgrade, :class_name => 'Employgrade'
  belongs_to :postinfo
  
  def titleize_name
    self.name = name.titleize
  end
  
  def set_combo_code
    if ancestry_depth == 0
      self.combo_code = code
    else
      self.combo_code = parent.combo_code + "-" + code
    end
  end
  
  #PDF & Exel section  
  def totalpost
    unless postinfo_id.blank?
      a=Position.where('postinfo_id=?', postinfo_id).order(combo_code: :asc)[0].id
      if self.id==a
        aa="#{postinfo.post_count}"
      else
        aa=""
      end
      return aa
    else
      return "-"
    end
  end
  
  def totalpost2
    if totalpost==""
      return nil
    else
      return totalpost
    end
  end
  
  def butiran_details
    unless totalpost=="-" 
      b="#{postinfo.details}" if totalpost!=""
    else
      b="-"
    end
    b    
  end
  
  def occupied_post
    unless totalpost=="-" 
      b="#{Position.where('postinfo_id=? AND staff_id IS NOT NULL',postinfo_id).count}" if totalpost!=""
    else
      b="-"
    end
    b
  end
  
  def available_post          #@positions2.concat(positions_by_grade_wo_butiran.sort_by{|x|[x.staffgrade_id, x.staff.name]})
    unless totalpost=="-" 
      b="#{totalpost.to_i-occupied_post.to_i}" if totalpost!=""
    else
      b="-" 
    end
    b
  end
  
  def hakiki
    unless totalpost=="-" 
      b="#{Position.where('postinfo_id=? AND status=? AND staff_id IS NOT NULL',postinfo_id, 1).count }" if totalpost!=""
    else          #@positions2.concat(positions_by_grade_wo_butiran.sort_by{|x|[x.staffgrade_id, x.staff.name]})

      b="-"
    end
    b
  end
  
  def kontrak
    unless totalpost=="-" 
      b="#{Position.where('postinfo_id=? AND status=? AND staff_id IS NOT NULL',postinfo_id, 2).count}" if totalpost!=""
    else
      b="-" 
    end
    b
  end
  
  def kup
    unless totalpost=="-" 
      b="#{Position.where('postinfo_id=? AND status=? AND staff_id IS NOT NULL',postinfo_id, 3).count}" if totalpost!=""
    else
      b="-" 
    end
    b
  end
  
  #Export Excel (maklumat_perjawatan_excel) start
  def self.to_csv(options = {})
    
    CSV.generate(options) do |csv|
        @positions=[]
        all.group_by{|x|x.staffgrade.name.scan(/[a-zA-Z]+|[0-9]+/)[1].to_i}.sort.reverse!.each do |staffgrade2, positions_of_grade_no|
          positions_of_grade_no.group_by{|x|x.staffgrade.name.scan(/[a-zA-Z]+|[0-9]+/)[0]}.sort.reverse!.each do |staffgrade, positions_by_grade|
            positions_by_grade_w_butiran=[]
            positions_by_grade_wo_butiran=[]
            positions_by_grade.each do |position|
              unless position.postinfo_id.blank? 
                positions_by_grade_w_butiran<< position
              else 
                positions_by_grade_wo_butiran<< position 
              end
            end 
            @positions.concat(positions_by_grade_w_butiran.sort_by{|x|[x.staffgrade_id, -(x.postinfo.details[0,3].to_i), x.combo_code]})
            @positions.concat(positions_by_grade_wo_butiran.sort_by{|x|[x.staffgrade_id, x.combo_code]})
          end
        end
	csv << [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "LAMPIRAN A"]
        csv << ["MAKLUMAT PERJAWATAN DI KOLEJ-KOLEJ LATIHAN"]
        csv << ["KEMENTERIAN KESIHATAN MALAYSIA"]
        csv << ["SEHINGGA #{I18n.l((Position.all.order(updated_at: :desc).pluck(:updated_at).first), format: '%d-%m-%Y')}"]
        csv << [] #blank row added
        csv << ["KOLEJ : KOLEJ SAINS KESIHATAN BERSEKUTU JOHOR BAHRU"]
        csv << [] #blank row added
        csv <<  [ "BIL", "BUT.","JAWATAN", "GRED", "JUM JWT","ISI",nil, "STATUS PENGISIAN", nil,"KSG", "NAMA PENYANDANG", "NO. K/P / PASSPORT", "JANTINA (L/P)", "BIDANG KEPAKARAN/SUB-KEPAKARAN","TARIKH WARTA PAKAR", "PENEMPATAN","PINJAM KE", nil, "PINJAM DARI", nil, "CATATAN"]
        csv << [nil,nil,nil,nil,nil,nil,"HAKIKI", "KONTRAK", "KUP",nil,nil,nil,nil,nil,nil,nil, "Akt.","Penempatan", "Akt.", "Penempatan", "*" ]
        csv << [] #blank row added
        
        counter =counter || 0
        @positions.each do |position|
            csv << ["#{counter += 1}", position.butiran_details, position.name, position.try(:staffgrade).try(:name), position.totalpost2, position.occupied_post,   position.hakiki, position.kontrak, position.kup, position.available_post ,position.try(:staff).try(:name), position.try(:staff).try(:icno),"#{'L' if position.try(:staff).try(:gender)==1} #{'P' if position.try(:staff).try(:gender)==2}","","","","","","","",""]
         end    
    end
    
  end
  #Export Excel - end
  
end

# == Schema Information
#
# Table name: positions
#
#  ancestry       :string(255)
#  ancestry_depth :integer
#  code           :string(255)
#  combo_code     :string(255)
#  created_at     :datetime
#  id             :integer          not null, primary key
#  is_acting      :boolean
#  name           :string(255)
#  postinfo_id    :integer
#  staff_id       :integer
#  staffgrade_id  :integer
#  status         :integer
#  tasks_main     :text
#  tasks_other    :text
#  unit           :string(255)
#  updated_at     :datetime
#
