class Timetable_reportPdf < Prawn::Document
  def initialize(timetables, view, college)
    super({top_margin: 50, page_size: 'A4', page_layout: :portrait })
    @timetables = timetables
    @view = view
    @college=college
    font "Helvetica"
    record
  end
  
  def record
    table(line_item_rows, :column_widths => [30, 30, 90, 90, 80, 200], :cell_style => { :size => 9,  :inline_format => :true}, :header => 2) do
      row(0).borders =[]
      row(0).height=50
      row(0).style size: 11
      row(0).align = :center
      row(0..1).font_style = :bold
      row(1).background_color = 'FFE34D'
      self.row_colors = ["FEFEFE", "FFFFFF"]
      #self.width = 540
      header = true
    end
  end
  
  
  def line_item_rows
    counter = counter || 0
    header = [[{content: "#{I18n.t('training.timetable.list').upcase}<br> #{@college.name.upcase}", colspan: 6}],
              [ 'No', I18n.t('training.timetable.code'), I18n.t('training.timetable.name'), I18n.t('training.timetable.description'), I18n.t('training.timetable.created_by'), "Periods"]]
    body=[]
    @timetables.each do |timetable|
          a=""
          for period in timetable.timetable_periods
             a+=period.timing_24hrs+"  #{period.is_break? ? period.render_no_class : ''}#{period.non_class.blank? && period.is_break? ? I18n.t('training.timetable_period.is_break') : ''}"+"<br>"
          end
          body << ["#{counter += 1}", timetable.try(:code), timetable.try(:name), timetable.try(:description), timetable.creator.try(:staff_with_rank), a]
     end
     header+body
  end
end