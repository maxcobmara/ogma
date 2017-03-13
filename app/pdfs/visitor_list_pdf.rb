class Visitor_listPdf < Prawn::Document
  def initialize(visitors, view, college)
    super({top_margin: 50, left_margin: 50, page_size: 'A4', page_layout: :portrait })
    @visitors = visitors
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
    table(line_item_rows, :column_widths => [30, 90, 200, 170], :cell_style => { :size => 9,  :inline_format => :true}, :header => 2) do
      row(0).borders =[]
      row(0).height=50
      row(0).style size: 11
      row(0).align = :center
      row(0..1).font_style = :bold
      row(1).background_color = 'FFE34D'
      column(1).align = :center
    end
  end

  def line_item_rows
    counter = counter || 0
    header = [[{content: "#{I18n.t('campus.visitors.list').upcase}<br> #{@college.name.upcase}", colspan: 4}],
              [ 'No', I18n.t('campus.visitors.icno'), I18n.t('campus.visitors.name'), I18n.t('campus.visitors.department_organisation')]]
    header +
    @visitors.map do |visitor|
         ["#{counter += 1}", @view.formatted_mykad(visitor.icno), visitor.visitor_with_title_rank, "#{visitor.address_book_id.blank? ? visitor.department : visitor.address_book.name}"]
    end
  end
  
  def footer
    draw_text "#{page_number} / #{page_count}",  :size => 8, :at => [470,-5]
  end

end