class Kewpa20Pdf < Prawn::Document
  def initialize(disposal, view)
    super({top_margin: 50, page_size: 'A4', page_layout: :portrait })
    @disposal = disposal
    @view = view
    font "Times-Roman"
    text "KEW.PA-20", :align => :right, :size => 16, :style => :bold
    move_down 20
    text "LAPORAN TAHUNAN PELUPUSAN ASET ALIH KERAJAAN", :align => :center, :size => 14, :style => :bold
    text "TAHUN: ", :align => :center, :size => 14, :style => :bold
    move_down 20
    text "KEMENTERIAN/JABATAN:  ..............................................................", :align => :left, :size => 14
    table
    table1
    table3
  
   
  end
  
  def table
    data = [["","","","", "JUMLAH NILAI PEROLEHAN ASAL ASET SECARA (RM)"]]
    
    table(data , :column_widths => [30, 100, 80, 80], :cell_style => { :size => 9})
  end
  def table1
    
    table line_item_rows  do
      columns(0).width = 20
      columns(0).borders = [:left, :right, :bottom]
      columns(1).width = 100
      columns(1).borders = [:left, :right, :bottom]
      columns(2).width = 80
      columns(2).borders = [:left, :right, :bottom]
      columns(3).width = 80
      columns(3).borders = [:left, :right, :bottom]
      self.row_colors = ["FEFEFE", "FFFFFF"]
      self.header = true
      self.cell_style = { size: 9 }
      self.width = 525
      header = true
    end
  end
  def line_item_rows

      counter = counter || 0
      header = [[ 'Bil', 'KEMENTERIAN/JABATAN', "JUMLAH NILAI PEROLEHAN ASAL (RM)", 'HASIL PELUPUSAN (RM)', 'JUALAN', 'PINDAHAN','MUSNAH',
        'KAEDAH LAIN']]
      header +
        @disposal.map do |disposal|
        ["#{counter += 1}", "Kolej Sains Kesihatan Bersekutu Johor Bahru", "", "" , "","", "", "")  ]
      end
     
end

  def table3
    text "Nota : Laporan ini hendaklah dihantar ke Perbendaharaan sebelum 15 Mac tahun berikutnya", :align => :left, :size => 9, :style => :italic
    move_down = 10
   data = [["Tandatangan Pegawai Pengawal", ":............................. ","Cop Jabatan :"],
   [ "Nama", ":..................................... ", ""],
   ["Jawatan", ":.......................................", ""],
   ["","Nama",":........................................."],
   ["Tarikh",":..........................................", ""]]
   
   table(data, :column_widths => [150, 200 ], :cell_style => { :size => 9}) do
     columns(0).borders = []
     columns(1).borders = []
     columns(2).borders = []
  end
  

end