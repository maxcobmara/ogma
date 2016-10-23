class Discipline_reportPdf < Prawn::Document 
  def initialize(student_discipline_cases, view, college)
    super({top_margin: 50, page_size: 'A4', page_layout: :landscape})
    @student_discipline_cases= student_discipline_cases
    @view = view
    @college=college
    font "Times-Roman"
    text "#{college.name}", :align => :center, :size => 12, :style => :bold
    text "#{I18n.t('student.discipline.list')}", :align => :center, :size => 12, :style => :bold
    move_down 10
    record
  end
  
  def record
    if @college.code=="kskbjb"
      table(line_item_rows, :column_widths => [30,70, 60, 150,120, 50, 50, 60, 60, 60], :cell_style => { :size => 8,  :inline_format => :true}) do
        row(0).font_style = :bold
        row(0).background_color = 'FFE34D'
        self.row_colors = ["FEFEFE", "FFFFFF"]
        self.header = true
        self.width = 780
        header = true
      end
    elsif @college.code=="amsas"
      table(line_item_rows, :column_widths => [30, 60, 130,120, 55, 50, 60, 60, 55,160], :cell_style => { :size => 8,  :inline_format => :true}) do
        row(0).font_style = :bold
        row(0).background_color = 'FFE34D'
        self.row_colors = ["FEFEFE", "FFFFFF"]
        self.header = true
        self.width = 780
        header = true
      end
    end
  end
  
  def line_item_rows
    counter = counter || 0
    header=[]
    body=[]
    no=[""]
    matrix=["#{I18n.t('student.students.matrixno')}"]
    details=[ "#{I18n.t('student.students.icno')}", "#{I18n.t('student.students.name')}", "#{I18n.t('student.students.course_id')}", "#{I18n.t('student.students.intake_id')}", "#{I18n.t('student.discipline.reported_on')}","#{I18n.t('student.discipline.infraction_id')}", "#{I18n.t('student.discipline.room_no')}", "#{I18n.t('student.discipline.status')}", "#{I18n.t('student.discipline.action')}"]
    if @college.code=="kskbjb"
      header << no+matrix+details
    elsif @college.code=="amsas"
      header << no+details
    end  
      @student_discipline_cases.each do |discipline_case|
        body_no=["#{counter += 1}"]
        body_matrix=[ "#{discipline_case.student.matrixno}"]
        body_details=[ "#{discipline_case.student.icno}", "#{discipline_case.student.student_with_rank}","#{discipline_case.student.course.programme_list}","#{discipline_case.college.code=='amsas' ? 'Siri '+discipline_case.student.intakestudent.monthyear_intake.strftime('%m/%Y') : discipline_case.student.intakestudent.monthyear_intake.strftime('%b %Y')}", "#{discipline_case.reported_on.try(:strftime, '%d-%m-%Y')}", "#{discipline_case.render_infraction}" , "#{[3,4].include?(discipline_case.location.root.lclass) ? discipline_case.location.try(:combo_code) : discipline_case.location.try(:name)}"," #{discipline_case.render_status}","#{discipline_case.action_type=='no_case' ? I18n.t('student.discipline.no_case') : discipline_case.render_action_by+' - '} #{discipline_case.action}"]
	#ACTION
	# "#{I18n.t('student.discipline.refer_bpl') if discipline_case.action_type=="Ref to BPL" && !discipline_case.action_type.blank?} #{I18n.t('student.discipline.refer_tphep') if discipline_case.action_type=="Ref TPHEP" && !discipline_case.action_type.blank?} #{I18n.t('student.discipline.no_case') if discipline_case.action_type=="no_case" && !discipline_case.action_type.blank? } #{I18n.t('student.discipline.advise') if discipline_case.action_type=="advise" && !discipline_case.action_type.blank?}"
        if @college.code=="kskbjb"
        body << body_no+body_matrix+body_details
        elsif @college.code=="amsas"
          body << body_no+body_details
        end
      end
      header+body
  end
  
end
