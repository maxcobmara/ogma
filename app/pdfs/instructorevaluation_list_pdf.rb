class Instructorevaluation_listPdf < Prawn::Document
  def initialize(instructor_appraisals, view, college)
    super({top_margin: 40, left_margin: 60, page_size: 'A4', page_layout: :portrait })
    @instructor_appraisals = instructor_appraisals
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
    table(line_item_rows, :column_widths => [30, 140, 60, 50, 55, 100, 60], :cell_style => { :size => 9,  :inline_format => :true}, :header => 2) do
      row(0).borders =[]
      row(0).height=50
      row(0).style size: 11
      row(0).align = :center
      row(0..1).font_style = :bold
      row(1).background_color = 'FFE34D'
      columns(3..4).align=:center
    end
  end

  def line_item_rows
    counter = counter || 0
    header = [[{content: "#{I18n.t('instructor_appraisal.list').upcase}<br> #{@college.name.upcase}", colspan: 7}],
              [ 'No', I18n.t('instructor_appraisal.staff_id'), I18n.t('instructor_appraisal.appraisal_date'), I18n.t('instructor_appraisal.qc_sent'), I18n.t('instructor_appraisal.checked'), I18n.t('instructor_appraisal.check_qc'), I18n.t('instructor_appraisal.check_date')]]
    header +
    @instructor_appraisals.map do |instructor_appraisal|
         ["#{counter += 1}",  instructor_appraisal.instructor.staff_with_rank, instructor_appraisal.appraisal_date.try(:strftime, '%d-%m-%Y'), "#{ instructor_appraisal.qc_sent==nil ? '-' :  (instructor_appraisal.qc_sent==true ? I18n.t('yes2') : I18n.t('no2'))}", "#{ instructor_appraisal.checked==nil ? '-' : (instructor_appraisal.checked==true ? I18n.t('yes2') : I18n.t('no2'))}",  instructor_appraisal.checker.try(:staff_with_rank), instructor_appraisal.check_date.try(:strftime, '%d-%m-%Y') ]
    end
  end
  
  def footer
    draw_text "#{page_number} / #{page_count}",  :size => 8, :at => [490,-5]
  end

end