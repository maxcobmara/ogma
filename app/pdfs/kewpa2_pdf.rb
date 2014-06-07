class Kewpa2Pdf < Prawn::Document
  def initialize(asset, view)
    super({top_margin: 50, page_size: 'A4', page_layout: :portrait })
    @asset = asset
    @view = view
 

    font "Times-Roman"
    text "KEW.PA-2", :align => :right, :size => 14, :style => :bold
    text "(No. Siri Pendaftaran: #{@asset.assetcode} )", :align => :right, :size => 10
    move_down 10
    text "DAFTAR HARTA MODAL", :align => :center, :size => 12, :style => :bold
    move_down 10
    text "Kementerian/Jabatan   : Kolej Kesihatan Bersekutu Johor Bahru", :align => :left, :size => 12
    text "Bahagian  :", :align => :left, :size => 12
    text "Bahagian A ", :align => :center, :size => 12, :style => :bold
    move_down 5
    
    make_tables1
    make_table_penempatan
    make_table_pemeriksaan
    make_table_pelupusan
    penem
    kewpa2b
    kewpa2b_make_tables2


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
    
    data = [ [ "Kod Nasional", " "], [ "Kategori ", "#{@asset.try(:assetcategoryies).try(:description)}"], [ "Sub Kategori", "#{@asset.subcategory} "], 
             [ "Jenis/Jenama/Model", "#{@asset.typename} " "/" "#{@asset.name}" "/" "#{@asset.modelname}"]  ]
       table(data, :column_widths => [130, 390], :cell_style => { :size => 9})
          
       data1 = [ ["Buatan", "#{@asset.country_id}", "Harga Perolehan Asal", @view.currency(@asset.purchaseprice.to_f)], 
                ["Jenis Dan No Enjin", "#{@asset.engine_type_id}" "-" "#{@asset.engine_no}", "Tarikh Terima", "#{@asset.receiveddate.strftime("%d/%m/%y")}"],
                ["No Casis/Siri Pembuatan", "#{@asset.serialno}", "No Pesanan Rasmi Kerajaan", "#{@asset.orderno}"],
            ["No Pendaftaran (Bagi Kenderaan)", "#{@asset.registration} ", "Tempoh Jaminan","#{@asset.warranty_length} "] ]
         table(data1, :column_widths => [130, 150, 120, 120], :cell_style => { :size => 9}) 
         
         
         data2 =[ ["KOMPONEN/AKSESORI:", "Nama Pembekal Dan Alamat: #{@asset.supplier_id}"],
                   ["#{@asset.otherinfo}", "-#{@asset.supplier_id}"],
                   ["", "-#{@asset.supplier_id}"],
                   ["", "-#{@asset.supplier_id}"],
                   ["", "-#{@asset.supplier_id}"],
                   ["", ""],
                   ["", "........................................................"],
                   ["","Tandatangan Ketua Jabatan"],
                   ["", "Nama     : "],
                   ["", "Jawatan  :"],
                   ["", "Tarikh   : "],
                   ["", "Cop      : "]]

         table(data2, :column_widths => [200, 320], :cell_style => { :size => 8}) do
         row(0).borders = [:top, :left, :right]
         row(1).borders = [:left, :right]
         row(2).borders = [:left, :right]
         row(3).borders = [:left, :right]
         row(4).borders = [:left, :right]
         row(5).borders = [:left, :right]
         row(5).columns(1).borders = [:top, :right]
         row(6).borders = [:left, :right]
         row(6).align = :center
         row(7).borders = [:left, :right]
         row(7).align = :center
         row(8).borders = [:left, :right]
         row(9).borders = [:left, :right]
         row(10).borders = [:left, :right]
         row(11).borders = [:left, :right,:bottom]
         
         
         end

          move_down 2
  end

  
  def make_table_penempatan
    header = [ ["PENEMPATAN"]]
    table(header , :column_widths => [520], :cell_style => { :size => 9}) do
    row(0).font_style = :bold
    row(0).align = :center
    row(0).background_color = 'FFE34D'
    
  end
  

  table(penem , :column_widths => [150,140, 150, 80 ], :cell_style => { :size => 8}) do
    
  end
  end
  def penem
  
  header1 = [['Lokasi', "Tarikh", "Nama Pegawai", "Tandatangan"]]
  header1 +
  @asset.asset_placements.map do |asset_placement|
    [ "#{asset_placement.try(:location).try(:name)}", "#{asset_placement.reg_on.strftime("%d/%m/%y")}","#{asset_placement.try(:staff).try(:name)}","" ]
 
  end
  
end

  def make_table_pemeriksaan
    move_down 2
    header = [ ["PEMERIKSAAN"]]
    table(header , :column_widths => [520], :cell_style => { :size => 9}) do
    row(0).font_style = :bold
    row(0).align = :center
    row(0).background_color = 'FFE34D'
    
  end
  
  data = [ ["Tarikh", "", "", "", "", "", "", ""],
           ["Status Aset", "", "", "", "", "", "", ""],
           ["Nama Pemeriksa", "", "", "", "", "", "", ""],
           ["Tandatangan", "", "", "", "", "", "", ""] ]
           
  table(data , :column_widths => [100, 60, 60, 60, 60, 60, 60, 60], :cell_style => { :size => 8})
  move_down 2
  end
  
  def make_table_pelupusan
    header = [ ["PELUPUSAN/HAPUSKIRA"]]
    table(header , :column_widths => [520],:cell_style => { :size => 9} ) do
    row(0).font_style = :bold
    row(0).align = :center
    row(0).background_color = 'FFE34D'
    
  end
  
  data = [ ["Tarikh", "Rujukan", "Kaedah Pelupusan", "Kuantiti", "Lokasi", "Tandatangan"],
           ["Date", "", "", "", "", ""],
           ["Date", "", "", "", "", ""] ]
           
  table(data , :column_widths => [88, 92, 92, 88, 88, 72], :cell_style => { :size => 8})
  start_new_page
  end
  
  
  def kewpa2b

    font "Times-Roman"
    text "KEW.PA-2", :align => :right, :size => 14, :style => :bold
    move_down 10
    text "DAFTAR HARTA MODAL", :align => :center, :size => 12, :style => :bold
    move_down 10
    text "BUTIR BUTIR PENAMBAHAN, PENGGANTIAN DAN NAIKTARAF", :align => :center, :size => 12
    move_down 10
    text "Bahagian B ", :align => :center, :size => 12, :style => :bold
    move_down 5
    
  end
  

  
 def kewpa2b_make_tables2
   table(kewpa2b_line_item_rows, :column_widths => [30, 90, 100, 100, 100, 100], :cell_style => { :size => 10})do
    row(0).font_style = :bold
    row(0).align = :center
    row(0).background_color = 'FFE34D'
  end
 end
 
 def kewpa2b_line_item_rows
   counter = counter || 0
   header1 = [["Bil ", "Tarikh", "Butiran", "Tempoh Jaminan", "kos (RM)", " Nama & Tandatangan"]]
   header1 +
   @asset.maints.map do |maint|
     ["#{counter += 1}", "#{maint.created_at}", "#{maint.details} ", "#{maint.workorderno} ",
       @view.currency(maint.maintcost.to_f),"#{maint.try(:asset).try(:staff).try(:name)}"]
   end
 end 
  
  
end

  
