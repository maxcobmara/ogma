class Kewpa3Pdf < Prawn::Document
  def initialize(asset, view, lead)
    super({top_margin: 50, page_size: 'A4', page_layout: :portrait })
    @asset = asset
    @view = view
    @lead = lead

    font "Times-Roman"
    text "KEW.PA-3", :align => :right, :size => 16, :style => :bold
    text "(No. Siri Pendaftaran: #{@asset.assetcode} )", :align => :right, :size => 14
    move_down 15
    text "DAFTAR INVENTORI", :align => :center, :size => 14, :style => :bold
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
                ["Kuantiti", "#{@asset.quantity}", "Tarikh Diterima", "#{@asset.receiveddate.try(:strftime, "%d-%m-%Y")}"],
                ["Unit Pengukuran", "#{@asset.quantity_type}", "No Pesanan Rasmi Kerajaan & Tarikh", "#{@asset.orderno} #{@asset.purchasedate.try(:strftime, "%d-%m-%Y")}"],
                ["Tempoh Jaminan", "#{@asset.warranty_length} ", "",""] ]
    table(data1, :column_widths => [130, 150, 120, 120], :cell_style => { :size => 10}) 
   
    data2 =[ ["Nama Pembekal Dan Alamat:", "" ],
               ["#{@asset.supplier_id.blank? ? "" : @asset.suppliedby.try(:name)}", "       ........................................." ],
               [{content:"#{@asset.supplier_id.blank? ? '' : @asset.suppliedby.try(:address)}", rowspan: 4}, "       Tandatangan Ketua Jabatan" ],
               [ "Nama     : #{@lead.try(:staff).try(:name)}" ],
               [ "Jawatan  : #{@lead.name}" ],
               [ "Tarikh   :" ],
               ["", "Cop      :" ],
                ]
    table(data2, :column_widths => [220, 300], :cell_style => { :size => 9}) do
         row(0).borders = [:top, :left, :right]
         cells[1,0].align = :left
         cells[1,1].align = :center
         row(1).borders = [:left, :right]
         row(2).borders = [:left, :right]
         row(2).align = :center
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
    table(penem , :column_widths => [79,63,63,63,63,63,63,63], :cell_style => { :size => 8}) do
      columns(1..7).align = :center
    end
  end
 
  def penem    
    @a=[]
    @b=[]
    @c=[]
    @d=[]
    @e=[]
    @asset.asset_placements.map do |asset_placement|
      @a << asset_placement.quantity
      @b << asset_placement.try(:asset).try(:assetcode)
      @c << asset_placement.try(:location).try(:name)
      @d << asset_placement.reg_on.try(:strftime, "%d/%m/%Y")
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
      @e << staffname
    end
       
    [["Kuantiti", "#{@a[0]}","#{@a[1]}","#{@a[2]}","#{@a[3]}", "#{@a[4]}","#{@a[5]}", "#{@a[6]}"], 
     ["No.Siri Pendaftaran", "#{@b[0]}","#{@b[1]}","#{@b[2]}","#{@b[3]}", "#{@b[4]}","#{@b[5]}", "#{@b[6]}"], 
     ["Lokasi","#{@c[0]}","#{@c[1]}","#{@c[2]}","#{@c[3]}", "#{@c[4]}","#{@c[5]}", "#{@c[6]}"], 
     ["Tarikh","#{@d[0]}","#{@d[1]}","#{@d[2]}","#{@d[3]}", "#{@d[4]}","#{@d[5]}","#{@d[6]}"], 
     ["Nama Pegawai","#{@e[0]}","#{@e[1]}","#{@e[2]}","#{@e[3]}", "#{@e[4]}","#{@e[5]}", "#{@e[6]}"], 
     ["Tandatangan","","","","","","",""]]
       
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
    table(data , :column_widths => [79,63,63,63,63,63,63,63], :cell_style => { :size => 9})
    move_down 5
  end
  
  def make_table_pelupusan
    header = [ ["PELUPUSAN/HAPUSKIRA"]]
    table(header , :column_widths => [520], ) do
      row(0).font_style = :bold
      row(0).align = :center
      row(0).background_color = 'FFE34D'
    end
    
    left_title = [ ["Tarikh","Rujukan","Kaedah Pelupusan", "Kuantiti", "Lokasi", "Tandatangan"]] 
    
    unless @asset.asset_disposal.blank?
      data2 = []
      @asset.asset_disposal.map do |asset_disposal|
        disposal_type = "Musnah" if asset_disposal.disposal_type == "discard"
        disposal_type = "Jual" if asset_disposal.disposal_type == "sold"
        disposal_type = "Stok" if asset_disposal.disposal_type == "stock"
        disposal_type = "Pindahan/Hadiah" if asset_disposal.disposal_type == "transfer"
        disposal_type = "Lain-lain Kaedah" if asset_disposal.disposal_type == "others"
        discard_option = "Buang" if asset_disposal.disposal_type == "discard" && asset_disposal.discard_options == "throw"
        discard_option = "Tanam" if asset_disposal.disposal_type == "discard" && asset_disposal.discard_options == "bury"
        discard_option = "Bakar" if asset_disposal.disposal_type == "discard" && asset_disposal.discard_options == "burn"
        discard_option = "Tenggelam" if asset_disposal.disposal_type == "discard" && asset_disposal.discard_options == "sink"
        data2<<["#{asset_disposal.disposed_on.try(:strftime, '%d/%m/%y')}",
                    "#{asset_disposal.try(:document).try(:title)}", 
                    "#{disposal_type} #{' - '+ discard_option if asset_disposal.disposal_type=='discard'}",
                    "#{asset_disposal.try(:quantity)}",
                    "#{asset_disposal.try(:discard_location)}",
                    ""]
      end
    end
    
    data = left_title+data2    
    table(data , :column_widths => [50, 90, 120, 60, 100, 100], :cell_style => { :size => 9})
  end
end