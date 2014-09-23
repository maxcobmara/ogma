class Appraisal_formPdf < Prawn::Document
  def initialize(staff_appraisal, view)
    super({top_margin: 50, page_size: 'A4', page_layout: :portrait })
    @staff_appraisal = staff_appraisal
    @view = view
    font "Times-Roman"
    text "BORANG J.P.A. (Prestasi) ", :align => :right, :size => 12, :style => :bold
    text "SULIT", :align => :left, :size => 12
    text "No. K.P", :align => :right, :size => 12, :style => :bold
    move_down 10
    text "KERAJAAN MALAYSIA", :align => :center, :size => 12, :style => :bold   
    move_down 10
    text "LAPORAN PENILAIAN PRESTASI", :align => :center, :size => 12, :style => :bold    
    text "PEGAWAI KUMPULAN SOKONGAN (1)", :align => :center, :size => 12, :style => :bold 
    text "Tahun ", :align => :center, :size => 10, :style => :bold 
    move_down 10
    tajuk1
    tajuk2
    jawatan
   
  end
  
  def tajuk1
    data = [["PERINGATAN"],
           ["Pegawai Penilai (PP) iaitu Pegawai Penilai Pertama (PPP) dan Pegawai Penilai Kedua (PPK) serta Pegawai Yang Dinilai (PYD) hendaklah 
             memberi perhatian kepada perkara-perkara berikut sebelum dan semasa membuat penilaian:" ]]
   
    table(data , :column_widths => [400], :cell_style => { :size => 10}) do
     row(0).borders = [:left, :right, :top]
     row(1).borders = [:left, :right]
     row(0).font_style = :bold
     row(0).background_color = 'FFE34D'

    end 
    
    data1 = [['	i.', "PYD hendaklah melengkapkan maklumat di Bahagian I di bawah dan Bahagian I dalam borang 
      Sasaran Kerja Tahunan (SKT) seperti di Lampiran 'A' pada awal tahun;"],
      ["ii.","PYD hendaklah melengkapkan Bahagian II manakala PP hendaklah melengkapkan Bahagian III hingga Bahagian IX pada akhir tahun penilaian;"],
      ["iii.", "PYD dan PP hendaklah merujuk Panduan Pelaksanaan Sistem Penilaian Prestasi Anggota Perkhidmatan Awam Malaysia (Tahun 2002) 
        sekiranya memerlukan keterangan lanjut semasa mengisi Borang Laporan Penilaian Prestasi Tahunan (LNPT) dan membuat penilaian;"],
        ["	iv.", "PP hendaklah menggunakan Skala Penilaian Prestasi seperti di Lampiran 'B'; dan"],
        ["v.", "PPP hendaklah memaklumkan kepada PYD langkah-langkah meningkatkan prestasi/kemajuan kerjaya yang perlu dilakukan 
          sebelum menandatangani di ruangan Bahagian VIII."]]
      
          table1(data , :column_widths => [30,370], :cell_style => { :size => 10}) do
           row(0).borders = [:left, :right]
           row(1).borders = [:left, :right]
           row(2).borders = [:left, :right]
           row(3).borders = [:left, :right]
           row(4).borders = [:left, :right, :buttom]
           row(0).background_color = 'FFE34D'
      end
      move_down 20
  end
  
  def bahagian1
    
    text "BAHAGIAN 1 - MAKLUMAT PEGAWAI", :align => :left, :size => 12, :style => :bold     
    text "(Diisi oleh PYD)", :align => :left, :size => 12
    
    data1 = [['	i.', "Nama : "],
      ["ii.","Jawatan dan Gred : "],
      ["iii.", "Kementerian/Jabatan :"]]
      
          table1(data , :column_widths => [30,370], :cell_style => { :size => 10}) do
           row(0).borders = [:left, :right, :top]
           row(1).borders = [:left, :right]
           row(2).borders = [:left, :right, :buttom]
           row(0).background_color = 'FFE34D'
     end
     move_down 20
end
  
  def bahagian2
    
    text "BAHAGIAN II - KEGIATAN DAN SUMBANGAN DI LUAR TUGAS RASMI/LATIHAN", :align => :left, :size => 12, :style => :bold     
    text "(Diisi oleh PYD)", :align => :left, :size => 12
    move_down 10
    text "1. KEGIATAN DAN SUMBANGAN DI LUAR TUGAS RASMI", :align => :left, :size => 12, :style => :bold     
    move_down 5
    text "Senaraikan kegiatan dan sumbangan di luar tugas rasmi seperti sukan/pertubuhan/sumbangan kreatif di 
    peringkat Komuniti/Jabatan/Daerah/Negeri/Negara/Antarabangsa yang berfaedah kepada Organisasi/Komuniti/Negara 
    pada tahun yang dinilai.", :align => :left, :size => 12
    move_down 5
    
    def table_bahagian2
    
      table line_item_rows do
        row(0).font_style = :bold
        self.row_colors = ["FEFEFE", "FFFFFF"]
        self.header = true
        self.cell_style = { size: 9 }
        self.width = 525
        header = true
      end
    end
    
    
    def line_item_rows
      counter = counter || 0
      header = [[ 'Senarai kegiatan/aktiviti/sumbangan', 'Peringkat kegiatan/aktiviti/sumbangan
(nyatakan jawatan atau pencapaian)']]
      header +
        @assets.map do |asset|
        ["#{counter += 1}", "#{asset.assetcode}", "#{asset.purchasedate.try(:strftime, "%d/%m/%y")}", @view.currency(asset.purchaseprice.to_f)]
      end
    end  
     move_down 10
     
    text "2. Latihan", :align => :left, :size => 12, :style => :bold   
    move_down 5
    text "	i.	Senaraikan program latihan (seminar, kursus, bengkel dan lain-lain) yang dihadiri 
    dalam tahun yang dinilai.", :align => :left, :size => 12
     move_down 5
    
     def table_latihan2
    
       table line_item_rows2 do
         row(0).font_style = :bold
         self.row_colors = ["FEFEFE", "FFFFFF"]
         self.header = true
         self.cell_style = { size: 9 }
         self.width = 525
         header = true
       end
     end
    
    
     def line_item_rows2
       counter = counter || 0
       header = [[ 'Nama Latihan (Nyatakan sijil jika ada)', 'Tarikh/Tempoh', ' Tempat']]
       header +
         @assets.map do |asset|
         ["#{counter += 1}", "#{asset.assetcode}", "#{asset.purchasedate.try(:strftime, "%d/%m/%y")}", @view.currency(asset.purchaseprice.to_f)]
       end
     end   
     move_down 5
    text " ii. Senaraikan latihan yang diperlukan.", :align => :left, :size => 12
     move_down 5
     
     def table_latihan3
    
       table line_item_rows3 do
         row(0).font_style = :bold
         self.row_colors = ["FEFEFE", "FFFFFF"]
         self.header = true
         self.cell_style = { size: 9 }
         self.width = 525
         header = true
       end
     end
    
    
     def line_item_rows3
       counter = counter || 0
       header = [[ 'Nama/Bidang Latihan', 'Sebab Diperlukan']]
       header +
         @assets.map do |asset|
         ["#{counter += 1}", "#{asset.assetcode}", "#{asset.purchasedate.try(:strftime, "%d/%m/%y")}", @view.currency(asset.purchaseprice.to_f)]
       end
     end       
     move_down 5  
    text "Saya mengesahkan bahawa semua kenyataan di atas adalah benar.", :align => :left, :size => 12 
     move_down 5   
     
     data1 = [["",""],
           [ "Tandatangan PYD", "Tarikh"]] 
end

def bahagian3
  
  
  
  
end




end