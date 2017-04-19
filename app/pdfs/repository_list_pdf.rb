class Repository_listPdf < Prawn::Document
  def initialize(repositories, view, college)
    super({top_margin: 40, left_margin: 40, page_size: 'A4', page_layout: :portrait })
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
    if @repositories.first.data.blank?
      col_widths=[30, 60, 210, 210]
    else
      col_widths=[25, 50, 50, 70, 110, 55, 60, 95]
    end
    table(line_item_rows, :column_widths => col_widths , :cell_style => { :size => 9,  :inline_format => :true}, :header => 2) do
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
    
    if @repositories.first.data.blank?
      list=I18n.t('repositories.list')
      a= [ 'No', I18n.t('repositories.category'), I18n.t('repositories.document_title'), I18n.t('repositories.uploaded')]
      b=4
    else
      list=I18n.t('repositories.list2')
      a= [ 'No', I18n.t('repositories.document_type'), I18n.t('repositories.document_subtype'),   I18n.t('repositories.vessel'), "#{I18n.t('repositories.document_title')}<br><br>(#{I18n.t('repositories.copies')} / #{I18n.t('repositories.total_pages')}<br>#{I18n.t('repositories.location')})", I18n.t('repositories.refno'), I18n.t('repositories.publish_date'), I18n.t('repositories.uploaded')]
      b=8
    end
    header = [[{content: "#{list.upcase}<br> #{@college.name.upcase}", colspan: b}], a]
    body=[]
    if @repositories.first.data.blank?
      @repositories.map do |repository|
           body<< ["#{counter += 1}", repository.render_category, repository.title, repository.uploaded_file_name]
      end
    else
      @repositories.map do |repository|
          body<< ["#{counter += 1}",repository.render_document, repository.render_subdocument, repository.vessel, "#{repository.title}<br><br>(#{I18n.t('repositories.copies')} / #{I18n.t('repositories.total_pages')}: #{repository.copies}/#{repository.total_pages}<br>#{I18n.t('repositories.location')}: #{repository.location})", repository.refno, repository.publish_date, repository.uploaded_file_name]
      end
    end
    header+body
  end
  
  def footer
    draw_text "#{page_number} / #{page_count}",  :size => 8, :at => [470,-5]
  end

end