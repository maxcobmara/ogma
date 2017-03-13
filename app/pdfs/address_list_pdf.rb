class Address_listPdf < Prawn::Document
  def initialize(address_books, view, college)
    super({top_margin: 40, left_margin: 50, page_size: 'A4', page_layout: :portrait })
    @address_books = address_books
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
    table(line_item_rows, :column_widths => [30, 120, 80, 170, 90], :cell_style => { :size => 9,  :inline_format => :true}, :header => 2) do
      row(0).borders =[]
      row(0).height=50
      row(0).style size: 11
      row(0).align = :center
      row(0..1).font_style = :bold
      row(1).background_color = 'FFE34D'
    end
  end

  def line_item_rows
    counter = counter || 0
    header = [[{content: "#{I18n.t('campus.address.title').upcase}<br> #{@college.name.upcase}", colspan: 5}],
              [ 'No', I18n.t('campus.address.name'), I18n.t('campus.address.shortname'), I18n.t('campus.address.address'), I18n.t('campus.address.internet')]]
    header +
    @address_books.map do |contact|
         ["#{counter += 1}", contact.shortname, contact.name, "#{contact.address}<br>#{contact.phone}<br>#{contact.fax}", "#{contact.mail}<br>#{contact.web}"]
    end
  end
  
  def footer
    draw_text "#{page_number} / #{page_count}",  :size => 8, :at => [470,-5]
  end

end