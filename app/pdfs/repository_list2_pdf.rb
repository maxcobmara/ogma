class Repository_list2Pdf < Prawn::Document
  def initialize(repositories, view, college)
    super({top_margin: 30, left_margin: 40, page_size: 'A4', page_layout: :landscape })
    @repositories = repositories
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
    table(line_item_rows, :column_widths => [30, 65, 80, 80, 140, 80, 60, 60, 60, 110] , :cell_style => { :size => 9,  :inline_format => :true}, :header => 2) do
      row(0).borders =[]
      row(0).height=40
      row(0).style size: 11
      row(0).align = :center
      row(0..1).font_style = :bold
      row(1).background_color = 'FFE34D'
      column(1).align = :center
      column(8).align = :center
    end
  end
  
  def line_item_rows
    counter = counter || 0
    #header = [[{content: "#{list.upcase}<br> #{@college.name.upcase}", colspan: b}], a]
    
    header = [[{content: "#{I18n.t('repositories.list2')}", colspan: 10}], [ 'No', I18n.t('repositories.document_type'), I18n.t('repositories.document_subtype'),   I18n.t('repositories.vessel'), I18n.t('repositories.document_title'), I18n.t('repositories.refno'), I18n.t('repositories.publish_date'), I18n.t('repositories.location'), I18n.t('repositories.classification'), I18n.t('repositories.uploaded')]]
    #"#{I18n.t('repositories.copies')} / #{I18n.t('repositories.total_pages')}"
    header+
    @repositories.map do |repository|
          ["#{counter += 1}",repository.render_document, repository.render_subdocument, repository.vessel, repository.title, repository.refno, repository.publish_date, repository.location, repository.render_classification, repository.uploaded_file_name]
      end
     #"#{repository.copies} / #{repository.total_pages}"
  end
  
  def footer
    draw_text "#{page_number} / #{page_count}",  :size => 8, :at => [750,-5]
  end

end