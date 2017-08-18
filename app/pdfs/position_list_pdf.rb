class Position_listPdf < Prawn::Document
  def initialize(positions, view, college)
    super({top_margin: 40, left_margin: 40, page_size: 'A4', page_layout: :landscape })
    @positions = positions
    @view = view
    @college=college
    font "Helvetica"
    record
    page_count.times do |i|
      go_to_page(i+1)
      footer
    end
  end
  
  def record
    table(line_item_rows, :column_widths =>[40, 100, 240, 70, 150, 150], :cell_style => { :size => 9,  :inline_format => :true}, :header => 2) do
      row(0).borders =[]
      row(0).height=50
      row(0).style size: 11
      row(0).align = :center
      row(0..1).font_style = :bold
      row(1).background_color = 'FFE34D'
     # self.width = 750
    end
  end
  
  def line_item_rows
    counter = counter||0
    header=[[{content: "#{I18n.t('position.list').upcase}<br> #{@college.name.upcase}", colspan: 6}], ["No", "#{I18n.t('position.combo_code')}", "#{I18n.t('position.name')}", "#{I18n.t('position.min_grade')}", "Unit", "#{I18n.t('position.staff_id')}"]]
   body=[]
   @positions.group_by(&:root).sort.each do |root_post, positions| 
     body << ["#{counter+=1}", "#{root_post.combo_code}", "#{root_post.name}",  "#{root_post.try(:staffgrade).try(:name)}", "#{root_post.unit}", "#{root_post.staff.blank? ? '-' : root_post.staff.staff_with_rank}" ]
     #a=[["aa"], ["bb"], ["cc"]]
     a=Position.nested_post_pdf(counter, root_post)
     b=[]
     0.upto(a.count-1) do |cnt|
       b << ["#{cnt+2}"]+a[cnt]
     end
     body+=b
   end
   header +body
  end
  
  def footer
    draw_text "#{page_number} / #{page_count}",  :size => 8, :at => [720,-5]
  end

end