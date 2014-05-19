class Kewpa3Pdf < Prawn::Document
  def initialize(asset)
    super({top_margin: 50, page_size: 'A4', page_layout: :portrait })
    @assets = asset

    font "Times-Roman"
    text "KEW.PA-3", :align => :right, :size => 16, :style => :bold
    text "(No. Siri Pendaftaran:", :align => :right, :size => 16
    move_down 15
    text "DAFTAR INVENTORY", :align => :center, :size => 14, :style => :bold
    move_down 15
    text "Kementerian/Jabatan   : Kolej Kesihatan Bersekutu Johor Bahru", :align => :left, :size => 14
    text "Bahagian  :", :align => :left, :size => 14
    move_down 5
    
    make_tables1
    make_table_penempatan
    make_table_pemeriksaan
    make_table_pelupusan
  end
  
  def cop 
    text "........................", :align => :center, :size => 14
    text "Tandatangan Ketua Jabatan", :align => :center, :size => 14
    move_down 5
    text "Nama    :", :align => :left, :size => 14
    text "Jawatan :", :align => :left, :size => 14
    text "Tarikh  :", :align => :left, :size => 14
    text "Cop     :", :align => :left, :size => 14
    
  end
    
  def make_tables1
    
    data = [ [ "Kod Nasional", " "], [ "Kategori ", " "], [ "Sub Kategori", " "] ]
       table(data, :column_widths => [130, 390])
          
       data1 = [ ["Jenis", "", "Harga Perolehan Asal", ""], 
                ["Kuantiti", "", "Tarikh Diterima", ""],
                ["Unit Pengukuran", "", "No Pesanan Rasmi Kerajaan & Tarikh", ""],
            ["Tempoh Jaminan", "", "",""] ]
         table(data1, :column_widths => [130, 150, 120, 120]) 
         
         data2 =[ ["Nama Pembekal Dan Alamat:", "cop" ] ]
         table(data2, :column_widths => [180, 340]) 

          move_down 5
  end

  
  def make_table_penempatan
    header = [ ["PENEMPATAN"]]
    table(header , :column_widths => [520], ) do
    row(0).font_style = :bold
    row(0).align = :center
    row(0).background_color = 'FFE34D'
    
  end
  
  data = [ ["Kuantiti", "", "", "", "", "", "", ""],
           ["No Siri Pendaftaran", "", "", "", "", "", "", ""],
           ["Lokasi", "", "", "", "", "", "", ""],
           ["Tarikh", "", "", "", "", "", "", ""],
           ["Nama Pegawai", "", "", "", "", "", "", ""],
           ["Tandatangan", "", "", "", "", "", "", ""], ]
           
  table(data , :column_widths => [100, 60, 60, 60, 60, 60, 60, 60])
  move_down 5
  end
  
  def make_table_pemeriksaan
    header = [ ["PEMERIKSAAN"]]
    table(header , :column_widths => [520], ) do
    row(0).font_style = :bold
    row(0).align = :center
    row(0).background_color = 'FFE34D'
    
  end
  
  data = [ ["Tarikh", "", "", "", "", "", "", ""],
           ["Status Aset", "", "", "", "", "", "", ""],
           ["Nama Pemeriksa", "", "", "", "", "", "", ""],
           ["Tandatangan", "", "", "", "", "", "", ""] ]
           
  table(data , :column_widths => [100, 60, 60, 60, 60, 60, 60, 60])
  move_down 5
  end
  
  def make_table_pelupusan
    header = [ ["PELUPUSAN/HAPUSKIRA"]]
    table(header , :column_widths => [520], ) do
    row(0).font_style = :bold
    row(0).align = :center
    row(0).background_color = 'FFE34D'
    
  end
  
  data = [ ["Tarikh", "Rujukan", "Kaedah Pelupusan", "Kuantiti", "Lokasi", "Tandatangan"],
           ["Date", "", "", "", "", ""],
           ["Date", "", "", "", "", ""] ]
           
  table(data , :column_widths => [88, 92, 92, 88, 88])
  end
end

  
