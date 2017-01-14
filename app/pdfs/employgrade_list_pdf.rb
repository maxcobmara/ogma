class Employgrade_listPdf < Prawn::Document
  def initialize(employgrades, view, college)
    super({top_margin: 30, left_margin: 120, page_size: 'A4', page_layout: :portrait })
    @employgrades = employgrades
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
    table(line_item_rows, :column_widths => [30, 150, 150], :cell_style => { :size => 8,  :inline_format => :true}, :header => 2) do
      row(0).borders =[]
      row(0).height=50
      row(0).style size: 11
      row(0).align = :center
      row(0..1).font_style = :bold
      row(1).background_color = 'FFE34D'
      self.width=330
    end
  end
  
  def line_item_rows
    counter = counter || 0
    header = [[{content: "#{@college.name.upcase}<br>#{I18n.t('staff.employgrades.title').upcase}", colspan: 3}], ["No", I18n.t('staff.employgrades.name'), I18n.t('staff.employgrades.group_id')]]
    @employgrades.map do |employgrade|
        header << ["#{counter += 1}", employgrade.name, employgrade.grade_group]
    end
    header
  end
  
  def footer
    draw_text "#{page_number} / #{page_count}",  :size => 8, :at => [500,-5]
  end

end