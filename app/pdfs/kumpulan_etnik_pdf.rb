class Kumpulan_etnikPdf < Prawn::Document
  def initialize(student, view)
    super({top_margin: 20, page_size: 'A4', page_layout: :landscape })
    @student = student
    @view = view
    font "Times-Roman"
    image "#{Rails.root}/app/assets/images/logo_kerajaan.png", :position => :center
    move_down 5
    text "BAHAGIAN PENGURUSAN LATIHAN", :align => :center, :size => 12, :style => :bold
    text "KEMENTERIAN KESIHATAN MALAYSIA", :align => :center, :size => 12, :style => :bold
    move_down 5
    text "MAKLUMAT KUMPULAN ETNIK PELATIH DI INSTITUSI LATIHAN KEMENTERIAN KESIHATAN MALAYSIA", :align => :center, :size => 12, :style => :bold
    move_down 5
    text "INSTITUSI LATIHAN : KOLEJ SAINS KESIHATAN BERSEKUTU JOHOR BAHRU   **SESI:JAN-JUN......JUL-DIS.......", :align => :left, :size => 12, :style => :bold
    move_down 5
    kumpulan_tajuk
    kumpulan_data
    cop
   
  end
  
  
  def kumpulan_tajuk
    
    data = [["", "", "", "KUMPULAN ETNIK",""]]
    
    table(data, :column_widths => [80, 50, 50, 500, 50], :cell_style => { :size => 8}) do
      columns(3).align = :center
    end
  end
  
  def kumpulan_data
    
    data = [["JENIS PROGRAM/KURSUS","KUMP","Jantina", "Melayu","Cina","India","org Asli","Bajau","Murut","Brunei","Bisaya","Kadazan","Suluk","Kedayan","Iban","Kadazan Dusun","Sungai","Siam","Malanau","Bugis","Bidayuh","momogu n Rungus","Dusun","Lain-lain","JUMLAH"],
            ["","T1Si","P","","","","","","","","","","","","","","","","","","","","","",""],
            ["","","L","","","","","","","","","","","","","","","","","","","","","",""],
            ["","T1Sii","P","","","","","","","","","","","","","","","","","","","","","",""],
            ["","","L","","","","","","","","","","","","","","","","","","","","","",""],
            ["","T2Si","P","","","","","","","","","","","","","","","","","","","","","",""],
            ["","","L","","","","","","","","","","","","","","","","","","","","","",""],
            ["","T2Sii","P","","","","","","","","","","","","","","","","","","","","","",""],
            ["","","L","","","","","","","","","","","","","","","","","","","","","",""],
            ["","T3Si","P","","","","","","","","","","","","","","","","","","","","","",""],
            ["","","L","","","","","","","","","","","","","","","","","","","","","",""],
            ["","T3Sii","P","","","","","","","","","","","","","","","","","","","","","",""],
            ["","","L","","","","","","","","","","","","","","","","","","","","","",""],
            ["","JUMLAH"," ","","","","","","","","","","","","","","","","","","","","","",""]]
            
            table(data, :column_widths => [80, 50, 50, 25, 25, 25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25, 50], :cell_style => { :size => 8}) do
              columns(0).align = :center
            end
end

def cop
  move_down 10
  text "* P - Perempuan", :align => :left, :size => 12, :indent_paragraphs => 30
  text "* L - Lelaki", :align => :left, :size => 12, :indent_paragraphs => 30
  
  text "Disediakan oleh :                                                             Disahkan oleh : ", :align => :left, :size => 12, :indent_paragraphs => 40
  
  text "---------------------------                                                 -----------------------------", :align => :left, :size => 12, :indent_paragraphs => 30
  text "Nama :                                                                                    Pengarah", :align => :left, :size => 12, :indent_paragraphs => 30
  text "Jawatan", :align => :left, :size => 12, :indent_paragraphs => 30
  
  text "Catatan : ", :align => :left, :size => 12, :indent_paragraphs => 30
  text "* Laporan setiap 6 bulan pada 15 Februari &
  15 Ogos", :align => :left, :size => 12, :indent_paragraphs => 30
  
  
end
end