class Position_listPdf < Prawn::Document
  def initialize(positions, view, college)
    super({top_margin: 40, left_margin: 40, page_size: 'A4', page_layout: :landscape })
    @positions = positions
    @view = view
    @college=college
    font "Helvetica"
    record
    #text "<ul id='header_tree'><span class='combo_code'>Test</span></ul>"
#     %ul#header_tree
#   %li
#     %span.combo_code= t('position.name')
    page_count.times do |i|
      go_to_page(i+1)
      footer
    end
  end
  
  def record
    #table(line_item_rows, :column_widths => [30, 130, 130, 90, 80, 60], :cell_style => { :size => 9,  :inline_format => :true}, :header => 2) do
    table(line_item_rows, :column_widths => [750], :cell_style => { :size => 9,  :inline_format => :true}, :header => 2) do
      row(0).borders =[]
      row(0).height=50
      row(0).style size: 11
      row(0).align = :center
      row(0..1).font_style = :bold
      row(1).background_color = 'FFE34D'
      self.width = 750
    end
  end
  
  def line_item_rows
    counter = counter||0
#     header=[[{content: "#{I18n.t('asset.defect.list').upcase}<br> #{@college.name.upcase}", colspan: 6}],
#             ["No", "#{I18n.t('asset.assetcode')}", "#{I18n.t('asset.category.type_name_model')}", "#{I18n.t('asset.serial_no')}", "#{I18n.t('location.title')}", "#{ I18n.t('asset.defect.notes')}"]]
#     
#     %span.combo_code= t('position.name')
#     %span.min_grade=t('position.min_grade')
#     %span.unit_name Unit
#     %span.staff=t('position.staff_id')

    header=[["#{I18n.t('position.list').upcase}<br> #{@college.name.upcase}"], ["#{I18n.t('position.name')}  #{I18n.t('position.min_grade')} Unit #{I18n.t('position.staff_id')}"]]
   body=[]
   
   @positions.group_by(&:root).sort.each do |root_post, positions| 
     counter+=1
     body << ["<b>#{root_post.combo_code}</b>  #{root_post.name}  #{root_post.try(:staffgrade).try(:name)} #{root_post.unit} #{root_post.staff.blank? ? "-" : root_post.staff.staff_with_rank}" ]
     #a=[["aa"], ["bb"], ["cc"]]
     a=Position.nested_post_pdf(counter, root_post)
     body+=a
   end
#     
#       - count=0
#   - @positions.group_by(&:root).sort.each do |root_post, positions| 
#     - count+=1
#     %li
#       %span.Collapsable
#         - if root_post.descendants.count > 0
#           %span{id: "anchor_#{count}", class: "ancmain"}= link_to fa_icon("plus-square-o"), "#"
#         - else
#           = fa_icon("minus-square-o")
#         %span.programme_list
#           &nbsp;&nbsp;
#           %strong=root_post.combo_code
#           = link_to root_post.name, staff_position_path(root_post)
#         %span.min_grade=h root_post.try(:staffgrade).try(:name)
#         %span.unit_name=h root_post.unit
#         %span.staff=h root_post.staff.blank? ? "-" : root_post.staff.staff_with_rank
#         /Positions - ancestry_depth > 0
#       /NOTE - ancs=1, anch=1
#       - ancs=count
#       - anch=count
#       %ul{id: "tree_#{ancs}", class: 'non_bulleted'}=Position.nested_post(ancs, root_post, anch, hp).html_safe
   
    header +body
#     header +
#     @defective.map do |defect|
#         ["#{counter+=1}", "#{defect.asset.try(:assetcode)}", "#{defect.asset.try(:typename)} - #{defect.asset.name} - #{defect.asset.modelname}", "#{defect.asset.try(:serialno)}", "#{defect.asset.asset_placements.last.try(:location).try(:location_list)}", "" ]
#     end
  end
  
  def footer
    draw_text "#{page_number} / #{page_count}",  :size => 8, :at => [720,-5]
  end

end