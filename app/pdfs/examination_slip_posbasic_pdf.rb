class Examination_slipPdf < Prawn::Document
  def initialize(resultline, view)
    super({top_margin: 20, left_margin:100, right_margin:80, page_size: 'A4', page_layout: :portrait })
    @resultline = resultline
    @view = view
    font "Helvetica"
    @cara_kerja=Programme.where(course_type: 'Diploma').where('name ILIKE (?)', 'Jurupulih Perubatan Cara Kerja').first.id
    @fisioterapi=Programme.where(course_type: 'Diploma').where('name ILIKE (?)', '%Fisioterapi%').first.id
    @perubatan=Programme.where(course_type: 'Diploma').where('name ILIKE (?)', 'Penolong Pegawai Perubatan').first.id
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
      text " KEPUTUSAN PEPERIKSAAN AKHIR : #{(@resultline.examresult.render_semester.split("/").join(" ")).upcase}", :align => :left, :size => 10
      sesi_data
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
    certificate     #replacing clause ('chairman_notes') with authority body.
    #- signatory - remove previous format for Kejururawatan (signature line, staff name, position & college name) for all programmes
  end