class Kewpa20Pdf < Prawn::Document
  def initialize(disposal, view)
    super({top_margin: 50, page_size: 'A4', page_layout: :portrait })
    @disposals = disposal
    @view = view
    font "Times-Roman"
    text "KEW.PA-20", :align => :right, :size => 16, :style => :bold
    move_down 20
    text "LAPORAN TAHUNAN PELUPUSAN ASET ALIH KERAJAAN", :align => :center, :size => 14, :style => :bold
    text "TAHUN: ", :align => :center, :size => 14, :style => :bold
    move_down 20
    text "KEMENTERIAN/JABATAN:#{'.'*80}", :align => :left, :size => 14
    tab
    table1
    table4
    table3

  
   
  end
  
  def tab
    data = [["","","","", "JUMLAH NILAI PEROLEHAN ASAL ASET SECARA (RM)"]]
    
    table(data , :column_widths => [30, 100, 80, 80, 235], :cell_style => { :size => 9}) do
      row(0).columns(0).borders = [:left, :right, :top]
      row(0).columns(1).borders = [:left, :right, :top]
      row(0).columns(2).borders = [:left, :right, :top]
      row(0).columns(3).borders = [:left, :right, :top]
      self.width = 525
    end
  end
  def table1
    
    table(line_item_rows, :column_widths => [30, 100, 80, 80,50,60,50], :cell_style => { :size => 9}) do
      columns(0).width = 30
      row(0).columns(0).borders = [:left, :right, :bottom]
      columns(1).width = 100
      row(0).columns(1).borders = [:left, :right, :bottom]
      columns(2).width = 80
      row(0).columns(2).borders = [:left, :right, :bottom]
      columns(3).width = 80
      row(0).columns(3).borders = [:left, :right, :bottom]
      self.row_colors = ["FEFEFE", "FFFFFF"]
      self.header = true
      self.cell_style = { size: 9 }
      self.width = 525
      header = true
    
    end
  
    def table4
      data1 = [["","","","","","","",""],
      ["","","","","","","",""],
      ["","","","","","","",""],
      ["","","","","","","",""]]
      
      table(data1, :column_widths => [30, 100, 80, 80,50,60,50], :cell_style => { :size => 9}) do
      self.width = 525
    end
    end
  end
  def line_item_rows

  
      header = [[ 'Bil', 'KEMENTERIAN/ JABATAN', "JUMLAH NILAI PEROLEHAN ASAL (RM)", 'HASIL PELUPUSAN (RM)', 'JUALAN', 'PINDAHAN','MUSNAH',
        'KAEDAH LAIN'],
        ["1", "Kolej Sains Kesihatan Bersekutu Johor Bahru", "", "" , "","", "", ""  ]]
        
end

  def table3
    text "Nota : Laporan ini hendaklah dihantar ke Perbendaharaan sebelum 15 Mac tahun berikutnya", :align => :left, :size => 9, :style => :italic
    move_down = 40
   data = [ [ "", "", ""],
          [ "", "", ""],
          ["Tandatangan Pegawai Pengawal", ":#{'.'*60} ","Cop Jabatan :"],
          [ "Nama", ":#{'.'*60} ", ""],
          ["Jawatan", ":#{'.'*60}", ""],
          ["Tarikh",":#{'.'*60}", ""]]
   
   table(data, :column_widths => [120, 200 ], :cell_style => { :size => 9}) do
     columns(0).borders = []
     columns(1).borders = []
     columns(2).borders = []
     columns(3).borders = []
  end
  
end
end