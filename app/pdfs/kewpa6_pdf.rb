class Kewpa6Pdf < Prawn::Document
  def initialize(asset, view)
    super({top_margin: 50, page_size: 'A4', page_layout: :portrait })
    @asset = asset
    @view = view
    font "Times-Roman"
    text "KEW.PA-6", :align => :right, :size => 16, :style => :bold
    move_down 15
    text "DAFTAR PERGERAKAN HARTA MODAL DAN INVENTORI", :align => :center, :size => 14, :style => :bold
    move_down 15
    table1
    table2
    asset_list
   
  end
  
  def table1
    data = [["Jenis:", "#{@asset.typename}", "", ""],
             ["Jenama dan Model:", "#{@asset.name} : #{@asset.modelname}","",""],
             ["No. Siri Pembuat:", "#{@asset.serialno}", "Pegawai Pengeluar",""],
             ["No. Siri Pendaftaran:", "#{@asset.assetcode}", "","Catatan"]]
             
    table(data, :column_widths => [120, 120, 200,80], :cell_style => { :size => 9}) do
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
             
    table(data,:column_widths => [30, 80, 80,50,100,100,80 ], :cell_style => { :size => 9}) do
      row(0).column(2).borders = [:left, :right, :bottom]
      row(0).column(0).borders = [:left, :right]
      row(0).column(1).borders = [:left, :right]
      row(0).column(6).borders = [:left, :right]
      row(0).align = :center
    end
    
  end
  def asset_list

    table(line_item_rows,:column_widths => [30, 80, 40,40,50,50,50,50,50,80 ], :cell_style => { :size => 9}) do
      
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
    header +
      @asset.asset_loans.map do |asset_loan|
      ["#{counter += 1}", "#{asset_loan.staff_id}", "#{asset_loan.loaned_on.try(:strftime, "%d/%m/%y")}", " #{asset_loan.expected_on.try(:strftime, "%d/%m/%y")}", "","#{asset_loan.loaned_by}", 
        "#{asset_loan.approved_date.try(:strftime, "%d/%m/%y")}", "#{asset_loan.loan_officer}", "#{asset_loan.returned_on.try(:strftime, "%d/%m/%y")}", "" ]
 
  end
end
end