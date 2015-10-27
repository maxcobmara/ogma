class Examination_slipPdf < Prawn::Document
  def initialize(resultline, view)
    super({top_margin: 20, left_margin:100, page_size: 'A4', page_layout: :portrait })
    @resultline = resultline
    @view = view
    font "Times-Roman"
    image "#{Rails.root}/app/assets/images/logo_kerajaan.png", :position => :center, :scale => 0.5
    move_down 10
    text "JAWATANKUASA PEPERIKSAAN", :align => :center, :size => 11, :style => :bold
    text "KURSUS #{@resultline.examresult.programmestudent.programme_list.upcase}", :align => :center, :size => 11, :style => :bold
    text "LEMBAGA PENDIDIKAN", :align => :center, :size => 11, :style => :bold
    text "KEMENTERIAN KESIHATAN MALAYSIA", :align => :center, :size => 11, :style => :bold
    move_down 10
    text "SLIP KEPUTUSAN TERPERINCI MENGIKUT KOD KURSUS", :align => :center, :size => 11, :style => :bold
    move_down 20
    text " PUSAT PEPERIKSAAN : KOLEJ SAINS KESIHATAN BERSEKUTU JOHOR BAHRU", :align => :left, :size => 10
    text " KEPUTUSAN PEPERIKSAAN AKHIR TAHUN : #{(@resultline.examresult.render_semester).upcase}", :align => :left, :size => 10
    text " TAHUN PENGAMBILAN : #{@view.l(@resultline.student.intake)}", :align => :left, :size => 10
    text " TARIKH PEPERIKSAAN : #{@view.l(@resultline.examresult.examdts)} - #{@view.l(@resultline.examresult.examdte)}", :align => :left, :size => 10
    move_down 10
    trainee
    move_down 15
    result_header
    result
    move_down 15
    summary
    move_down 25
    signatory
  end
  
  def trainee
    text " MAKLUMAT BIODATA PELATIH", :align => :left, :size => 10, :style => :bold
    data = [["Nama",": #{@resultline.student.name }"],
             ["MyKad No", ": #{@resultline.student.icno}"],
             ["Matrik No",": #{@resultline.student.matrixno} "]]
    table(data, :column_widths => [120 , 300], :cell_style => { :size => 10}) do
      self.width = 420
    end
  end
  
  def result_header
    text "KEPUTUSAN PEPERIKSAAN AKHIR #{(@resultline.examresult.render_semester).upcase}", :align => :left, :size => 10, :style => :bold
    data = [["<b>Bil</b> ", "<b>Kod Kursus</b> ", "<b>Gred</b> ", "<b>Nilai Gred</b> ", "<b>Catatan</b> "]]
    table(data, :column_widths => [25, 235, 50 , 60, 50], :cell_style => { :size => 10, :inline_format => :true}) do
      self.width = 420
    end
  end
    
  def result
    table(data2, :column_widths => [25, 235, 50 , 60, 50], :cell_style => { :size => 10}) do
      self.width = 420
      columns(0).align =:center
    end
  end
    
  def data2
    programme_id = @resultline.examresult.programmestudent.id
    semester = @resultline.examresult.semester
    subjects = Examresult.get_subjects(programme_id ,semester)
    @grading=[]
    @finale=[]
    @remark=[]
    for subject in subjects
      student_grade = Grade.where('student_id=? and subject_id=?',@resultline.student.id,subject.id).first
      unless student_grade.nil? || student_grade.blank?
        grading = student_grade.set_gred 
      else
        grading = ""
      end
      @grading << grading
      student_finale = Grade.where('student_id=? and subject_id=?',@resultline.student.id,subject.id).first
      unless student_finale.nil? || student_finale.blank? 
        @finale << @view.sprintf('%.2f', student_finale.set_NG.to_f)
      else
        @finale << "0.00"
      end
      if grading=="A" || @grading=="A-" ||@grading=="B+"||@grading=="B"||@grading=="B-"||@grading=="C+"||@grading=="C"
        @remark << I18n.t('exam.examresult.passed')
      else 
        @remark << I18n.t('exam.examresult.failed')
      end
    end
    counter = counter || 0
    subjects.map do |subject|
        ["#{counter += 1}", subject.subject_list, @grading[counter-1], @finale[counter-1], @remark[counter-1]]
    end  
  end
  
  def summary
    chairman_notes= "Pengerusi dan Ahli-ahli Jawatankuasa Peperiksaan Kursus #{  }yang bermesyuarat pada ....................... telah mengesahkan keputusan Peperiksaan Akhir Tahun #{@resultline.examresult.render_semester} yang telah diadakan pada #{@view.l(@resultline.examresult.examdts)} - #{@view.l(@resultline.examresult.examdte)} seperti di atas."
    
    data = [["<b>#{(@resultline.examresult.render_semester).upcase}</b>","<b> JUMLAH</b>"],
             ["Jumlah NGK (Nilai Gred Kumulatif)", @resultline.total.nil? ? "" : @view.number_with_precision(@resultline.total, :precision => 2)],
             ["Purata Nilai Gred Semester (PNGS)", @resultline.pngs17.nil? ? "" : @view.number_with_precision(@resultline.pngs17, :precision => 2) ],
           ["Purata Nilai Gred Kumulatif (PNGK)", @resultline.pngk.nil? ? "" : @view.number_with_precision(@resultline.pngk, :precision => 2) ],
           ["<b>STATUS</b>", @resultline.render_status] ]
    data << [{content: chairman_notes, colspan: 2}]
      table(data, :column_widths => [300 , 120], :cell_style => { :size => 10, :inline_format => :true}) do
      self.width = 420
      columns(1).align =:center
      rows(5).borders=[:top]
      rows(5).align=:justify
    end
  end 

  def signatory
    text "#{'.' * 60 }", :align => :center, :size => 10
    text "(#{Position.roots.first.staff.try(:title).try(:name)} #{Position.roots.first.staff.name})", :align => :center, :size => 11, :style => :bold
    text "#{Position.roots.first.name}", :align => :center, :size => 11
    text "Kolej Sains Kesihatan Bersekutu Johor Bahru", :align => :center, :size => 11
  end
end