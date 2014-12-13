class Examination_slipPdf < Prawn::Document
  def initialize(student, view, programme_id)
    super({top_margin: 20, left_margin:100, page_size: 'A4', page_layout: :portrait })
    @student = student
    @view = view
    @programme_id = programme_id
    font "Times-Roman"
    image "#{Rails.root}/app/assets/images/logo_kerajaan.png", :position => :center, :scale => 0.5
    move_down 10
    text "JAWATANKUASA PEPERIKSAAN", :align => :center, :size => 12, :style => :bold
    text "KURSUS #{ }", :align => :center, :size => 12, :style => :bold
    text "LEMBAGA PENDIDIKAN", :align => :center, :size => 12, :style => :bold
    text "KEMENTERIAN KESIHATAN MALAYSIA", :align => :center, :size => 12, :style => :bold
    move_down 10
    text "SLIP KEPUTUSAN TERPERINCI MENGIKUT KOD KURSUS", :align => :center, :size => 12, :style => :bold
    move_down 20
    text " PUSAT PEPERIKSAAN : KOLEJ KEJURURAWATAN JOHOR BAHRU", :align => :left, :size => 12
    text " KEPUTUSAN PEPERIKSAAN AKHIR TAHUN #{ }", :align => :left, :size => 12
    text " TAHUN PENGAMBILAN : #{ }", :align => :left, :size => 12
    text " TARIKH PEPERIKSAAN : #{ }", :align => :left, :size => 12
    move_down 10
    pelatih
    keputusan
    #result
    jumlah
   
  end
  
  def pelatih 
    text " MAKLUMAT BIODATA PELATIH", :align => :left, :size => 12, :style => :bold
    data = [["Nama",": #{ }"],
             ["MyKad No", ": #{ }"],
             ["Matrik No",": #{ } "]]
             
      table(data, :column_widths => [100 , 300], :cell_style => { :size => 10}) do
      self.width = 400
    end
  end
  
  
  def keputusan
    move_down 15
     text "KEPUTUSAN PEPERIKSAAN AKHIR #{ }", :align => :left, :size => 12, :style => :bold
     
    data = [["Bil", "Kod Kursus ", "Gred ", "Nilai Gred ", "Catatan "]]
    
    table(data, :column_widths => [40, 170, 50 , 60, 80], :cell_style => { :size => 10}) do
     self.width = 400
    end
  end
    
    def result
      table(data2, :column_widths => [40, 170, 50 , 60, 80], :cell_style => { :size => 10}) do
       self.width = 540
      end
    end
    
    def data2
      @programme_id = @resultline.examresult.programmestudent.id
      @semester = @resultline.examresult.semester
      @subjects = Examresult.get_subjects(@programme_id ,@semester)
    counter = counter || 0
      @subjects.map do |subjects|
      ["#{counter += 1}", " ", " ", " ", " "]
      #end
    end  
  end
  
  def jumlah
    move_down 10
    
    data = [["tahun #{ }"," JUMLAH"],
             ["Jumlah NGK (Nilai Gred Kumulatif)", " #{ }"],
             ["Purata Nilai Gred Semester (PNGS)"," #{ } "],
           ["Purata Nilai Gred Kumulatif (PNGK)", " #{ }"],
           ["STATUS", " #{ }"] ]
             
      table(data, :column_widths => [300 , 100], :cell_style => { :size => 10}) do
      self.width = 400
    end
    move_down 10
    text "Pengerusi dan Ahli-ahli Jawatankuasa Peperiksaan Kursus #{  }yang bermesyuarat pada ........ telah mengesahkan keputusan Peperiksaan Akhir Tahun #{  } yang telah diadakan pada #{  } - #{ } seperti di atas.", :align => :left, :size => 11
   
   move_down 25
   text "#{'.' * 60 }", :align => :center, :size => 10
   text "(HJ.MOHD ZULKIFLI BIN MOHD TAHIR)", :align => :center, :size => 11, :style => :bold
   text "Pengarah", :align => :center, :size => 11
   text "Kolej Sains Kesihatan Bersekutu Johor Bahru", :align => :center, :size => 11
   
  end
  
  
end