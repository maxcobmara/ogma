class Discipline_reportPdf < Prawn::Document 
  def initialize(student_discipline_cases, view)
    super({top_margin: 50, page_size: 'A4', page_layout: :landscape})
    @student_discipline_cases= student_discipline_cases
    @view = view
    font "Times-Roman"
    text "Kolej Sains Kesihatan Bersekutu Johor Bahru", :align => :center, :size => 12, :style => :bold
    text "#{I18n.t('student.discipline.list')}", :align => :center, :size => 12, :style => :bold
    move_down 10
    record
  end
  
  def record
    table(line_item_rows, :column_widths => [30,70, 60, 150,120, 50, 50, 60, 60, 60], :cell_style => { :size => 8,  :inline_format => :true}) do
      row(0).font_style = :bold
      row(0).background_color = 'FFE34D'
      self.row_colors = ["FEFEFE", "FFFFFF"]
      self.header = true
      self.width = 780
      header = true
    end
  end
  
  def line_item_rows
    counter = counter || 0
    header = [[ "","#{I18n.t('student.students.matrixno')}", "#{I18n.t('student.students.icno')}", "#{I18n.t('student.students.name')}", "#{I18n.t('student.students.course_id')}", "#{I18n.t('student.students.intake_id')}", "#{I18n.t('student.discipline.reported_on')}","#{I18n.t('student.discipline.infraction_id')}", "#{I18n.t('student.discipline.room_no')}", "#{I18n.t('student.discipline.status')}", "#{I18n.t('student.discipline.action')}"]]   
      header +
        @student_discipline_cases.map do |discipline_case|
        ["#{counter += 1}", "#{discipline_case.student.matrixno}",  "#{discipline_case.student.icno}", "#{discipline_case.student.name}","#{discipline_case.student.course.programme_list}","#{discipline_case.student.intake.try(:strftime, '%b %Y')}", "#{discipline_case.reported_on.try(:strftime, '%d-%m-%Y')}", "#{discipline_case.render_infraction}" , "#{discipline_case.location.try(:name)}"," #{discipline_case.render_status}", "#{I18n.t('student.discipline.refer_bpl') if discipline_case.action_type=="Ref to BPL" && !discipline_case.action_type.blank?} #{I18n.t('student.discipline.refer_tphep') if discipline_case.action_type=="Ref TPHEP" && !discipline_case.action_type.blank?} #{I18n.t('student.discipline.no_case') if discipline_case.action_type=="no_case" && !discipline_case.action_type.blank? } #{I18n.t('student.discipline.advise') if discipline_case.action_type=="advise" && !discipline_case.action_type.blank?}"]
      end
  end
  
end
