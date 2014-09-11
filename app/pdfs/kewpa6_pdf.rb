class Kewpa6Pdf < Prawn::Document
  def initialize(asset, view)
    super({top_margin: 50, page_size: 'A4', page_layout: :portrait })
    @assets = asset
    @view = view
    font "Times-Roman"
    text "KEW.PA-6", :align => :right, :size => 16, :style => :bold
    move_down 15
    text "DAFTAR PERGERAKAN HARTA MODAL DAN INVENTORI", :align => :center, :size => 14, :style => :bold
    asset_list
    table1
    table2
   
  end
  
  def table1
    data = [["Jenis:", "#{@asset.typename}", "", ""],
             ["Jenama dan Model:", "#{@asset.name} : #{@asset.modelname}","",""],
             ["No. Siri Pembuat:", "#{@asset.serialno}", "Pegawai Pengeluar",""],
             ["No. Siri Pendaftaran:", "#{@asset.assetcode}", "","Catatan"]]
             
    table(data, :column_widths => [100, 100, 100,100]) do
          row(0).background_color = 'FFE34D'
          row(0).column(2).borders = [:left, :right, :top]
          row(0).column(3).borders = [:left, :right, :top]
          row(1).column(2).borders = [:left, :right]
          row(1).column(3).borders = [:left, :right]
          row(2).column(2).borders = [:left, :right]
          row(2).column(3).borders = [:left, :right]
          row(3).column(2).borders = [:left, :right, :bottom]
          row(3).column(3).borders = [:left, :right, :bottom]
        end
    
  end
  def table2
    data = [["", "", "Tarikh", "","Ketika Dikeluarkan", "Ketika Dipulangkan", ""]]
             
    table(data,:column_widths => [50, 100, 100,100]) do
      row(0).column(2).borders = [:left, :right, :bottom]
      row(0).column(3).borders = [:left, :right]
      row(0).background_color = 'FFE34D'
    end
    
  end
  def asset_list
    move_down 15
    
    table line_item_rows do
      
      row(0).background_color = 'FFE34D'
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
    header = [[ 'Bil', 'Nama Peminjam', 'Dikeluarkan', 'Jangka Dipulangkan', 'Tandatangan Peminjam', 'Tandatangan', 'Tarikh', 'Tandatangan', 'Tarikh','']]
    header +
      @asset.asset_loans.map do |asset_loan|
      ["#{counter += 1}", "#{asset_loan.staff_id}", "#{asset_loan.loaned_on.try(:strftime, "%d/%m/%y")}", " #{asset_loan.expected_on.try(:strftime, "%d/%m/%y")}", "","#{asset_loan.loaned_by}", 
        "#{asset_loan.approved_date.try(:strftime, "%d/%m/%y")}", "#{asset_loan.loan_officer}", "#{asset_loan.returned_on.try(:strftime, "%d/%m/%y")}", "" ]
 
  end
end
end