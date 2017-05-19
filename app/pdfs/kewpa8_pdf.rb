class Kewpa8Pdf < Prawn::Document
  def initialize(fa, inv, view, college)
    super({top_margin: 50, page_size: 'A4', page_layout: :landscape })
    @fa = fa
    @inv = inv
    @view = view
    @college=college
    font "Times-Roman"
    text "KEW.PA-8", :align => :right, :size => 12, :style => :bold
    move_down 20  
    text "LAPORAN TAHUNAN HARTA MODAL DAN INVENTORI BAGI TAHUN ", :align => :center, :size => 12, :style => :bold
    move_down 10
    if college.code=="kskbjb"
      text "KEMENTERIAN : KESIHATAN MALAYSIA ", :align => :center, :size => 12, :style => :bold
    else
      text "KEMENTERIAN :  ", :align => :center, :size => 12, :style => :bold
    end
    move_down 30
    table1
    move_down 50
    table3
    move_down 80
    text "* laporan merangkumi semua aset alih yang dipegang sehingga tahun semasa", :align => :left, :size => 11
    move_down = 40
  end
  
  def table1
    table(line_item_rows, :column_widths => [30, 260, 80, 150, 80, 140], :cell_style => { :size => 11}) do
      row(0).align = :center
      cells[1,2].align = :right
      cells[1,3].align = :right
      cells[1,4].align = :right
      cells[1,5].align = :right
      cells[2,2].align = :right
      cells[2,3].align = :right
      cells[2,4].align = :right
      cells[2,5].align = :right
      cells[2,1].align = :right
      row(2).font_style=:bold
      row(0).background_color = 'FFE34D'
      self.row_colors = ["FEFEFE", "FFFFFF"]
      self.width = 740
    end
  end
  
  def line_item_rows
    bil = bil || 0
    fa=[]
    inv=[]
    fa_p=[]
    inv_p=[]
    fa << @fa.count
    inv << @inv.count
    fa_p << @fa.map(&:purchaseprice).compact.sum
    inv_p << @inv.map(&:purchaseprice).compact.sum
    header = [[ 'Bil', 'KEMENTERIAN/ JABATAN DI BAWAHNYA', 'BILANGAN KEW.PA-2', 'JUMLAH NILAI HARTA MODAL (RM)', 'BILANGAN KEW.PA-3', 'JUMLAH NILAI INVENTORI (RM)']]
    content_line= [[bil+1, @college.name, fa[bil], @view.currency(fa_p[bil]), inv[bil], @view.currency(inv_p[bil])]]
    #bil+=1
    total_line = [['','JUMLAH', fa.sum, @view.currency(fa_p.sum), inv.sum, @view.currency(inv_p.sum)]]
    header+content_line+total_line
  end

  def table3
    data = [ ["", {content: "#{'.'*90} ", colspan: 2}, ""],
                ["", {content: "Tandatangan Pegawai Pengawal", colspan: 2}, ""],   
                ["", "", "", ""],
                ["", "Nama", ": #{'.'*65} ", ""],
                ["", "Jawatan", ": #{'.'*65}", ""],
                ["", "Tarikh",": #{'.'*65}", ""]]
    table(data, :column_widths => [30, 60, 200, 200 ], :cell_style => { :size => 11, :inline_format => :true}) do
      columns(0).borders = []
      columns(1).borders = []
      columns(2).borders = []
      columns(3).borders = []
      cells[1,1].align = :center
      row(1).height = 25
      row(2).height = 20
    end
  end
  
end