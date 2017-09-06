class Holiday_listPdf < Prawn::Document
  def initialize(holidays, view, college)
    super({top_margin: 40, left_margin: 50, page_size: 'A4', page_layout: :portrait })
    @holidays = holidays
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
    table(line_item_rows, :column_widths => [30, 230, 230], :cell_style => { :size => 9,  :inline_format => :true}, :header => 2) do
      row(0).borders =[]
      row(0).height=50
      row(0).style size: 11
      row(0).align = :center
      row(0..1).font_style = :bold
      row(1).background_color = 'FFE34D'
      self.width = 490
    end
  end
  
  def line_item_rows
    counter = counter||0
    header=[[{content: "#{I18n.t('holiday.title').upcase}<br> #{@college.name.upcase}", colspan: 3}],
            ["No", I18n.t('holiday.hname'), I18n.t('holiday.hdate')]]
    header +
    @holidays.map do |holiday|
        ["#{counter+=1}", holiday.hname.capitalize, "#{@view.fullmonthname(holiday.hdate)} (#{@view.fulldayname(holiday.hdate.wday)})"]
    end
  end
  
  def footer
    draw_text "#{page_number} / #{page_count}",  :size => 8, :at => [500,-5]
  end

end