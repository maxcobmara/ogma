class Kewps13Pdf < Prawn::Document
  def initialize(stationeries, view, lead)
    super({top_margin: 30, page_size: 'A4', page_layout: :landscape })
    @stationeries = stationeries
    @view = view
    @lead = lead

    font "Times-Roman"
    text "KEW.PS-13", :align => :right, :size => 15, :style => :bold
    move_down 15
    text "LAPORAN KEDUDUKAN STOK TAHUN #{Time.new.last_year}", :align => :center, :size => 14
    text "BAGI SUKU TAHUN KEDUA PADA  ", :align => :center, :size => 14
    move_down 15
    text "KATEGORI STOR :", :align => :left, :size => 14
    text "JENIS STOR : STOR ALAT TULIS", :align => :left, :size => 14
    move_down 15
    
    make_tables1
    make_tables2
    make_tables3

  end
  

    
  def make_tables1
    
    data = [ ["", "", "KEDUDUKAN", "STOK", "", "KADAR PUSINGAN"],
             ["", "Sedia Ada", "Pembelian/Penerimaan", "Pengeluaran/Penggunaan","Stok Semasa", "STOK"],
             ["TAHUN ", "Jumlah Nilai Stok (RM)", "Jumlah Nilai Stok (RM)", "Jumlah Nilai Stok (RM)", "Jumlah Nilai Stok (RM)", ""],
             ["SEMASA", "(a)", "(b)", "(c)", "d = (a+b) - (c)", "c / [(a+b)/2]" ]]
          

         table(data, :column_widths => [100, 130, 130, 135, 130, 140 ], :cell_style => { :size => 12}) do
           
           
           row(0).columns(0).borders = [:top, :left, :right]
           row(1).columns(0).borders = [:left, :right]
           row(2).columns(0).borders = [:left, :right]
           row(3).columns(0).borders = [ :left, :right]
           row(0).columns(1).borders = [:top]
           row(0).columns(2).borders = [:top]
           row(0).columns(3).borders = [:top]
           row(0).columns(4).borders = [:top]
           row(0).columns(2).align = :right
           row(0).columns(5).borders = [:left, :right, :top]
           row(1).columns(5).borders = [:left, :right]
           row(2).columns(5).borders = [:left, :right]
           row(3).columns(5).borders = [:left, :right]
           row(0).height = 20
           row(1).height = 20
           row(2).height = 20
           row(3).height = 20
           row(2).align = :center
           row(3).align = :center

           
         end
           

           
         

    data1 = [ ["Baki Bawa Hadapan", "Baki Stok Akhir Tahun" , "", ""]] 
    
    table(data1, :column_widths => [100, 395, 130, 140 ], :cell_style => { :size => 12})  do
      
      row(0).columns(1).align = :right
    end
        
  end
  
  def make_tables2
    
    data = [["Suku Tahun", "", "", "", "", ""],
          ["Suku Tahun", "", "", "", "", ""],
          ["", "", "", "", "", ""],
          [" ", "", "", "", "", ""]]
          
    table(data, :column_widths => [100, 130, 130, 135, 130, 140 ], :cell_style => { :size => 12})  do
      row(0).height = 20
      row(1).height = 20
      row(2).height = 20
      row(3).height = 20
    end
    
    
    data1 = [["Nilai Tahunan", "", "", "Kadar Pusingan Stok Tahunan adalah:", ""]]
    
     table(data1, :column_widths => [230, 130, 135, 130, 140 ], :cell_style => { :size => 12}) do
       row(0).align = :center 
     end 
  end
  
  def make_tables3
    
    data = [["", "Disediakan Oleh :"],
            ["", "#{'.'*60}"],
            ["-Pembelian : Bermaksud nilai stok yang diterima", "(Tandatangan Ketua Jabatan)"],
            ["", "Nama :"],
            ["-Pengeluaran : Bermaksud nilai stok yang dibekal/diguna", "Jawatan :"],
            ["", "Tarikh :"],
            ["", "Cop Jabatan :"]]
            
      table(data, :column_widths => [360, 405 ], :cell_style => { :size => 12})  do
        row(0).columns(0).borders = [:top, :left, :right]
        row(0).columns(1).borders = [:top, :left, :right]
        row(1).columns(0).borders = [:left, :right]
        row(1).columns(1).borders = [:left, :right]
        row(2).columns(0).borders = [:left, :right]
        row(2).columns(1).borders = [:left, :right]
        row(3).columns(0).borders = [:left, :right]
        row(3).columns(1).borders = [:left, :right]
        row(4).columns(0).borders = [:left, :right]
        row(4).columns(1).borders = [:left, :right]
        row(5).columns(0).borders = [:left, :right]
        row(5).columns(1).borders = [:left, :right]
        row(6).columns(0).borders = [:left, :right, :bottom]
        row(6).columns(1).borders = [:left, :right, :bottom]
        row(0).height = 20
        row(1).height = 20
        row(2).height = 20
        row(3).height = 20
        row(4).height = 20
        row(5).height = 20
        row(6).height = 20
      end
    
  end
end

  
