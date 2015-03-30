class Students_quantity_reportPdf < Prawn::Document 
  def initialize(students, view)
    super({top_margin: 50, page_size: 'A4', page_layout: :landscape })
    @students = students
    @view = view
    font "Times-Roman"
    image "#{Rails.root}/app/assets/images/logo_kerajaan.png", :position => :center, :scale => 0.45
    move_down 5
    text "BAHAGIAN PENGURUSAN LATIHAN", :align => :center, :size => 11, :style => :bold
    text "KEMENTERIAN KESIHATAN MALAYSIA", :align => :center, :size => 11, :style => :bold
    move_down 5
    text "BILANGAN PELATIH DI INSTITUSI LATIHAN KEMENTERIAN KESIHATAN MALAYSIA", :align => :center, :size => 11, :style => :italic
    move_down 5
    if Date.today.month < 7
    text "INSTITUSI LATIHAN : KOLEJ SAINS KESIHATAN BERSEKUTU JOHOR BAHRU                                  **SESI:JAN-JUN #{Date.today.year}  JUL-DIS.......", :align => :left, :size => 11, :style => :bold
    else
    text "INSTITUSI LATIHAN : KOLEJ SAINS KESIHATAN BERSEKUTU JOHOR BAHRU                                  **SESI:JAN-JUN......  JUL-DIS #{Date.today.year}", :align => :left, :size => 11, :style => :bold
    end
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
    header #+
#       @students.map do |student|
#       ["#{counter+=1}","#{student.formatted_mykad}", "#{student.name}", "#{student.display_matrixno}", "#{student.display_programme}", "#{student.display_intake}", "#{student.ssponsor}", "#{student.display_status}", "#{student.display_sstatus_remark}", "#{student.display_gender}", "#{student.display_race}", "#{student.display_marital}", "#{student.try(:stelno)}", "#{student.display_semail}"]
#     end
  end

end