class CensusStudentTenantsPdf < Prawn::Document
  include StudentsHelper
  def initialize(all_beds_single, view)
    super({top_margin: 30, page_size: 'A4', page_layout: :portrait })
    @all_beds_single = all_beds_single
    font "Times-Roman"
    logo
    move_down 5
    text "Aras : #{@all_beds_single[0].parent.parent.name[-2,2]}", :align => :left, :size => 10, :style => :bold
    record
  end
  
  def logo 
     table(line_logo, :column_widths => [60,400,40], :cell_style => { :size => 10,  :inline_format => :true}) do
      row(0).font_style = :bold
      self.width = 500
      row(0).column(0).borders = []
      row(0).column(1).borders = []
      row(0).column(2).borders = []
    end
  end
  
  def line_logo
    line_item=[[{:image => "#{Rails.root}/app/assets/images/logo_kerajaan.png", :scale => 0.5},
                     "PENEMPATAN PELATIH ASRAMA #{(@all_beds_single[0].root.name[4,20]).upcase} BLOK #{@all_beds_single[0].root.code+'<br>'} KOLEJ SAINS KESIHATAN BERSEKUTU #{'<br>'} JOHOR BAHRU",
                     {:image => "#{Rails.root}/app/assets/images/kskb_logo.png", :scale => 0.65}]]
  end
  
  def record
    table(line_item_rows, :column_widths => [30,60,200,80,120,40], :cell_style => { :size => 10,  :inline_format => :true}) do
      row(0).font_style = :bold
      row(0).background_color = 'FFE34D'
      self.row_colors = ["FEFEFE", "FFFFFF"]
      self.header = true
      self.width = 530
      header = true
    end
  end
  
  def line_item_rows    
    line_items=[]
    counter = counter || 0
    @all_beds_single.map do |bed|
      if bed.occupied==true
	line_items << ["#{counter+=1}","#{bed.parent.name[-5,5]}",{content: "#{bed.parent.damages.where(document_id: 1).last.description rescue (t 'student.tenant.damage')}", colspan: 4, :align => :center}]
      else
	one_line = ["#{counter+=1}","#{bed.parent.name[-5,5]}"]
	if bed.tenants.count > 0
	  if bed.tenants.last.student.nil?
	    one_line+=["#{I18n.t 'student.tenant.tenancy_details_nil'}"]
	  else
	    one_line+=["#{bed.tenants.last.try(:student).try(:name)}"]
	  end
	else
	  one_line+=[""]
	end
	one_line+=["#{bed.tenants.last.try(:student).try(:formatted_mykad)}", "#{bed.tenants.last.try(:student).try(:course).try(:name)}","#{bed.tenants.last.student.intake_num rescue ""}"]
	line_items << one_line
	  #line_items << ["#{counter+=1}","#{bed.parent.name[-5,5]}","#{bed.tenants.last.try(:student).try(:name) }","#{bed.tenants.last.try(:student).try(:formatted_mykad)}", "#{bed.tenants.last.try(:student).try(:course).try(:name)}","#{bed.tenants.last.student.intake_num rescue ""}"]
	
      end
    end
    header = [[ "BIL", "NO. BILIK", "NAMA", "NO. K / P", "PROGRAM", "KUMP"]]   
    header + line_items
  end
# 
#    @all_beds_single.each do |bed|
#         - if bed.occupied==true
#           %tr
#             %td= bed.combo_code
#             %td= bed.name
#             %td.damaged{colspan:6}=bed.parent.damages.where(document_id: 1).last.description rescue (t 'student.tenant.damage')
#         - else
#           %tr
#             %td= bed.combo_code
#             %td= bed.name
#             %td
#               - if bed.tenants.count > 0
#                 - if bed.tenants.last.student.nil?  
#                   %font{color: "red"}=t 'student.tenant.tenancy_details_nil'
#                 - else
#                   =bed.tenants.last.try(:student).try(:name) 
#             %td= bed.tenants.last.try(:student).try(:icno)
#             %td= bed.tenants.last.try(:student).try(:matrixno)
#             %td= bed.tenants.last.try(:student).try(:course).try(:name)
#             %td= bed.tenants.last.student.intake_num rescue ""
  
end