class Kewps13Pdf < Prawn::Document
  def initialize(stationeries, view, lead)
    super({top_margin: 30, page_size: 'A4', page_layout: :landscape })
    @stationeries = stationeries
    @view = view
    @lead = lead
    
    #Baki bawa hadapan
    acc_receive = 0 
    acc_usage = 0      
    s_add = StationeryAdd.where('received <= ?',"2013-12-31")
    s_add.each do |x|
      acc_receive += x.quantity*x.unitcost
    end 
    
    a = StationeryUse.where('issuedate <= ?', "2013-12-31").group_by{:stationery_id}
    a.each do |stationeryid,s_uses|
      s_uses.each do |s_use|
        acc_usage += s_use.quantity*(StationeryAdd.where(stationery_id: s_use.stationery_id).first.unitcost)
      end 
    end
    
    @new_balance = acc_receive - acc_usage
    
    #Suku tahun Mac
    @mac_receive = 0
    @mac_usage = 0 
    mac_add = StationeryAdd.where('received <= ? AND received >= ?',"2014-03-31","2014-01-01")
    mac_add.each do |x|
      @mac_receive += x.quantity*x.unitcost
    end 
    
    a = StationeryUse.where('issuedate <= ? AND issuedate >= ?',"2014-03-31","2014-01-01").group_by{:stationery_id}
    a.each do |stationeryid,s_uses|
      s_uses.each do |s_use|
        @mac_usage += s_use.quantity*(StationeryAdd.where(stationery_id: s_use.stationery_id).first.unitcost)
      end 
    end
    
    @mac_balance = (@new_balance + @mac_receive) - @mac_usage
    @stock_rate_mac = @mac_usage/((@new_balance + @mac_balance)/2)
    
    #Suku tahun Jun
    @jun_receive = 0
    @jun_usage = 0 
    jun_add = StationeryAdd.where('received <= ? AND received >= ?',"2014-03-31","2014-01-01")
    jun_add.each do |x|
      @jun_receive += x.quantity*x.unitcost
    end 
    
    a = StationeryUse.where('issuedate <= ? AND issuedate >= ?',"2014-03-31","2014-01-01").group_by{:stationery_id}
    a.each do |stationeryid,s_uses|
      s_uses.each do |s_use|
        @jun_usage += s_use.quantity*(StationeryAdd.where(stationery_id: s_use.stationery_id).first.unitcost)
      end 
    end
    
    @jun_balance = (@mac_balance + @jun_receive) - @jun_usage
    @stock_rate_jun = @jun_usage/((@mac_balance + @jun_balance)/2)
    
    #Suku tahun September
    @sep_receive = 0
    @sep_usage = 0 
    sep_add = StationeryAdd.where('received <= ? AND received >= ?',"2014-03-31","2014-01-01")
    sep_add.each do |x|
      @sep_receive += x.quantity*x.unitcost
    end 
    
    a = StationeryUse.where('issuedate <= ? AND issuedate >= ?',"2014-03-31","2014-01-01").group_by{:stationery_id}
    a.each do |stationeryid,s_uses|
      s_uses.each do |s_use|
        @sep_usage += s_use.quantity*(StationeryAdd.where(stationery_id: s_use.stationery_id).first.unitcost)
      end 
    end
    
    @sep_balance = (@jun_balance + @sep_receive) - @sep_usage
    @stock_rate_sep = @sep_usage/((@jun_balance + @sep_balance)/2)
    
    #Suku tahun Disember
    @dis_receive = 0
    @dis_usage = 0 
    dis_add = StationeryAdd.where('received <= ? AND received >= ?',"2014-03-31","2014-01-01")
    dis_add.each do |x|
      @dis_receive += x.quantity*x.unitcost
    end 
    
    a = StationeryUse.where('issuedate <= ? AND issuedate >= ?',"2014-03-31","2014-01-01").group_by{:stationery_id}
    a.each do |stationeryid,s_uses|
      s_uses.each do |s_use|
        @dis_usage += s_use.quantity*(StationeryAdd.where(stationery_id: s_use.stationery_id).first.unitcost)
      end 
    end
    
    @dis_balance = (@sep_balance + @dis_receive) - @dis_usage
    @stock_rate_dis = @dis_usage/((@sep_balance + @dis_balance)/2)
    
    #Nilai Tahunan
    @annual_value = @mac_receive + @jun_receive + @sep_receive + @dis_receive
    
    #Kadar Pusingan Stok Tahunan
    @stock_annual_leave = @stock_rate_mac + @stock_rate_jun + @stock_rate_sep + @stock_rate_dis

    move_up 20
    font "Times-Roman"
    text "KEW.PS-13", :align => :right, :size => 15, :style => :bold
    move_up 10
    text "LAPORAN KEDUDUKAN STOK TAHUN #{Time.new.last_year}", :align => :center, :size => 14
    text "BAGI SUKU TAHUN KEDUA PADA  ", :align => :center, :size => 14
    move_down 5
    text "KATEGORI STOR :", :align => :left, :size => 14
    text "JENIS STOR : STOR ALAT TULIS", :align => :left, :size => 14
    move_down 20
    
    make_tables1
    make_tables2
    make_tables3

  end
  

    
  def make_tables1
    
    data = [ ["", "", "KEDUDUKAN", "STOK", "", "KADAR PUSINGAN"],
             ["", "Sedia Ada", "Pembelian/Penerimaan", "Pengeluaran/Penggunaan","Stok Semasa", "STOK"],
             ["TAHUN ", "Jumlah Nilai Stok (RM)", "Jumlah Nilai Stok (RM)", "Jumlah Nilai Stok (RM)", "Jumlah Nilai Stok (RM)", ""],
             ["SEMASA", "(a)", "(b)", "(c)", "d = (a+b) - (c)", "c / [(a+d)/2]" ]]
          

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
           
    
     

    data1 = [ ["Baki Bawa Hadapan", "Baki Stok Akhir Tahun" , "#{@new_balance}", ""]] 
    
    table(data1, :column_widths => [100, 395, 130, 140 ], :cell_style => { :size => 12})  do
      
      row(0).columns(1).align = :right
    end
        
  end
  
  def make_tables2
    
    data = [["Suku Tahun 1/2013 (31 Mac)", "#{@new_balance}", "#{@mac_receive}", "#{@mac_usage}", "#{@mac_balance}", "#{@stock_rate_mac}"],
          ["Suku Tahun 2/2013 (30 Jun)", "#{@mac_balance}", "#{@jun_receive}", "#{@jun_usage}", "#{@jun_balance}", "#{@stock_rate_jun}"],
          ["Suku Tahun 3/2013 (30 Sep)", "#{@jun_balance}", "#{@sep_receive}", "#{@sep_usage}", "#{@sep_balance}", "#{@stock_rate_sep}"],
          ["Suku Tahun 4/2013 (31 Dis) ", "#{@sep_balance}", "#{@dis_receive}", "#{@dis_usage}", "#{@dis_balance}", "#{@stock_rate_dis}"]]
          
    table(data, :column_widths => [100, 130, 130, 135, 130, 140 ], :cell_style => { :size => 12})  do
      row(0).height = 40
      row(1).height = 40
      row(2).height = 40
      row(3).height = 40
    end
    
    
    data1 = [["Nilai Tahunan", "#{@annual_value}", "", "Kadar Pusingan Stok Tahunan adalah:", "#{@stock_annual_leave}"]]
    
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

  
