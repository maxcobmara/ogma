class Student_reportPdf < Prawn::Document 
  def initialize(students, view, intake_programme_id, college)
    super({top_margin: 50, page_size: 'A4', page_layout: :landscape })
    @students = students
    @view = view
    @college = college
    if @college.code=='amsas'
      course=Intake.find(intake_programme_id).programme
    else
      course=Programme.find(intake_programme_id)
    end
    font "Times-Roman"
    text "#{college.name}", :align => :center, :size => 12, :style => :bold
    text "#{Programme.find(programme_id).programme_list}", :align => :center, :size => 12, :style => :bold
    text "#{I18n.t('student.students.list')}", :align => :center, :size => 12, :style => :bold
    move_down 10
    record
  end
  
  def record
    table(line_item_rows, :column_widths => [25,70,110,60,80,40,40,40,40,40,40,40,60,100], :cell_style => { :size => 8,  :inline_format => :true}) do
      row(0).font_style = :bold
      row(0).background_color = 'FFE34D'
      self.row_colors = ["FEFEFE", "FFFFFF"]
      self.header = true
      self.width = 785
      header = true
    end
  end
  
  def line_item_rows
    # NOTE - blank includes: nil, false, [], {}, ""
    #a="\'\'"              #use in Excel (remove '' from empty cells)
    #a=nil                 #use in PDF (remove '' from empty cells))
    counter = counter || 0
    header =[ ["", "#{I18n.t('student.students.icno')}", "#{I18n.t('student.students.name')}", "#{I18n.t('student.students.matrixno')}", "#{I18n.t('student.students.course_id')}", "#{I18n.t('student.students.intake_id')}","#{I18n.t('student.students.ssponsor')}", "Status", "#{I18n.t('student.students.status_remark')}", "#{I18n.t('student.students.gender')}", "#{I18n.t('student.students.race')}", "#{I18n.t('student.students.mrtlstatuscd')}", "#{I18n.t('student.students.stelno')}", "#{I18n.t('student.students.semail')}"]]
    header +
      @students.map do |student|
      ["#{counter+=1}","#{student.formatted_mykad}", "#{student.name}", "#{student.matrixno unless student.matrixno.blank?}", "#{student.display_programme}", "#{@college.code=='amsas' ? student.display_intake_amsas : student.display_intake}", "#{student.ssponsor}", "#{student.render_status unless student.sstatus.blank?}", "#{student.sstatus_remark unless student.sstatus_remark.blank?}", "#{student.display_gender}", "#{student.display_race}", "#{student.render_marital unless student.mrtlstatuscd}", "#{student.try(:stelno)}", "#{student.display_semail}"]
    end
  end
  
  #header =[ ["#{counter}", "#{I18n.t('student.students.name')}", "","","","","","","","","","","","","","","","","","","","","","",""]]
  #["#{counter += 1}", "#{student.name}","","","","","","","","","","","","","","","","","","","","","","",""]
  
#   header =[ ["", "#{I18n.t('student.students.icno')}", "#{I18n.t('student.students.name')}", "#{I18n.t('student.students.matrixno')}", "#{I18n.t('student.students.course_id')}", "#{I18n.t('student.students.intake_id')}", "#{I18n.t('student.students.regdate')}", "#{I18n.t('student.students.end_training')}", "#{I18n.t('student.students.offer_letter_serial')}", "#{I18n.t('student.students.ssponsor')}", "Status", "#{I18n.t('student.students.status_remark')}", "#{I18n.t('student.students.gender')}", "#{I18n.t('student.students.race')}", "#{I18n.t('student.students.mrtlstatuscd')}", "#{I18n.t('student.students.stelno')}", "#{I18n.t('student.students.semail')}", "#{I18n.t('student.students.sbirthd')}"]]
#     header +
#       @students.map do |student|
#       ["#{counter+=1}","#{student.formatted_mykad}", "#{student.name}", "#{student.display_matrixno}", "#{student.display_programme}", "#{student.display_intake}", "#{student.display_regdate}", "#{student.display_enddate}", "#{student.display_offer_letter}", "#{student.ssponsor}", "#{student.display_status}", "#{student.display_sstatus_remark}", "#{student.display_gender}", "#{student.display_race}", "#{student.display_marital}", "#{student.try(:stelno)}", "#{student.display_semail}", "#{student.display_birthdate}"]
  
end
