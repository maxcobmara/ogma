class Kewpa17Pdf < Prawn::Document
  def initialize(disposal, view)
    super({top_margin: 50, page_size: 'A4', page_layout: :portrait })
    @disposal = disposal
    @view = view
    font "Times-Roman"
    text "KEW.PA-17", :align => :right, :size => 16, :style => :bold
    move_down 20
    text "LAPORAN LEMBAGA PEMERIKSA ASET ALIH KERAJAAN", :align => :center, :size => 14, :style => :bold
    move_down 20
    text "KEMENTERIAN/JABATAN:  KOLEJ SAINS KESIHATAN BERSEKUTU JOHOR BAHRU", :align => :left, :size => 14
    table
    table1
    table3
  
   
  end
  
  def table
    data = [["","","","","", "", "", "HARGA PEROLEHAN ASAL", "NILAI SEMASA", "", ""]]
    
    table(data , :column_widths => [20, 40, 50, 50, 40, 40, 40, 60, 60, 70], :cell_style => { :size => 9})
  end
  def table1
    
    table line_item_rows  do
      columns(0).width = 20
      columns(0).borders = [:left, :right, :bottom]
      columns(1).width = 40
      columns(1).borders = [:left, :right, :bottom]
      columns(2).width = 50
      columns(2).borders = [:left, :right, :bottom]
      columns(3).width = 50
      columns(3).borders = [:left, :right, :bottom]
      columns(4).width = 40
      columns(4).borders = [:left, :right, :bottom]
      columns(5).width = 40
      columns(5).borders = [:left, :right, :bottom]
      columns(6).width = 40
      columns(6).borders = [:left, :right, :bottom]
      columns(7).width = 30
      columns(8).width = 30
      columns(9).width = 30
      columns(10).width = 30
      columns(11).width = 70
      columns(11).borders = [:left, :right, :bottom]
      columns(12).borders = [:left, :right, :bottom]
      self.row_colors = ["FEFEFE", "FFFFFF"]
      self.header = true
      self.cell_style = { size: 9 }
      self.width = 525
      header = true
    end
  end
  def line_item_rows

      counter = counter || 0
      header = [[ 'Bil', 'JABATAN/ BAHAGIAN', "KETERANGSAN ASET", 'UNIT', 'KUANTITI', 'TARIKH PEMBELIAN','TEMPOH DIGUNAKAN / SIMPANAN',
        'SEUNIT (RM)', 'JUMLAH (RM)', 'SEUNIT (RM)', 'JUMLAH (RM)', 'NYATAKAN KEADAAN ASET DENGAN JELAS', 'SYOR KAEDAH PELUPUSAN DAN JUSTIFIKASI']]
      header +
        @disposal.map do |disposal|
        ["#{counter += 1}", "#{asset.assetcode}", "", "" , "","", "", "", "", "", "", "", "")  ]
      end
      move_down = 10
end

  def table3
   data = [["Tarikh pelantikan Lembaga pemeriksa...................................................", "Tandatangan ","........................... (pengerusi)"],
   [ "Tarikh pemeriksaan...........................................................................", "Nama ", "........................................."],
   ["Tempat pemeriksaan...........................................................................", "Tandatangan", "........................................."],
   ["","Nama","........................................."],
   ["","Jawatan", "........................................."],
   ["","","*(Ruangan boleh ditambah jika ahli Lembaga Pemeriksa Lebih daripada 2 orang)"]]
   
   table(data, :column_widths => [200, 90, ], :cell_style => { :size => 9}) do
     columns(0).borders = []
     columns(1).borders = []
     columns(2).borders = []
  end
  

end