class Anacdotal_reportPdf < Prawn::Document 
  def initialize(discipline_cases, view, college)
    super({top_margin: 50, page_size: 'A4', page_layout: :portrait })
    @discipline_cases= discipline_cases
    @view = view
    font "Times-Roman"
    text "#{college.name}", :align => :center, :size => 12, :style => :bold
    text "#{I18n.t('student.discipline.report_title')}", :align => :center, :size => 12, :style => :bold
    move_down 30
    text "#{I18n.t('student.students.name')} : #{@discipline_cases.first.student.name}", :align => :left, :size => 11, :indent_paragraphs => 10
    if college.code=="kskbjb"
      text "#{I18n.t('student.students.matrixno')} : #{@discipline_cases.first.student.try(:matrixno)}", :align => :left, :size => 11, :indent_paragraphs => 10
    end
    text "#{I18n.t('student.students.course_id')} : #{@discipline_cases.first.student.course.try(:programme_list)}", :align => :left, :size => 11, :indent_paragraphs => 10
    text "#{I18n.t('student.students.intake_id')} : #{@discipline_cases.first.student.intake_id? ? @discipline_cases.first.student.intakestudent.monthyear_intake.try(:strftime, '%b %Y') : @discipline_cases.first.student.intake.try(:strftime, '%b %Y')}", :align => :left, :size => 11, :indent_paragraphs => 10
    move_down 10
    record
  end
  
  def record
    table(line_item_rows, :column_widths => [30,70, 80, 170, 60, 60, 70], :cell_style => { :size => 10,  :inline_format => :true}) do
      row(0).font_style = :bold
      row(0).background_color = 'FFE34D'
      self.row_colors = ["FEFEFE", "FFFFFF"]
      self.header = true
      self.width = 470
      header = true
    end
  end
  
  def line_item_rows
    counter = counter || 0
    header = [[ "", "#{I18n.t('student.discipline.reported_on')}","#{I18n.t('student.discipline.infraction_id')}", "#{I18n.t('student.discipline.room_no')}", "#{I18n.t('student.discipline.status')}", "#{I18n.t('student.discipline.action')}"]]   
     header +
       @discipline_cases.map do |discipline_case|
       ["#{counter += 1}", "#{discipline_case.reported_on.try(:strftime, '%d-%m-%Y')}", "#{discipline_case.render_infraction}" , "#{discipline_case.location.try(:name)}"," #{discipline_case.render_status}", "#{I18n.t('student.discipline.refer_bpl') if discipline_case.action_type=="Ref to BPL" && !discipline_case.action_type.blank?} #{I18n.t('student.discipline.refer_tphep') if discipline_case.action_type=="Ref TPHEP" && !discipline_case.action_type.blank?} #{I18n.t('student.discipline.no_case') if discipline_case.action_type=="no_case" && !discipline_case.action_type.blank? } #{I18n.t('student.discipline.advise') if discipline_case.action_type=="advise" && !discipline_case.action_type.blank?}"]
     end
  end
  
end
