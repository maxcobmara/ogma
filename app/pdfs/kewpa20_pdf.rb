class Kewpa20Pdf < Prawn::Document
  def initialize(disposal, view, college)
    super({top_margin: 50, page_size: 'A4', page_layout: :landscape })
    @disposals = disposal
    @view = view
    @college=college
    font "Times-Roman"
    text "KEW.PA-20", :align => :right, :size => 16, :style => :bold
    move_down 20
    text "LAPORAN TAHUNAN PELUPUSAN ASET ALIH KERAJAAN", :align => :center, :size => 14, :style => :bold
    text "TAHUN : #{'.'*20} ", :align => :center, :size => 14
    move_down 20
    text "KEMENTERIAN/JABATAN:#{'.'*150}", :align => :left, :size => 14
    move_down 10
    tab
    table1
    table4
    move_down 5
    table3
  end
  
  def tab
    data = [["","","","", "JUMLAH NILAI PEROLEHAN ASAL ASET SECARA (RM)"]]
    
    table(data , :column_widths => [30, 160, 130, 110, 295], :cell_style => { :size => 9}) do
      row(0).align = :center
      row(0).columns(0).borders = [:left, :right, :top]
      row(0).columns(1).borders = [:left, :right, :top]
      row(0).columns(2).borders = [:left, :right, :top]
      row(0).columns(3).borders = [:left, :right, :top]
      self.width = 725
	  #525
    end
  end
  def table1
    
    table(line_item_rows, :column_widths => [30, 160, 130, 110,70,80,70], :cell_style => { :size => 9}) do
      row(0).align = :center
      cells[1,2].align = :right
      cells[1,3].align = :right
      cells[1,4].align = :right
      cells[1,5].align = :right
      cells[1,6].align = :right
      cells[1,7].align = :right
      columns(0).width = 30
      row(0).columns(0).borders = [:left, :right, :bottom]
      columns(1).width = 160
      row(0).columns(1).borders = [:left, :right, :bottom]
      columns(2).width = 130
      row(0).columns(2).borders = [:left, :right, :bottom]
      columns(3).width = 110
      row(0).columns(3).borders = [:left, :right, :bottom]
      self.row_colors = ["FEFEFE", "FFFFFF"]
      self.header = true
      self.cell_style = { size: 9 }
      self.width = 725
      header = true
    
    end
  
    def table4
      data1 = [["","","","","","","",""],
      ["","","","","","","",""],
      ["","","","","","","",""],
      ["","","","","","","",""]]
      
      table(data1, :column_widths => [30, 160, 130, 110,70,80,70], :cell_style => { :size => 9}) do
        row(0).height = 20
        row(1).height = 20
        row(2).height = 20
        row(3).height = 20
      self.width = 725
    end
    end
  end
  def line_item_rows
    asal = current = jualan = pindahan = musnah = lain = 0
    @disposals.map do |disposal|
      asal+=disposal.asset.purchaseprice.to_f*disposal.qty
      current+=disposal.total_current_value
      musnah += disposal.total_current_value if disposal.disposal_type == "discard"
      jualan += disposal.total_current_value if disposal.disposal_type == "sold"
      pindahan += disposal.total_current_value if disposal.disposal_type == "transfer"
      lain += disposal.total_current_value if ((disposal.disposal_type != "transfer") && (disposal.disposal_type != "sold") && (disposal.disposal_type != "discard") )
    end
      header = [[ 'Bil', 'KEMENTERIAN/ JABATAN', "JUMLAH NILAI PEROLEHAN ASAL (RM)", 'HASIL PELUPUSAN (RM)', 'JUALAN', 'PINDAHAN','MUSNAH',
        'KAEDAH LAIN'],
        ["1", "#{@college.name}", @view.currency(asal.to_f), @view.currency(current.to_f) , @view.currency(jualan.to_f), @view.currency(pindahan.to_f), @view.currency(musnah.to_f),  @view.currency(lain.to_f)  ]]
        
end

  def table3
    text "Nota : Laporan ini hendaklah dihantar ke Perbendaharaan sebelum 15 Mac tahun berikutnya", :align => :left, :size => 9, :style => :italic
    move_down = 40
   data = [ [ "", "", ""],
          [ "", "", ""],
          ["Tandatangan Pegawai Pengawal", ": #{'.'*60} ","Cop Jabatan :"],
          [ "Nama", ": #{'.'*60} ", ""],
          ["Jawatan", ": #{'.'*60}", ""],
          ["Tarikh",": #{'.'*60}", ""]]
   
   table(data, :column_widths => [190, 200 ], :cell_style => { :size => 9}) do
     columns(0).borders = []
     columns(1).borders = []
     columns(2).borders = []
     columns(3).borders = []
  end
  
end
end