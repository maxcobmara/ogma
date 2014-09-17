class Maklumat_perjawatanPdf < Prawn::Document
  def initialize(position, view)
    super({top_margin: 50, page_size: 'A4', page_layout: :landscape })
    @positions = position
    @view = view
    font "Times-Roman"
    text "LAMPIRAN A", :align => :right, :size => 12, :style => :bold
    move_down 5
    text "MAKLUMAT PERJAWATAN DI KOLEH-KOLEJ LATIHAN", :align => :center, :size => 12, :style => :bold
    text "KEMENTERIAN KESIHATAN MALAYSIA", :align => :center, :size => 12, :style => :bold
    text "SEHINGGA #{Date.today.strftime('%d-%m-%Y')}", :align => :center, :size => 12, :style => :bold   
    move_down 10
    text "KOLEJ: KOLEJ SAINS KESIHATAN BERSEKUTU JOHOR BAHRU", :align => :left, :size => 12, :style => :bold    
    tajuk1
    tajuk2
    jawatan
   
  end
  
  def tajuk1
    data = [["BIL","BUT.","JAWATAN","GRED","JUM", "ISI", "STATUS PENGISIAN", "KSG", "NAMA", "NO. K/P/", "JANTINA","BIDANG","TARIKH","PENEMPATAN",
      "PINJAM KE","PINJAM DARI","CATATAN"]]
   
    table(data , :column_widths => [23, 30, 43, 40, 30, 30, 80, 28, 60, 50, 40, 40, 40, 60, 65,65,45], :cell_style => { :size => 7}) do
     row(0).columns(0).borders = [:left, :right, :top]
     row(0).columns(1).borders = [:left, :right, :top]
     row(0).columns(2).borders = [:left, :right, :top]
     row(0).columns(3).borders = [:left, :right, :top]
     row(0).columns(4).borders = [:left, :right, :top]
     row(0).columns(5).borders = [:left, :right, :top]
     row(0).columns(7).borders = [:left, :right, :top]
     row(0).columns(8).borders = [:left, :right, :top]
     row(0).columns(9).borders = [:left, :right, :top]
     row(0).columns(10).borders = [:left, :right, :top]
     row(0).columns(11).borders = [:left, :right, :top]
     row(0).columns(12).borders = [:left, :right, :top]
     row(0).columns(13).borders = [:left, :right, :top]
     row(0).columns(16).borders = [:left, :right, :top]
     row(0).font_style = :bold
     row(0).background_color = 'FFE34D'

    end 
  end
  def tajuk2
    
    data = [[ '', '', '', '', 'JWT','','HAKIKI','KONTRAK','KUP','','PENYANDANG','PASSPORT','(L/P)','KEPAKARAN/SUB-KEPAKARAN','WARTA PAKAR','',
      'Akt.','Penempatan','Akt.','Penempatan','*']]
      
      table(data , :column_widths => [23, 30, 43, 40, 30, 30, 30,30,20, 28, 60, 50, 40, 40, 40, 60, 25,40,25,40,45], :cell_style => { :size => 7}) do
        row(0).columns(0).borders = [:left, :right]
        row(0).columns(1).borders = [:left, :right]
        row(0).columns(2).borders = [:left, :right]
        row(0).columns(3).borders = [:left, :right]
        row(0).columns(4).borders = [:left, :right]
        row(0).columns(5).borders = [:left, :right]
        row(0).columns(9).borders = [:left, :right]
        row(0).columns(10).borders = [:left, :right]
        row(0).columns(11).borders = [:left, :right]
        row(0).columns(12).borders = [:left, :right]
        row(0).columns(13).borders = [:left, :right]
        row(0).columns(14).borders = [:left, :right]
        row(0).columns(15).borders = [:left, :right]
        row(0).columns(20).borders = [:left, :right]
        row(0).font_style = :bold
        row(0).background_color = 'FFE34D'
      end
    
  end
  
  def jawatan
    
    table(line_item_rows , :column_widths => [23, 30, 43, 40, 30, 30, 30,30,20, 28, 60, 50, 40, 40, 40, 60, 25,40,25,40,45], :cell_style => { :size => 7}) do
      self.row_colors = ["FEFEFE", "FFFFFF"]

    end
  end
  
  def line_item_rows
    counter = counter || 0
      @positions.map do |position|
      ["#{counter += 1}", "", "#{position.name}","#{position.try(:staff_grade).try(:grade)}","#{position.try(:postinfo).try(:post_count)}", "", "","","","",
        "#{position.try(:staff).try(:name)}","#{position.try(:staff).try(:icno)}","#{position.try(:staff).try(:gender)}","","","",
        "","","","",""]
    end
  end
end