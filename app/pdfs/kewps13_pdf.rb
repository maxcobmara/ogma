class Kewps13Pdf < Prawn::Document
  def initialize(view, reporting_year)
    super({top_margin: 30, page_size: 'A4', page_layout: :landscape })
    #@stationeries = stationeries
    @view = view
    @reporting_year= reporting_year
    
    #Baki bawa hadapan
    acc_receive = 0 
    acc_usage = 0      
    s_add = StationeryAdd.where('received <= ?', (@reporting_year-1.year).end_of_year)
    #s_add = StationeryAdd.where('received <= ?',@reporting_year.last_year.end_of_year)
    s_add.each do |x|
      acc_receive += x.quantity*x.unitcost
    end 
    
    a = StationeryUse.where('issuedate <= ?', (@reporting_year-1.year).end_of_year).group_by{:stationery_id}
    #a = StationeryUse.where('issuedate <= ?', @reporting_year.last_year.end_of_year).group_by{:stationery_id}
    a.each do |stationeryid,s_uses|
      s_uses.each do |s_use|
        acc_usage += s_use.quantity*(StationeryAdd.where(stationery_id: s_use.stationery_id).first.unitcost)
      end 
    end
    
    @new_balance = acc_receive - acc_usage
    
    #Suku tahun Mac
    @mac_receive = 0
    @mac_usage = 0 
    #mac_add = StationeryAdd.where('received <= ? AND received >= ?',"2014-03-31","2014-01-01")  
    mac_add = StationeryAdd.where('received >=? AND received <?', @reporting_year.beginning_of_year, @reporting_year.beginning_of_year+3.months)
    mac_add.each do |x|
      @mac_receive += x.quantity*x.unitcost
    end 
    
    #a = StationeryUse.where('issuedate <= ? AND issuedate >= ?',"2014-03-31","2014-01-01").group_by{:stationery_id}
    a = StationeryUse.where(' issuedate >= ? AND issuedate < ?', @reporting_year.beginning_of_year, @reporting_year.beginning_of_year+3.months).group_by{:stationery_id}
    a.each do |stationeryid,s_uses|
      s_uses.each do |s_use|
        @mac_usage += s_use.quantity*(StationeryAdd.where(stationery_id: s_use.stationery_id).first.unitcost)
      end 
    end
    
    @mac_balance = (@new_balance + @mac_receive) - @mac_usage
    if (@new_balance + @mac_balance)==0
      @stock_rate_mac=0  #17May2017
    else
      @stock_rate_mac = @mac_usage/((@new_balance + @mac_balance)/2)
    end
    
    #Suku tahun Jun
    @jun_receive = 0
    @jun_usage = 0 
    
    jun_add = StationeryAdd.where('received >= ? AND received < ?', @reporting_year.beginning_of_year+3.months, @reporting_year.beginning_of_year+6.months)
    #jun_add = StationeryAdd.where('received >= ? AND received < ?', "2014-04-01", "2014-07-01")
    jun_add.each do |x|
      @jun_receive += x.quantity*x.unitcost
    end 
    
    a = StationeryUse.where('issuedate >= ? AND issuedate < ?', @reporting_year.beginning_of_year+3.months, @reporting_year.beginning_of_year+6.months).group_by{:stationery_id}
    a.each do |stationeryid,s_uses|
      s_uses.each do |s_use|
        @jun_usage += s_use.quantity*(StationeryAdd.where(stationery_id: s_use.stationery_id).first.unitcost)
      end 
    end
    
    @jun_balance = (@mac_balance + @jun_receive) - @jun_usage
    if (@mac_balance + @jun_balance)== 0
      @stock_rate_jun=0  #17May2017
    else
      @stock_rate_jun = @jun_usage/((@mac_balance + @jun_balance)/2)
    end
    
    #Suku tahun September
    @sep_receive = 0
    @sep_usage = 0 
    
    sep_add = StationeryAdd.where('received >= ? AND received < ?', @reporting_year.beginning_of_year+6.months, @reporting_year.beginning_of_year+9.months)
    sep_add.each do |x|
      @sep_receive += x.quantity*x.unitcost
    end 
    
    a = StationeryUse.where('issuedate >= ? AND issuedate < ?', @reporting_year.beginning_of_year+6.months,  @reporting_year.beginning_of_year+9.months).group_by{:stationery_id}
    a.each do |stationeryid,s_uses|
      s_uses.each do |s_use|
        @sep_usage += s_use.quantity*(StationeryAdd.where(stationery_id: s_use.stationery_id).first.unitcost)
      end 
    end
    
    @sep_balance = (@jun_balance + @sep_receive) - @sep_usage
    if (@jun_balance + @sep_balance)==0
      @stock_rate_sep = 0
    else
      @stock_rate_sep = @sep_usage/((@jun_balance + @sep_balance)/2)
    end
    
    #Suku tahun Disember
    @dis_receive = 0
    @dis_usage = 0 
    #@reporting_year.beginning_of_year+3.months && @reporting_year < @reporting_year.beginning_of_year+6.months
    dis_add = StationeryAdd.where('received >= ? AND received <= ?', @reporting_year.beginning_of_year+9.months, @reporting_year.end_of_year)
    dis_add.each do |x|
      @dis_receive += x.quantity*x.unitcost
    end 
    
    a = StationeryUse.where('issuedate >= ? AND issuedate <= ?', @reporting_year.beginning_of_year+9.months, @reporting_year.end_of_year).group_by{:stationery_id}
    a.each do |stationeryid,s_uses|
      s_uses.each do |s_use|
        @dis_usage += s_use.quantity*(StationeryAdd.where(stationery_id: s_use.stationery_id).first.unitcost)
      end 
    end
    
    @dis_balance = (@sep_balance + @dis_receive) - @dis_usage
    if (@sep_balance + @dis_balance)==0
      @stock_rate_dis = 0
    else
      @stock_rate_dis = @dis_usage/((@sep_balance + @dis_balance)/2)
    end
    
    #Nilai Tahunan
    @annual_rec_value = @mac_receive + @jun_receive + @sep_receive + @dis_receive
    @annual_use_value = @mac_usage + @jun_usage + @sep_usage + @dis_usage
    
    #Kadar Pusingan Stok Tahunan
    @stock_annual_leave = @stock_rate_mac + @stock_rate_jun + @stock_rate_sep + @stock_rate_dis

    move_up 20
    font "Times-Roman"
    text "KEW.PS-13", :align => :right, :size => 11, :style => :bold
    move_up 10
    text "LAPORAN KEDUDUKAN STOK TAHUN #{@reporting_year.year}", :align => :center, :size => 11, :style => :bold
    text "BAGI SUKU TAHUN #{'PERTAMA' if @reporting_year.month >=1 && @reporting_year.month<= 3}#{'KEDUA' if @reporting_year.month >=4 && @reporting_year.month<= 6}#{'KETIGA' if @reporting_year.month >=7 && @reporting_year.month<= 9}#{'KEEMPAT' if @reporting_year.month >=10 && @reporting_year.month<= 12} PADA #{I18n.l(@reporting_year, :format => "%d %b %Y")}", :align => :center, :size => 11, :style => :bold
    move_down 5
    text "KATEGORI STOR :", :align => :left, :size => 11, :style => :bold
    text "JENIS STOR : STOR ALAT TULIS", :align => :left, :size => 11, :style => :bold
    move_down 10
    
    make_tables1
    make_tables2 if @reporting_year.year == Date.today.year
    make_tables2b if @reporting_year.year != Date.today.year
    make_tables3

  end
  

    
  def make_tables1
    
    data = [ ["", "", "KEDUDUKAN", "STOK", "", "KADAR PUSINGAN"],
             ["", "Sedia Ada", "Pembelian/Penerimaan", "Pengeluaran/Penggunaan","Stok Semasa", "STOK"],
             ["TAHUN SEMASA", "Jumlah <br>Nilai Stok (RM)", "Jumlah <br>Nilai Stok (RM)", "Jumlah <br>Nilai Stok (RM)", "Jumlah <br>Nilai Stok (RM)", "c<br>#{'_'*15}"],
             ["", "(a)", "(b)", "(c)", "d = (a+b) - (c)", "[(a+d)/2]" ]]
          

         table(data, :column_widths => [100, 130, 130, 135, 130, 140 ], :cell_style => { :size => 12, :inline_format => :true}) do
           
           
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
           row(2).height = 40
           row(3).height = 20
	   row(1).align = :center
           row(2).align = :center
           row(3).align = :center
           
         end
           
    
     

    data1 = [ ["Baki Bawa Hadapan", "Baki Stok Akhir Tahun #{@reporting_year.last_year.year} @ #{@reporting_year.last_year.end_of_year.strftime("%d.%m.%Y")}" , "#{@new_balance}", ""]] 
    
    table(data1, :column_widths => [100, 395, 130, 140 ], :cell_style => { :size => 12})  do
      
      row(0).columns(1).align = :right
      row(0).columns(2).align = :right
      row(0).columns(3).background_color = '817A7A'
    end
        
  end
   
  def make_tables2
    
    data = [["#{'Suku Tahun 1/'+@reporting_year.year.to_s+' (31 Mac) '}", 
             "#{sprintf('%.2f',@new_balance)}", 
             "#{sprintf('%.2f',@mac_receive)}", 
             "#{sprintf('%.2f',@mac_usage)}", 
             "#{sprintf('%.2f',@mac_balance)}", 
             "#{sprintf('%.2f',@stock_rate_mac)}"],
          ["#{'Suku Tahun 2/'+@reporting_year.year.to_s+' (30 Jun) ' if @reporting_year > @reporting_year.beginning_of_year+3.months && @reporting_year < @reporting_year.beginning_of_year+6.months}", 
           "#{sprintf('%.2f',@mac_balance) if @reporting_year > @reporting_year.beginning_of_year+3.months && @reporting_year < @reporting_year.beginning_of_year+6.months}", 
           "#{sprintf('%.2f',@jun_receive) if @reporting_year > @reporting_year.beginning_of_year+3.months && @reporting_year < @reporting_year.beginning_of_year+6.months}", 
           "#{sprintf('%.2f',@jun_usage) if @reporting_year > @reporting_year.beginning_of_year+3.months && @reporting_year < @reporting_year.beginning_of_year+6.months if @reporting_year > @reporting_year.beginning_of_year+3.months && @reporting_year < @reporting_year.beginning_of_year+6.months}", 
           "#{sprintf('%.2f',@jun_balance) if @reporting_year > @reporting_year.beginning_of_year+3.months && @reporting_year < @reporting_year.beginning_of_year+6.months}", 
           "#{sprintf('%.2f',@stock_rate_jun) if @reporting_year > @reporting_year.beginning_of_year+3.months && @reporting_year < @reporting_year.beginning_of_year+6.months}"],
          ["#{'Suku Tahun 3/'+@reporting_year.year.to_s+ ' (30 Sep) ' if @reporting_year > @reporting_year.beginning_of_year+6.months && @reporting_year < @reporting_year.beginning_of_year+9.months}", 
           "#{sprintf('%.2f',@jun_balance) if @reporting_year > @reporting_year.beginning_of_year+6.months && @reporting_year < @reporting_year.beginning_of_year+9.months}", 
           "#{sprintf('%.2f',@sep_receive) if @reporting_year > @reporting_year.beginning_of_year+6.months && @reporting_year < @reporting_year.beginning_of_year+9.months}", 
           "#{sprintf('%.2f',@sep_usage) if @reporting_year > @reporting_year.beginning_of_year+6.months && @reporting_year < @reporting_year.beginning_of_year+9.months}", 
           "#{sprintf('%.2f',@sep_balance) if @reporting_year > @reporting_year.beginning_of_year+6.months && @reporting_year < @reporting_year.beginning_of_year+9.months}", 
           "#{sprintf('%.2f',@stock_rate_sep) if @reporting_year > @reporting_year.beginning_of_year+6.months && @reporting_year < @reporting_year.beginning_of_year+9.months}"],
          ["#{'Suku Tahun 4/'+@reporting_year.year.to_s+ ' (31 Dis) ' if @reporting_year > @reporting_year.beginning_of_year+9.months && @reporting_year < @reporting_year.end_of_year}", 
           "#{sprintf('%.2f',@sep_balance) if @reporting_year > @reporting_year.beginning_of_year+9.months && @reporting_year < @reporting_year.end_of_year}", 
           "#{sprintf('%.2f',@dis_receive) if @reporting_year  > @reporting_year.beginning_of_year+9.months && @reporting_year  < @reporting_year.end_of_year}", 
           "#{sprintf('%.2f',@dis_usage) if @reporting_year  > @reporting_year.beginning_of_year+9.months && @reporting_year  < @reporting_year.end_of_year}", 
           "#{sprintf('%.2f',@dis_balance) if @reporting_year  > @reporting_year.beginning_of_year+9.months && @reporting_year  < @reporting_year.end_of_year}", 
           "#{sprintf('%.2f',@stock_rate_dis) if @reporting_year  > @reporting_year.beginning_of_year+9.months && @reporting_year  < @reporting_year .end_of_year}"]]
          
    table(data, :column_widths => [100, 130, 130, 135, 130, 140 ], :cell_style => { :size => 12})  do
      row(0).height = 40
      row(1).height = 40
      row(2).height = 40
      row(3).height = 40
      column(1).align = :right
      column(2).align = :right
      column(3).align = :right
      column(4).align = :right
      column(5).align = :right
    end
    
    
    data1 = [["Nilai Tahunan", "#{sprintf('%.2f',@annual_rec_value)}", "#{sprintf('%.2f',@annual_use_value)}", "<b>Kadar Pusingan Stok Tahunan adalah:</b>", "#{sprintf('%.2f',@stock_annual_leave)}"]]
    
     table(data1, :column_widths => [230, 130, 135, 130, 140 ], :cell_style => { :size => 12,  :inline_format => :true}) do
       column(0).align = :center 
       column(1).align = :right
       column(2).align = :right
       column(4).align = :right
     end 
  end
  
  def make_tables2b
    
    data = [["#{'Suku Tahun 1/'+@reporting_year.year.to_s+' (31 Mac) '}", 
             "#{sprintf('%.2f',@new_balance)}", 
             "#{sprintf('%.2f',@mac_receive)}", 
             "#{sprintf('%.2f',@mac_usage)}", 
             "#{sprintf('%.2f',@mac_balance)}", 
             "#{sprintf('%.2f',@stock_rate_mac)}"],
          ["#{'Suku Tahun 2/'+@reporting_year.year.to_s+' (30 Jun) '}", 
           "#{sprintf('%.2f',@mac_balance)}", 
           "#{sprintf('%.2f',@jun_receive) }", 
           "#{sprintf('%.2f',@jun_usage) }", 
           "#{sprintf('%.2f',@jun_balance) }", 
           "#{sprintf('%.2f',@stock_rate_jun) }"],
          ["#{'Suku Tahun 3/'+@reporting_year.year.to_s+ ' (30 Sep) '}", 
           "#{sprintf('%.2f',@jun_balance) }", 
           "#{sprintf('%.2f',@sep_receive)}", 
           "#{sprintf('%.2f',@sep_usage)}", 
           "#{sprintf('%.2f',@sep_balance)}", 
           "#{sprintf('%.2f',@stock_rate_sep)}"],
          ["#{'Suku Tahun 4/'+@reporting_year.year.to_s+ ' (31 Dis) ' }", 
           "#{sprintf('%.2f',@sep_balance) }", 
           "#{sprintf('%.2f',@dis_receive) }", 
           "#{sprintf('%.2f',@dis_usage) }", 
           "#{sprintf('%.2f',@dis_balance)}", 
           "#{sprintf('%.2f',@stock_rate_dis) }"]]
          
    table(data, :column_widths => [100, 130, 130, 135, 130, 140 ], :cell_style => { :size => 12})  do
      row(0).height = 40
      row(1).height = 40
      row(2).height = 40
      row(3).height = 40
      column(1).align = :right
      column(2).align = :right
      column(3).align = :right
      column(4).align = :right
      column(5).align = :right
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

  
