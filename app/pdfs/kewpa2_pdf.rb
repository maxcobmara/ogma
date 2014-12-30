class Kewpa2Pdf < Prawn::Document
  def initialize(asset, view, lead)
    super({top_margin: 50, page_size: 'A4', page_layout: :portrait })
    @asset = asset
    @view = view
    @lead = lead
 
    font "Times-Roman"
    text "KEW.PA-2", :align => :right, :size => 14, :style => :bold
    text "(No. Siri Pendaftaran: #{@asset.assetcode} )", :align => :right, :size => 10
    move_down 5
    text "DAFTAR HARTA MODAL", :align => :center, :size => 12, :style => :bold
    move_down 5
    text "Kementerian/Jabatan   : Kolej Kesihatan Bersekutu Johor Bahru", :align => :left, :size => 12
    text "Bahagian  : #{@asset.try(:location).try(:name)}", :align => :left, :size => 12
    text "Bahagian A ", :align => :center, :size => 12, :style => :bold
    
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
                ["Jenis Dan No Enjin", "#{@asset.engine_type_id}" "-" "#{@asset.engine_no}", "Tarikh Terima", "#{@asset.receiveddate.try(:strftime, "%d-%m-%Y")}"],
                ["No Casis/Siri Pembuatan", "#{@asset.serialno}", "No Pesanan Rasmi Kerajaan", "#{@asset.orderno}"],
            ["No Pendaftaran (Bagi Kenderaan)", "#{@asset.registration} ", "Tempoh Jaminan","#{@asset.warranty_length} "] ]
    table(data1, :column_widths => [130, 130, 130, 130], :cell_style => { :size => 9}) 
         
    data2 =[ ["KOMPONEN/AKSESORI:", "Nama Pembekal Dan Alamat:"],
                   ["#{@asset.otherinfo}", "#{@asset.supplier_id.blank? ? "" : @asset.suppliedby.try(:name)}"],
                   ["", {content:"#{@asset.supplier_id.blank? ? '' : @asset.suppliedby.try(:address)}", rowspan: 3}],
                   [""],
                   [""],
                   ["", ""],
                   ["", "........................................................"],
                   ["","Tandatangan Ketua Jabatan"],
                   ["", "Nama     : #{@lead.try(:staff).try(:name)}"],
                   ["", "Jawatan  : #{@lead.name}"],
                   ["", "Tarikh   : "],
                   ["", "Cop      : "]]
    table(data2, :column_widths => [260, 260], :cell_style => { :size => 8}) do
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
    table(penem , :column_widths => [76,74,74,74,74,74,74], :cell_style => { :size => 8}) do
    end
  end
  
  def penem    
    @a=[]
    @b=[]
    @c=[]
    @asset.asset_placements.map do |asset_placement|
      @a << asset_placement.try(:location).try(:name)
      @b << asset_placement.reg_on.try(:strftime, "%d/%m/%Y")
      a = "#{asset_placement.try(:staff).try(:name)}"
      race = "#{asset_placement.try(:staff).try(:race)}".to_i
      religion = "#{asset_placement.try(:staff).try(:religion)}".to_i
      b = a.split("AL")[1]
      c = a.split("AP")[1]
      d = a.split("Binti")[1]
      e = a.split("Bt")[1]
      f = a.split("Bte")[1]
      g = a.split("bt")[1]
      h = a.split("binti")[1]
      i = a.split("bin")[1]
      j = a.split("b")[1]
      k = a.split(" ")[1]
    
      if b != nil 
        staffname = a.split("A/L")[0]
      elsif c != nil 
        staffname = a.split("A/P")[0]
      elsif d != nil 
        staffname = a.split("Binti")[0]
      elsif e != nil
        staffname = a.split("Bt")[0]
      elsif f != nil
        staffname = a.split("Bte")[0]
      elsif g != nil
        staffname = a.split("bt")[0]
      elsif h != nil
        staffname = a.split("binti")[0]
      elsif i != nil
        staffname = a.split("bin")[0]
      elsif j != nil
        staffname = a.split("b")[0]
      elsif k!= nil
        staffname= a.split(" ")[0,3].join(" ") if (race==2 || religion==4)
      end   
      @c << staffname
    end
       
    [["Lokasi", "#{@a[0]}","#{@a[1]}","#{@a[2]}","#{@a[3]}", "#{@a[4]}","#{@a[5]}"], 
     ["Tarikh", "#{@b[0]}","#{@b[1]}","#{@b[2]}","#{@b[3]}", "#{@b[4]}","#{@b[5]}"], 
     ["Nama Staff/Penyelia","#{@c[0]}","#{@c[1]}","#{@c[2]}","#{@c[3]}", "#{@c[4]}","#{@c[5]}"], 
     ["Tandatangan","","","","","",""]]
       
  end

  def make_table_pemeriksaan
    move_down 2
    header = [ ["PEMERIKSAAN"]]
    
    table(header , :column_widths => [520], :cell_style => { :size => 9}) do
      row(0).font_style = :bold
      row(0).align = :center
      row(0).background_color = 'FFE34D'   
    end
    data = [ ["Tarikh", "", "", "", "", "", ""],
           ["Status Aset", "", "", "", "", "", ""],
           ["Nama Pemeriksa", "", "", "", "", "", ""],
           ["Tandatangan", "", "", "", "", "", ""] ]
           
    table(data , :column_widths => [76,74,74,74,74,74,74], :cell_style => { :size => 8})
    move_down 2
  end
  
  def make_table_pelupusan
    header = [ ["PELUPUSAN/HAPUSKIRA"]]
    table(header , :column_widths => [520], :cell_style => { :size => 9}) do
      row(0).font_style = :bold
      row(0).align = :center
      row(0).background_color = 'FFE34D'
   end
   #data = [ ["Tarikh", "Rujukan", "Kaedah Pelupusan", "Kuantiti", "Lokasi", "Tandatangan"],
   #        ["Date", "", "", "", "", ""],
   #        ["Date", "", "", "", "", ""] ]      
   #table(data , :column_widths => [88, 92, 92, 88, 88, 72], :cell_style => { :size => 8})
   unless @asset.asset_disposal.blank?
     disposal_type = "Musnah" if @asset.asset_disposal.first.disposal_type == "discard"
     disposal_type = "Jual" if @asset.asset_disposal.first.disposal_type == "sold"
     disposal_type = "Stok" if @asset.asset_disposal.first.disposal_type == "stock"
     disposal_type = "Pindahan/Hadiah" if @asset.asset_disposal.first.disposal_type == "transfer"
     disposal_type = "Lain-lain Kaedah" if @asset.asset_disposal.first.disposal_type == "others"
     discard_option = "Buang" if @asset.asset_disposal.first.disposal_type == "discard" && @asset.asset_disposal.first.discard_options == "throw"
     discard_option = "Tanam" if @asset.asset_disposal.first.disposal_type == "discard" && @asset.asset_disposal.first.discard_options == "bury"
     discard_option = "Bakar" if @asset.asset_disposal.first.disposal_type == "discard" && @asset.asset_disposal.first.discard_options == "burn"
     discard_option = "Tenggelam" if @asset.asset_disposal.first.disposal_type == "discard" && @asset.asset_disposal.first.discard_options == "sink"
   end
   data = [ ["Rujukan Kelulusan", "Tarikh", "Kaedah Pelupusan", "Tandatangan"],
           ["#{@asset.asset_disposal.blank? ? "" : @asset.asset_disposal.first.try(:document).try(:title)}", "#{@asset.asset_disposal.blank? ? "" : @asset.asset_disposal.first.disposed_on.try(:strftime, '%d/%m/%y')}", "#{@asset.asset_disposal.blank? ? "" : disposal_type} #{' - '+ discard_option if @asset.asset_disposal.first.disposal_type=='discard'}", ""]]
   table(data, :column_widths => [150, 74, 148, 148], :cell_style => { :size => 8})
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
     rows(1..18).height = 20
   end
 end
 
 def kewpa2b_line_item_rows
   bb=[]
   1.upto(18-@asset.maints.count) do |cc|
     bb << ["","","","","",""]
   end
   counter = counter || 0
   header1 = [["Bil ", "Tarikh", "Butiran", "Tempoh Jaminan", "Kos (RM)", " Nama & Tandatangan"]]
   header1 +
   @asset.maints.map do |maint|
     ["#{counter += 1}", "#{maint.created_at.try(:strftime, "%d/%m/%y")}", "#{maint.details} ", "#{maint.workorderno} ",
       @view.currency(maint.maintcost.to_f),"#{maint.try(:asset).try(:staff).try(:name)}"]
   end
 end 
  
end