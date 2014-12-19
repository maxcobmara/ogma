class Kewpa17Pdf < Prawn::Document
  def initialize(disposal, view)
    super({top_margin: 50, page_size: 'A4', page_layout: :landscape})
    @disposals = disposal
    @view = view
    font "Times-Roman"
    text "KEW.PA-17", :align => :right, :size => 16, :style => :bold
    move_down 20
    text "LAPORAN LEMBAGA PEMERIKSA ASET ALIH KERAJAAN", :align => :center, :size => 14, :style => :bold
    move_down 20
    text "KEMENTERIAN/JABATAN:  KOLEJ SAINS KESIHATAN BERSEKUTU JOHOR BAHRU", :align => :left, :size => 10
    tab
    table1
    table2
    table3
    move_down 20
    text "*(Ruangan boleh ditambah jika ahli Lembaga Pemeriksa Lebih daripada 2 orang)", :align=> :right, :size => 9, :style => :bold
  
   
  end
  
  def tab
    data = [["","","","","", "", "", "HARGA PEROLEHAN ASAL", "NILAI SEMASA", "", ""]]
    
    table(data , :column_widths => [30, 50, 100, 45, 50, 55, 50, 90, 90], :cell_style => { :size => 6}) do
     row(0).columns(0).borders = [:left, :right, :top]
     row(0).columns(1).borders = [:left, :right, :top]
     row(0).columns(2).borders = [:left, :right, :top]
     row(0).columns(3).borders = [:left, :right, :top]
     row(0).columns(4).borders = [:left, :right, :top]
     row(0).columns(5).borders = [:left, :right, :top]
     row(0).columns(6).borders = [:left, :right, :top]
     row(0).columns(9).borders = [:top, :right]
     row(0).columns(10).borders = [:top, :right, :left]
     
     self.width = 740
    
    end
    
  end
  def table1
    
    table line_item_rows  do
      columns(0).width = 30
      columns(0).borders = [:left, :right, :bottom]
      columns(1).width = 50
      columns(1).borders = [:left, :right, :bottom]
      columns(2).width = 100
      columns(2).borders = [:left, :right, :bottom]
      columns(3).width = 45
      columns(3).borders = [:left, :right, :bottom]
      columns(4).width = 50
      columns(4).borders = [:left, :right, :bottom]
      columns(5).width = 55
      columns(5).borders = [:left, :right, :bottom]
      columns(6).width = 50
      columns(6).borders = [:left, :right, :bottom]
      columns(7).width = 45
      columns(8).width = 45
      columns(9).width = 45
      columns(10).width = 45
      columns(10).borders = [:left, :right, :bottom]
      columns(11).width = 70
      columns(11).borders = [:left, :right, :bottom]
      columns(11).width = 90
      columns(12).borders = [:left, :right, :bottom]
      self.row_colors = ["FEFEFE", "FFFFFF"]
      self.header = true
      self.cell_style = { size: 6 }
      self.width = 740
     
      header = true
    end
  end
  def line_item_rows
   
      counter = counter || 0
      header = [[ 'Bil', 'JABATAN/ BAHAGIAN', "KETERANGAN ASET", 'UNIT', 'KUANTITI', 'TARIKH PEMBELIAN','TEMPOH DIGUNAKAN / SIMPANAN',
        'SEUNIT (RM)', 'JUMLAH (RM)', 'SEUNIT (RM)', 'JUMLAH (RM)', 'NYATAKAN KEADAAN ASET DENGAN JELAS', 'SYOR KAEDAH PELUPUSAN DAN JUSTIFIKASI']]
      header +
        @disposals.map do |disposal|
          
          quantiti = "#{disposal.try(:asset).try(:quantity)}"
          if quantiti.to_i < 1

           a = "#{disposal.try(:asset).try(:purchaseprice)}"
           b = 1
           c = "#{disposal.current_value}"
           total = a.to_i * b.to_i 
           totalcurrent = c.to_i * b.to_i 
            quan = 1
       else
           a = "#{disposal.try(:asset).try(:purchaseprice)}"
           b = "#{disposal.try(:asset).try(:quantity)}"
           c = "#{disposal.current_value}"
           total = a.to_i * b.to_i 
           totalcurrent = c.to_i * b.to_i 
            quan = "#{disposal.try(:asset).try(:quantity)}"
         end
         
        ["#{counter += 1}", "#{disposal.try(:asset).try(:assignedto).try(:positions).try(:first).try(:unit) unless disposal.asset.assignedto.try(:positions).blank?}", "#{disposal.try(:asset).try(:assetcode)} #{disposal.try(:asset).try(:name)}", "" , quan ,"#{disposal.try(:asset).try(:purchasedate).try(:strftime, "%d/%m/%y")}", 
          "#{Date.today - disposal.try(:asset).try(:purchasedate)} hari", @view.currency(disposal.try(:asset).try(:purchaseprice).to_f), @view.currency(total.to_f), @view.currency(disposal.current_value.to_f), @view.currency(totalcurrent.to_f), "", "" ]

      end
      
end

def table2
   count = sum = 0
  @disposals.map do |disposal|
    
    quantiti = "#{disposal.try(:asset).try(:quantity)}"
    if quantiti.to_i < 1

     a = "#{disposal.try(:asset).try(:purchaseprice)}"
     b = 1
     c = "#{disposal.current_value}"
     total = a.to_i * b.to_i 
     totalcurrent = c.to_i * b.to_i 
 else
     a = "#{disposal.try(:asset).try(:purchaseprice)}"
     b = "#{disposal.try(:asset).try(:quantity)}"
     c = "#{disposal.current_value}"
     total = a.to_i * b.to_i 
     totalcurrent = c.to_i * b.to_i 
   end
   count += total
   sum += totalcurrent
 end
  data3 = [["","JUMLAH KESELURUHAN", @view.currency(count.to_f),"", @view.currency(sum.to_f),""]]
  
  table(data3, :column_widths => [325, 100, 45,  45, 45], :cell_style => { :size => 6}) do
    self.width = 740
    columns(1).align = :right
    columns(0).borders = []
    columns(1).borders = [:right]
    columns(3).borders = []
    columns(5).borders = []
    
  end
  move_down 20
end
  def table3
   data = [["Tarikh pelantikan Lembaga pemeriksa #{'.'*65}", "Tandatangan ","#{'.'*45} (Pengerusi)"],
   [ "", "Nama ", "#{'.'*65}"],
   ["Tarikh pemeriksaan #{'.'*65}", "Jawatan", "#{'.'*65}"],
   ["Tempat pemeriksaan #{'.'*65}", "Tandatangan", "#{'.'*55} (Ahli)"],
   ["","Nama","#{'.'*65}"],
   ["","Jawatan", "#{'.'*65}"]]
          
   table(data, :column_widths => [420, 90, ], :cell_style => { :size => 9}) do
     row(0).height = 30
     row(2).height = 30
     row(3).height = 30
     columns(0).borders = []
     columns(1).borders = []
     columns(2).borders = []
  end
end
end