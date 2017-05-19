class Kewpa6Pdf < Prawn::Document
  def initialize(loanable, view)
    super({top_margin: 50, page_size: 'A4', page_layout: :landscape })
    @assetloans = loanable
    @view = view
    font "Times-Roman"
    kewpa6_heading
    
    ind=@pg=1
    table1
    table2
    asset_list
    blank_rows if @assetloans.count < 10 #first page only (max item per page=10)
    
    if @assetloans.count > 10                         #for test - use 1
       @assetloans.in_groups_of(10) do |set|   #for test - use 1
         @pg=ind
         if ind > 1
           start_new_page 
           kewpa6_heading
	   table1
           table2
           asset_list
         end
         ind+=1 #let it loop once first
       end
     end
 
  end
  
  def kewpa6_heading
    text "KEW.PA-6", :align => :right, :size => 16, :style => :bold
    move_down 15
    text "DAFTAR PERGERAKAN HARTA MODAL DAN INVENTORI", :align => :center, :size => 14, :style => :bold
    move_down 15
  end
  
  def table1
    data = [["Jenis:", "#{@assetloans.first.try(:asset).try(:typename)}", "", ""],
             ["Jenama dan Model:", "#{@assetloans.first.try(:asset).try(:name)} : #{@assetloans.first.try(:asset).try(:modelname)}","",""],
             ["No. Siri Pembuat:", "#{@assetloans.first.try(:asset).try(:serialno)}", "Pegawai Pengeluar",""],
             ["No. Siri Pendaftaran:", "#{@assetloans.first.try(:asset).try(:assetcode)}", "","Catatan"]]
             
    table(data, :column_widths => [170, 220, 220,159], :cell_style => { :size => 9}) do
          row(3).column(3).align = :center
          row(2).column(2).align = :center
          row(0).column(2).borders = [:left, :right, :top]
          row(0).column(3).borders = [:left, :right, :top]
          row(1).column(2).borders = [:left, :right]
          row(1).column(3).borders = [:left, :right]
          row(2).column(2).borders = [:left, :right]
          row(2).column(3).borders = [:left, :right]
          row(3).column(2).borders = [:left, :right, :bottom]
          row(3).column(3).borders = [:left, :right]
        end
    
  end
  def table2
    data = [["", "Nama", "Tarikh", "Tandatangan","Ketika Dikeluarkan", "Ketika Dipulangkan", ""]]
             
    table(data,:column_widths => [30, 130, 130,100,110,110,159 ], :cell_style => { :size => 9}) do
      row(0).column(2).borders = [:left, :right, :bottom]
      row(0).column(0).borders = [:left, :right]
      row(0).column(1).borders = [:left, :right]
      row(0).column(6).borders = [:left, :right]
      row(0).align = :center
    end
    
  end
  def asset_list

    table(line_item_rows,:column_widths => [30, 130, 65,65,100,60,50,60,50,159 ], :cell_style => { :size => 9}) do
      row(0).align = :center
      row(0).column(0).borders = [:left, :right, :bottom]
      row(0).column(1).borders = [:left, :right, :bottom]
      row(0).column(4).borders = [:left, :right, :bottom]
      row(0).column(9).borders = [:left, :right, :bottom]
      self.header = true
      header = true
    end
  end
  
  def line_item_rows
    counter = counter || 0
    header = [[ 'Bil', 'Peminjam', 'Dikeluarkan', 'Jangka Dipulangkan', ' Peminjam', 'Tandatangan', 'Tarikh', 'Tandatangan', 'Tarikh','']]
    
    if @assetloans.count < 10                                       #for test - hide this line 87
      @groupped_assetloans=@assetloans                   #for test - hide this line 88
    else                                                                          #for test - hide this line 89
       ##- for testing 
       ##(1) Working sample :http://localhost:3003/asset/assets/5/kewpa6.pdf?locale=en), 
       ##(2) set group_by 1 - refer for 'test - use 1' (3x - line 15, 16, 96) 
       ##(3) Hide line 87,88, 89 & 100 
       ## -- asal : '@assetloans.map do |asset_loan|'
       pgnum=0
       @assetloans.in_groups_of(10) do |set|                     #for test - use 1
          pgnum+=1
          @groupped_assetloans=set if @pg==pgnum
        end
    end                                                                           #for test - hide this line 100
    header +
      @groupped_assetloans.map do |asset_loan|
      ["#{@pg*(counter += 1)}", "#{asset_loan.try(:staff).try(:name)}", "#{asset_loan.loaned_on.try(:strftime, "%d/%m/%y")}", " #{asset_loan.expected_on.try(:strftime, "%d/%m/%y")}", "","#{asset_loan.try(:loanofficer).try(:name)}", 
        "#{asset_loan.approved_date.try(:strftime, "%d/%m/%y")}", "#{asset_loan.receivedofficer.try(:name)}", "#{asset_loan.returned_on.try(:strftime, "%d/%m/%y")}", "" ]
      end 
  end

  def blank_rows
    table(line_item_rows2,:column_widths => [30, 130, 65,65,100,60,50,60,50,159 ], :cell_style => { :size => 9, :height=>30}) do
      row(0).align = :center
      row(0).column(0).borders = [:left, :right, :bottom]
      row(0).column(1).borders = [:left, :right, :bottom]
      row(0).column(4).borders = [:left, :right, :bottom]
      row(0).column(9).borders = [:left, :right, :bottom]
      self.header = true
      header = true
    end
  end
  
  def line_item_rows2
    a=[]
    0.upto(10-@assetloans.count-1).each do |cnt|
      a << ["","","","","","","","","",""]
    end
    a
  end
 
end