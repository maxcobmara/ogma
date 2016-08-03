class Student_reportPdf < Prawn::Document 
  def initialize(students, view, programme_id, college)
    super({top_margin: 50, page_size: 'A4', page_layout: :landscape })
    @students = students
    @view = view
    course=Programme.find(programme_id)
    font "Times-Roman"
    text "#{college.name}", :align => :center, :size => 12, :style => :bold
    text "#{course.name} #{college.code=="amsas" ? ' - '+course.course_type : ''}", :align => :center, :size => 12, :style => :bold
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
    counter = counter || 0
    header =[ ["", "#{I18n.t('student.students.icno')}", "#{I18n.t('student.students.name')}", "#{I18n.t('student.students.matrixno')}", "#{I18n.t('student.students.course_id')}", "#{I18n.t('student.students.intake_id')}","#{I18n.t('student.students.ssponsor')}", "Status", "#{I18n.t('student.students.status_remark')}", "#{I18n.t('student.students.gender')}", "#{I18n.t('student.students.race')}", "#{I18n.t('student.students.mrtlstatuscd')}", "#{I18n.t('student.students.stelno')}", "#{I18n.t('student.students.semail')}"]]
    header +
      @students.map do |student|
      ["#{counter+=1}","#{student.formatted_mykad}", "#{student.name}", "#{student.display_matrixno}", "#{student.display_programme}", "#{student.display_intake}", "#{student.ssponsor}", "#{student.display_status}", "#{student.display_sstatus_remark}", "#{student.display_gender}", "#{student.display_race}", "#{student.display_marital}", "#{student.try(:stelno)}", "#{student.display_semail}"]
    end
  end
  
  #header =[ ["#{counter}", "#{I18n.t('student.students.name')}", "","","","","","","","","","","","","","","","","","","","","","",""]]
  #["#{counter += 1}", "#{student.name}","","","","","","","","","","","","","","","","","","","","","","",""]
  
#   header =[ ["", "#{I18n.t('student.students.icno')}", "#{I18n.t('student.students.name')}", "#{I18n.t('student.students.matrixno')}", "#{I18n.t('student.students.course_id')}", "#{I18n.t('student.students.intake_id')}", "#{I18n.t('student.students.regdate')}", "#{I18n.t('student.students.end_training')}", "#{I18n.t('student.students.offer_letter_serial')}", "#{I18n.t('student.students.ssponsor')}", "Status", "#{I18n.t('student.students.status_remark')}", "#{I18n.t('student.students.gender')}", "#{I18n.t('student.students.race')}", "#{I18n.t('student.students.mrtlstatuscd')}", "#{I18n.t('student.students.stelno')}", "#{I18n.t('student.students.semail')}", "#{I18n.t('student.students.sbirthd')}"]]
#     header +
#       @students.map do |student|
#       ["#{counter+=1}","#{student.formatted_mykad}", "#{student.name}", "#{student.display_matrixno}", "#{student.display_programme}", "#{student.display_intake}", "#{student.display_regdate}", "#{student.display_enddate}", "#{student.display_offer_letter}", "#{student.ssponsor}", "#{student.display_status}", "#{student.display_sstatus_remark}", "#{student.display_gender}", "#{student.display_race}", "#{student.display_marital}", "#{student.try(:stelno)}", "#{student.display_semail}", "#{student.display_birthdate}"]
  
end
