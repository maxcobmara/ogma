class Kewpa17Pdf < Prawn::Document
  def initialize(disposal, lastitem, view)
    super({top_margin: 50, page_size: 'A4', page_layout: :landscape})
    @disposals = disposal
    @disposal_end = lastitem
    @view = view
    font "Times-Roman"
    text "KEW.PA-17", :align => :right, :size => 16, :style => :bold
    move_down 20
    text "LAPORAN LEMBAGA PEMERIKSA ASET ALIH KERAJAAN", :align => :center, :size => 14, :style => :bold
    move_down 20
    text "KEMENTERIAN/JABATAN: KOLEJ SAINS KESIHATAN BERSEKUTU JOHOR BAHRU", :align => :left, :size => 10
    heading_table
    heading_table2
    table1
    if y < 270  #220  #6 items of asset for disposal - 1 page, item 7 & so on, will be printed on next page+signatory
      start_new_page
      heading_table
      heading_table2
    end
    table2 if @disposals.count > 0 && @disposals.first!=@disposal_end #1
    total_up
    total_table
    move_down 20
    signatory_table
    move_down 20
    text "*(Ruangan boleh ditambah jika ahli Lembaga Pemeriksa Lebih daripada 2 orang)", :align=> :right, :size => 9, :style => :bold
  end
  
  def heading_table
    data = [["","","","","", "", "", "HARGA PEROLEHAN ASAL", "NILAI SEMASA", "", ""]]
    table(data , :column_widths => [30, 50, 100, 45, 50, 55, 50, 90, 90], :cell_style => { :size => 6}) do
     row(0).columns(0..6).borders = [:left, :right, :top]
     row(0).columns(9).borders = [:top, :right]
     row(0).columns(10).borders = [:top, :right, :left]
     self.width = 740
    end
  end
  
  def heading_table2
    data = [[ 'Bil', 'JABATAN/ BAHAGIAN', "KETERANGAN ASET", 'UNIT', 'KUANTITI', 'TARIKH PEMBELIAN','TEMPOH DIGUNAKAN / SIMPANAN',
        'SEUNIT (RM)', 'JUMLAH (RM)', 'SEUNIT (RM)', 'JUMLAH (RM)', 'NYATAKAN KEADAAN ASET DENGAN JELAS', 'SYOR KAEDAH PELUPUSAN DAN JUSTIFIKASI']]
    table(data , :column_widths => [30, 50, 100, 45, 50, 55, 50, 45, 45, 45, 45,90], :cell_style => { :size => 6}) do
     row(0).columns(0..6).borders = [:left, :right, :bottom]
     row(0).columns(10..12).borders =[:left, :right, :bottom]
     self.cell_style = { size: 6 }
     self.width = 740
     header = true
    end
  end
  
  def table1
    table(line_item_rows, :column_widths => [30, 50, 100, 45, 50, 55, 50, 45, 45, 45, 45,90], :cell_style => { :size => 6,  :inline_format => :true})  do
      columns(0..6).borders = [:left, :right, :bottom]
      columns(10..12).borders = [:left, :right, :bottom]
      self.row_colors = ["FEFEFE", "FFFFFF"]
      self.header = true
      self.cell_style = { size: 6 }
      self.width = 740
      header = true
    end
  end
  
  def line_item_rows
      counter = counter || 0
      header = []
      #header +
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
         
          header << ["#{counter += 1}", "#{disposal.try(:asset).try(:assignedto).try(:positions).try(:first).try(:unit) unless disposal.asset.assignedto.try(:positions).blank?}", "#{disposal.try(:asset).try(:assetcode)} #{disposal.try(:asset).try(:name)}", "" , quan ,"#{disposal.try(:asset).try(:purchasedate).try(:strftime, "%d/%m/%y")}", 
          "#{Date.today - disposal.try(:asset).try(:purchasedate)} hari", @view.currency(disposal.try(:asset).try(:purchaseprice).to_f), @view.currency(total.to_f), @view.currency(disposal.current_value.to_f), @view.currency(totalcurrent.to_f), disposal.try(:current_condition), disposal.justify1_disposal+"<br>"+disposal.justify2_disposal+"<br>"+disposal.justify3_disposal ] if counter < 14
        end    
      header
  end
  
  def table2
    table(line_item_rows2, :column_widths => [30, 50, 100, 45, 50, 55, 50, 45, 45, 45, 45,90], :cell_style => { :size => 6})  do
      columns(0..6).borders = [:left, :right, :bottom]
      columns(10..12).borders = [:left, :right, :bottom]
      self.row_colors = ["FEFEFE", "FFFFFF"]
      self.header = true
      self.cell_style = { size: 6 }
      self.width = 740
      header = true
    end
  end
  
  def line_item_rows2
      counter = counter || 0
       header = []
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
          
          header << ["#{counter}", "#{disposal.try(:asset).try(:assignedto).try(:positions).try(:first).try(:unit) unless disposal.asset.assignedto.try(:positions).blank?}", "#{disposal.try(:asset).try(:assetcode)} #{disposal.try(:asset).try(:name)}", "" , quan ,"#{disposal.try(:asset).try(:purchasedate).try(:strftime, "%d/%m/%y")}", 
          "#{Date.today - disposal.try(:asset).try(:purchasedate)} hari", @view.currency(disposal.try(:asset).try(:purchaseprice).to_f), @view.currency(total.to_f), @view.currency(disposal.current_value.to_f), @view.currency(totalcurrent.to_f), "", "" ] if counter > 14
          counter += 1
        end  
      lastone=[["#{@disposals.count+1}", "#{@disposal_end.try(:asset).try(:assignedto).try(:positions).try(:first).try(:unit) unless @disposal_end.asset.assignedto.try(:positions).blank?}", "#{@disposal_end.try(:asset).try(:assetcode)} #{@disposal_end.try(:asset).try(:name)}", "" , @quan ,"#{@disposal_end.try(:asset).try(:purchasedate).try(:strftime, "%d/%m/%y")}", 
          "#{Date.today - @disposal_end.try(:asset).try(:purchasedate)} hari", @view.currency(@disposal_end.try(:asset).try(:purchaseprice).to_f), @view.currency(@total.to_f), @view.currency(@disposal_end.current_value.to_f), @view.currency(@totalcurrent.to_f), "", "" ]] 

      header+lastone
  end

  def total_up
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
    
    qty=@disposal_end.try(:asset).try(:quantity)
    if qty.to_i < 1
      @count2=@disposal_end.try(:asset).try(:purchaseprice)
      @sum2=@disposal_end.current_value
    else
      a2=@disposal_end.try(:asset).try(:purchaseprice)
      c2=@disposal_end.current_value
      @count2=a2.to_i*qty.to_i
      @sum2=c2.to_i*qty.to_i
    end
    
    @count_tt=count+@count2
    @sum_tt=sum+@sum2
    @quan=qty
  end

  def total_table
    data2b = [["","JUMLAH KESELURUHAN", @view.currency(@count_tt.to_f),"", @view.currency(@sum_tt.to_f),""]]
    table(data2b, :column_widths => [325, 100, 45,  45, 45], :cell_style => { :size => 6}) do
      self.width = 740
      columns(1).align = :right
      columns(0).borders = []
      columns(1).borders = [:right]
      columns(3).borders = []
      columns(5).borders = []
    end
  end

  def signatory_table
    data = [["Tarikh pelantikan Lembaga pemeriksa #{'.'*65}", "Tandatangan ","#{'.'*45} (Pengerusi)"],
     [ "", "Nama ", "#{'.'*65}"],
     ["Tarikh pemeriksaan #{'.'*65}", "Jawatan", "#{'.'*65}"],
     ["Tempat pemeriksaan #{'.'*65}", "Tandatangan", "#{'.'*55} (Ahli)"],
     ["","Nama","#{'.'*65}"],
     ["","Jawatan", "#{'.'*65}"]]
          
    table(data, :column_widths => [420, 90, ], :cell_style => { :size => 9}) do
      row(0).height = 30
      row(2..3).height = 30
      columns(0..2).borders = []
    end
  end
  
end