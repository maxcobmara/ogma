class Kewpa11Pdf < Prawn::Document
  def initialize(location, view)
    super({top_margin: 50, page_size: 'A4', page_layout: :landscape })
    @location = location
    @view = view
    font "Times-Roman"
    text "KEW.PA-11", :align => :right, :size => 16, :style => :bold
    move_down 20
    text "LAPORAN PEMERIKSAAN INVENTORI", :align => :center, :size => 14, :style => :bold
    text "(Diisi oleh Pegawai Pemeriksa)", :align => :center, :size => 12
    move_down 10
    make_heading
    make_table2a if @location.asset_placements.p_inventory.count > 1
    #move_down 500 #for test
    if y < 250
      start_new_page
      make_heading
    end
    make_table2b if @location.asset_placements.p_inventory.count > 0
    make_empty_rows
    signatory
  end
  
  def make_heading
    heading1 = [["","","Daftar","","","",""]]            
    table(heading1, :column_widths => [30, 160,160,120,120,60,80], :cell_style => { :size => 9}) do
      row(0).height = 18
      row(0).columns(0..1).borders = [:top, :left, :right]
      row(0).columns(3..6).borders = [:top, :left, :right]
      columns(2).align = :center
      self.row_colors = ["FEFEFE", "FFFFFF"]
      self.header = true
      self.width = 730
      header = true
    end
    
    heading2 = [["Bil","Jenis Inventori","Lengkap","Kemaskini","Lokasi","Kuantiti","Keadaan", "Catatan"]]
    table(heading2, :column_widths => [30, 160,80,80,120,120,60,80], :cell_style => { :size => 9}) do
      row(0).height = 18  
      row(0).columns(0..1).borders = [:left, :right]
      row(0).columns(4..7).borders = [:left, :right]
      columns(4..5).align = :center
      columns(1).align = :center
      columns(7).align = :center
      self.row_colors = ["FEFEFE", "FFFFFF"]
      self.header = true
      self.width = 730
      header = true
    end
    
    heading3= [[ '', '', "Ya", 'Tidak',"Ya","Tidak","Mengikut Rekod", "Sebenar","Mengikut Rekod","Sebenar","Inventori",""]]
    table(heading3, :column_widths => [30, 160,40,40,40,40,60,60,60,60,60,80], :cell_style => { :size => 9}) do 
       row(0).height = 28
       row(0).columns(0).borders = [:left, :right, :bottom]
       row(0).columns(1).borders = [:left, :right, :bottom]
       row(0).columns(10..11).borders = [:left, :right, :bottom]
       columns(8..9).align = :center
       self.header = true
       self.width = 730
       header = true
     end
  end
  
  def data2a
    counter = counter || 0
    boddy=[]
    p_inv_count=@location.asset_placements.p_inventory.count
    if [3, 4].include?(asset_placement.location.root.lclass) #3-Staff Residence, 4-Student Residence
      location_details= asset_placement.try(:location).try(:combo_code)
    else
      location_details= asset_placement.try(:location).try(:name)
    end
    @location.asset_placements.p_inventory.each do |asset_placement|
      boddy << ["#{counter += 1}", "#{asset_placement.asset.name}","", "","","","#{location_details}","", "#{asset_placement.quantity}","","",""] if counter < p_inv_count-1
    end
    boddy
  end
   
  def make_table2a
     table(data2a, :column_widths => [30, 160,40,40,40,40,60,60,60,60,60,80], :cell_style => { :size => 9}) do 
       row(0).height = 28
       row(0).columns(0).borders = [:left, :right, :bottom]
       row(0).columns(1).borders = [:left, :right, :bottom]
       row(0).columns(10..11).borders = [:left, :right, :bottom]
       columns(8..9).align = :center
       self.header = true
       self.width = 730
       header = true
     end
  end 
  
  def data2b
    p_inv_count=@location.asset_placements.p_inventory.count
    p_inv=@location.asset_placements.p_inventory[p_inv_count-1]
    if [3, 4].include?(p_inv.location.root.lclass) #3-Staff Residence, 4-Student Residence
      location_details= p_inv.try(:location).try(:combo_code)
    else
      location_details= p_inv.try(:location).try(:name)
    end
    boddy = [["#{p_inv_count}", "#{p_inv.asset.name}","", "","","",location_details,"", "#{p_inv.quantity}","","",""]]
  end
   
  def make_table2b
     table(data2b, :column_widths => [30, 160,40,40,40,40,60,60,60,60,60,80], :cell_style => { :size => 9}) do 
       row(0).height = 28
       row(0).columns(0).borders = [:left, :right, :bottom]
       row(0).columns(1).borders = [:left, :right, :bottom]
       row(0).columns(10..11).borders = [:left, :right, :bottom]
       columns(8..9).align = :center
       self.header = true
       self.width = 730
       header = true
     end
  end 
    
  def make_empty_rows
    ccount=indx=@location.asset_placements.p_inventory.count
    data=[]
    if ccount < 5 #2 #for test use 2 - http://localhost:3003/campus/locations/1/kewpa11.pdf?locale=en
      while ccount < 5 #2
        ccount+=1
        data <<  ["","","","","","","","","","","",""]
      end
    end
    if indx < 5 #2
      table(data, :column_widths => [30, 160,40,40,40,40,60,60,60,60,60,80], :cell_style => { :size => 10}) do
        row(0..ccount).height = 25
        self.width = 730
      end
    end
    move_down 30
  end
  
  def signatory
     data = [["#{'.'*70}","","#{'.'*70}","","Nota:"],
             ["(Tandatangan)","", "(Tandatangan)","","Lokasi: Nyatakan lokasi inventori mengikut rekod dan lokasi inventori semasa pemeriksaan."],
             ["#{'.'*70}","","#{'.'*70}","",""],
             ["(Nama Pegawai Pemeriksa 1)","","(Nama Pegawai Pemeriksa 2)","","Daftar: Tandakan  /  pada yang berkenaan."],
             ["#{'.'*70}","","#{'.'*70}","",""],
             ["(Jawatan)","","(Jawatan)","","Keadaan Inventori: Nyatakan samada sedang diguna atau tidak digunakan"],
             ["#{'.'*70}","","#{'.'*70}","",""],
             ["(Tarikh Pemeriksaan)","","(Tarikh Pemeriksaan)","","Catatan : Penjelasan kepada penemuan pemeriksaan"]]
     
      table(data, :column_widths => [200,30, 200,30,270], :cell_style => { :size => 10}) do
        row(0).height = 18
        row(2).height = 18
        row(4).height = 18
        row(6).height = 18
        row(0..7).columns(0..3).borders = [ ]
        row(0).columns(4).borders = [:left, :right, :top]
        row(1..6).columns(4).borders = [:left, :right]
        row(7).columns(4).borders = [:left, :right, :bottom]
      end
  end
    
end