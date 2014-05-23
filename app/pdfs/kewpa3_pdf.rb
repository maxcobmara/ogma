class Kewpa3Pdf < Prawn::Document
  def initialize(asset, view)
    super({top_margin: 50, page_size: 'A4', page_layout: :portrait })
    @asset = asset
    @view = view

    font "Times-Roman"
    text "KEW.PA-3", :align => :right, :size => 16, :style => :bold
    text "(No. Siri Pendaftaran: #{@asset.assetcode} )", :align => :right, :size => 14
    move_down 15
    text "DAFTAR INVENTORY", :align => :center, :size => 14, :style => :bold
    move_down 15
    text "Kementerian/Jabatan   : Kolej Kesihatan Bersekutu Johor Bahru", :align => :left, :size => 14
    text "Bahagian  :", :align => :left, :size => 14
    move_down 5
    
    make_tables1
    make_table_penempatan
    make_table_pemeriksaan
    make_table_pelupusan
    penem
  end
  
  def cop 
    text "........................", :align => :center, :size => 11
    text "Tandatangan Ketua Jabatan", :align => :center, :size => 11
    move_down 3
    text "Nama    :", :align => :left, :size => 11
    text "Jawatan :", :align => :left, :size => 11
    text "Tarikh  :", :align => :left, :size => 11
    text "Cop     :", :align => :left, :size => 11
    
  end
    
  def make_tables1
    
    data = [ [ "Kod Nasional", " "], [ "Kategori ", "#{@asset.try(:assetcategoryies).try(:description)}"], [ "Sub Kategori", "#{@asset.subcategory} "] ]
       table(data, :column_widths => [130, 390], :cell_style => { :size => 10})
          
       data1 = [ ["Jenis", "#{@asset.typename}", "Harga Perolehan Asal", @view.currency(@asset.purchaseprice.to_f)], 
                ["Kuantiti", "#{@asset.quantity}", "Tarikh Diterima", "#{@asset.receiveddate.strftime("%d/%m/%y")}"],
                ["Unit Pengukuran", "#{@asset.quantity_type}", "No Pesanan Rasmi Kerajaan & Tarikh", "#{@asset.orderno} #{@asset.purchasedate.strftime("%d/%m/%y")}"],
            ["Tempoh Jaminan", "#{@asset.warranty_length} ", "",""] ]
         table(data1, :column_widths => [130, 150, 120, 120], :cell_style => { :size => 10}) 
         
         

         data2 =[ ["Nama Pembekal Dan Alamat:", "" ],
                  ["-#{@asset.supplier_id}", "       ........................................." ],
                  ["-#{@asset.supplier_id}", "       Tandatangan Ketua Jabatan" ],
                  ["-#{@asset.supplier_id}", "Nama     :   " ],
                  ["-#{@asset.supplier_id}", "Jawatan  :" ],
                  ["-#{@asset.supplier_id}", "Tarikh   :" ],
                  ["", "Cop      :" ],
                ]
         table(data2, :column_widths => [180, 340], :cell_style => { :size => 9}) do
         row(0).borders = [:top, :left, :right]
         row(1).borders = [:left, :right]
         row(2).borders = [:left, :right]
         row(3).borders = [:left, :right]
         row(4).borders = [:left, :right]
         row(5).borders = [:left, :right]
         row(6).borders = [:bottom, :left, :right]
         
         end

          move_down 5
  end

  
  def make_table_penempatan
    header = [ ["PENEMPATAN"]]
    table(header , :column_widths => [520]) do
    row(0).font_style = :bold
    row(0).align = :center
    row(0).background_color = 'FFE34D'
    
  end
  

  table(penem , :column_widths => [60,100, 110,70, 110, 70], :cell_style => { :size => 8}) do
    
  end
  end
  def penem
  
  header1 = [['Kuantiti', "No siri Pendaftaran", 'Lokasi', "Tarikh", "Nama Pegawai", "Tandatangan"]]
  header1 +
  @asset.asset_placements.map do |asset_placement|
    [ "#{asset_placement.quantity}", "#{asset_placement.try(:asset).try(:assetcode)}","#{asset_placement.try(:location).try(:name)}", "#{asset_placement.reg_on.strftime("%d/%m/%y")}","#{asset_placement.try(:staff).try(:name)}","" ]
 
  end
  
end

  def make_table_pemeriksaan
    move_down 5
    header = [ ["PEMERIKSAAN"]]
    table(header , :column_widths => [520]) do
    row(0).font_style = :bold
    row(0).align = :center
    row(0).background_color = 'FFE34D'
    
  end
  
  data = [ ["Tarikh", "", "", "", "", "", "", ""],
           ["Status Aset", "", "", "", "", "", "", ""],
           ["Nama Pemeriksa", "", "", "", "", "", "", ""],
           ["Tandatangan", "", "", "", "", "", "", ""] ]
           
  table(data , :column_widths => [100, 60, 60, 60, 60, 60, 60, 60], :cell_style => { :size => 9})
  move_down 5
  end
  
  def make_table_pelupusan
    header = [ ["PELUPUSAN/HAPUSKIRA"]]
    table(header , :column_widths => [520], ) do
    row(0).font_style = :bold
    row(0).align = :center
    row(0).background_color = 'FFE34D'
    
  end
  
  data = [ ["Tarikh", "Rujukan", "Kaedah Pelupusan", "Kuantiti", "Lokasi", "Tandatangan"],
           ["Date", "", "", "", "", ""],
           ["Date", "", "", "", "", ""] ]
           
  table(data , :column_widths => [88, 92, 92, 88, 88, 72], :cell_style => { :size => 9})
  end
end

  
