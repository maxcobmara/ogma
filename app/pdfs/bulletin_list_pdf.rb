class Bulletin_listPdf < Prawn::Document
  def initialize(bulletins, view, college)
    super({top_margin: 40, left_margin: 40, page_size: 'A4', page_layout: :portrait })
    @bulletins = bulletins
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
    table(line_item_rows, :column_widths => [30, 120, 170, 130, 60], :cell_style => { :size => 9,  :inline_format => :true}, :header => 2) do
      row(0).borders =[]
      row(0).height=50
      row(0).style size: 11
      row(0).align = :center
      row(0..1).font_style = :bold
      row(1).background_color = 'FFE34D'
      self.width = 510
    end
  end
  
  def line_item_rows
    counter = counter||0
    header=[[{content: "#{I18n.t('buletin.list').upcase}<br> #{@college.name.upcase}", colspan: 5}],
            ["No", I18n.t('buletin.headline'), I18n.t('buletin.content'), I18n.t('buletin.posted_by'), I18n.t('buletin.publish_date') ]]
    header +
    @bulletins.map do |bulletin|
        ["#{counter+=1}", bulletin.headline, @view.truncate(bulletin.content, :length => 100), @college.code=='amsas' ? bulletin.staff.staff_with_rank : bulletin.staff.try(:mykad_with_staff_name), bulletin.publishdt.try(:strftime, '%d-%m-%Y')]
    end
  end
  
  def footer
    draw_text "#{page_number} / #{page_count}",  :size => 8, :at => [500,-5]
  end

end