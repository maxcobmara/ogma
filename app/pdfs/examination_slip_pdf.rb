class Examination_slipPdf < Prawn::Document
  def initialize(resultline, view)
    super({top_margin: 20, left_margin:100, right_margin:80, page_size: 'A4', page_layout: :portrait })
    @resultline = resultline
    @view = view
    font "Helvetica"
    @cara_kerja=Programme.where(course_type: 'Diploma').where('name ILIKE (?)', 'Jurupulih Perubatan Cara Kerja').first.id
    if resultline.examresult.programme_id==@cara_kerja
      image "#{Rails.root}/app/assets/images/logo_kerajaan.png", :position => :center, :scale => 0.8
    else
      image "#{Rails.root}/app/assets/images/logo_kerajaan.png", :position => :center, :scale => 0.5
    end
    move_down 10
    if @resultline.examresult.programme_id==@cara_kerja
      text "LEMBAGA PENDIDIKAN", :align => :center, :size => 11, :style => :bold
      text "KEMENTERIAN KESIHATAN MALAYSIA", :align => :center, :size => 11, :style => :bold
    else
      text "JAWATANKUASA PEPERIKSAAN", :align => :center, :size => 11, :style => :bold
      text "KURSUS #{@resultline.examresult.programmestudent.programme_list.upcase}", :align => :center, :size => 11, :style => :bold
      text "LEMBAGA PENDIDIKAN", :align => :center, :size => 11, :style => :bold
      text "KEMENTERIAN KESIHATAN MALAYSIA", :align => :center, :size => 11, :style => :bold
    end
    move_down 10
    if resultline.examresult.programme_id==@cara_kerja
      text "Slip Keputusan Peperiksaan Akhir Semester", :align => :center, :size => 11
      text "#{@resultline.examresult.render_semester.split("/").join(" ")}  (#{@resultline.examresult.examdts.strftime('%b %Y')})", :align => :center, :size => 11
      text "Program #{@resultline.examresult.programmestudent.programme_list}", :align => :center, :size => 11
      text "Kolej Sains Kesihatan Bersekutu, Johor Bahru", :align => :center, :size => 11
    else
      text "SLIP KEPUTUSAN TERPERINCI MENGIKUT KOD KURSUS", :align => :center, :size => 11, :style => :bold
      move_down 20
      text " PUSAT PEPERIKSAAN : KOLEJ SAINS KESIHATAN BERSEKUTU JOHOR BAHRU", :align => :left, :size => 10
      text " KEPUTUSAN PEPERIKSAAN AKHIR TAHUN : #{(@resultline.examresult.render_semester).upcase}", :align => :left, :size => 10
      text " TAHUN PENGAMBILAN : #{@view.l(@resultline.student.intake)}", :align => :left, :size => 10
      text " TARIKH PEPERIKSAAN : #{@view.l(@resultline.examresult.examdts)} - #{@view.l(@resultline.examresult.examdte)}", :align => :left, :size => 10
    end
    move_down 10
    trainee
    move_down 15
    result_header
    result
    move_down 15
    summary
    move_down 25
    if @resultline.examresult.programme_id==@cara_kerja
    else
      signatory
    end
  end
  
  def trainee
    if @resultline.examresult.programme_id==@cara_kerja
        text "Nama                               : #{@resultline.student.name}", :size => 10
        text "Nombor Matriks               : #{@resultline.student.matrixno}", :size => 10
        text "No Kad Pengenalan         : #{@resultline.student.icno}", :size => 10
    else
        text " MAKLUMAT BIODATA PELATIH", :align => :left, :size => 10, :style => :bold
        data = [["Nama",": #{@resultline.student.name }"],
                 ["No Mykad", ": #{@resultline.student.icno}"],
                 ["No Matrik",": #{@resultline.student.matrixno} "]]
         table(data, :column_widths => [120 , 300], :cell_style => { :size => 10}) do
            self.width = 420
        end
    end
   
  end
  
  def result_header
    if @resultline.examresult.programme_id==@cara_kerja
        data = [["<b>Kod Kursus</b> ", "<b>Kursus</b> ", "<b>Gred</b> ", "<b>Nilai Gred</b> ", "<b>Tahap</b> "]]
        table(data, :column_widths => [50, 210, 50 , 60, 50], :cell_style => { :size => 10, :inline_format => :true}) do
            self.width = 420
        end
    else
        text "KEPUTUSAN PEPERIKSAAN AKHIR #{(@resultline.examresult.render_semester).upcase}", :align => :left, :size => 10, :style => :bold
        data = [["<b>Bil</b> ", "<b>Kod Kursus</b> ", "<b>Gred</b> ", "<b>Nilai Gred</b> ", "<b>Catatan</b> "]]
        table(data, :column_widths => [25, 235, 50 , 60, 50], :cell_style => { :size => 10, :inline_format => :true}) do
            self.width = 420
        end
    end
  end
    
  def result
    if @resultline.examresult.programme_id==@cara_kerja
        table(data2, :column_widths => [50, 210, 50 , 60, 50], :cell_style => { :size => 10, :inline_format => :true}) do
            self.width = 420
        end
    else
        table(data2, :column_widths => [25, 235, 50 , 60, 50], :cell_style => { :size => 10}) do
            self.width = 420
            columns(0).align =:center
        end
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
    if @resultline.examresult.programme_id==@cara_kerja
        subjects.map do |subject|
            [subject.code, subject.name, @grading[counter-1], @finale[counter-1], @remark[counter-1]]
        end 
    else
        subjects.map do |subject|
            ["#{counter += 1}", subject.subject_list, @grading[counter-1], @finale[counter-1], @remark[counter-1]]
        end 
    end
  end
  
  def summary
    chairman_notes= "Pengerusi dan Ahli-ahli Jawatankuasa Peperiksaan Kursus #{  }yang bermesyuarat pada ....................... telah mengesahkan keputusan Peperiksaan Akhir Tahun #{@resultline.examresult.render_semester} yang telah diadakan pada #{@view.l(@resultline.examresult.examdts)} - #{@view.l(@resultline.examresult.examdte)} seperti di atas."
    if @resultline.examresult.programme_id==@cara_kerja
        data = [["Purata Nilai Kredit Semester (PNGS 17)", ": #{@resultline.pngs17.nil? ? "0.00" : @view.number_with_precision(@resultline.pngs17, :precision => 2)}"],
                  ["Purata Nilai Gred Keseluruhan (PNGK 17)", ": #{@resultline.pngk.nil? ? "0.00" : @view.number_with_precision(@resultline.pngk, :precision => 2)}"],
                  ["Status", ": #{@resultline.render_status}"], ["",""], 
                  [{content: "Ini adalah cetakan komputer, tandatangan tidak diperlukan", colspan: 2}], 
                  [{content: "Tarikh: #{@view.l(Date.today)}", colspan: 2}]]
        table(data, :column_widths => [300 , 120], :cell_style => { :size => 10, :inline_format => :true}) do
            self.width = 420
            columns(0..1).borders = []
            rows(0..3).borders = []
        end
    else
        data = [["<b>#{(@resultline.examresult.render_semester).upcase}</b>","<b> JUMLAH</b>"],
                 ["Jumlah NGK (Nilai Gred Kumulatif)", @resultline.total.nil? ? "" : @view.number_with_precision(@resultline.total, :precision => 2)],
                 ["Purata Nilai Gred Semester (PNGS)", @resultline.pngs17.nil? ? "" : @view.number_with_precision(@resultline.pngs17, :precision => 2)],
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
  end 

  def signatory
    text "#{'.' * 60 }", :align => :center, :size => 10
    text "(#{Position.roots.first.staff.try(:title).try(:name)} #{Position.roots.first.staff.name})", :align => :center, :size => 11, :style => :bold
    text "#{Position.roots.first.name}", :align => :center, :size => 11
    text "Kolej Sains Kesihatan Bersekutu Johor Bahru", :align => :center, :size => 11
  end
end