class Academicsession_reportPdf < Prawn::Document
  def initialize(academicsessions, view, college)
    super({top_margin: 50, left_margin: 80, page_size: 'A4', page_layout: :portrait })
    @academicsessions = academicsessions
    @view = view
    @college=college
    font "Helvetica"
    record
    pages.count
  end
  
  def record
    table(line_item_rows, :column_widths => [30, 200, 200], :cell_style => { :size => 9,  :inline_format => :true}, :header => 2) do
      row(0).borders =[]
      row(0).height=50
      row(0).style size: 11
      row(0).align = :center
      row(0..1).font_style = :bold
      row(1).background_color = 'FFE34D'
      column(1..2).align = :center
    end
  end
  
  def line_item_rows
    counter = counter || 0
    header = [[{content: "#{I18n.t('training.academic_session.list').upcase}<br> #{@college.name.upcase}", colspan: 3}],
              [ 'No', 'Semester', I18n.t('training.academic_session.total_week')]]
    header +
    @academicsessions.map do |academic_session|
         ["#{counter += 1}", academic_session.semester, academic_session.total_week]
    end
  end
  
  def footer
    text ""
  end

end