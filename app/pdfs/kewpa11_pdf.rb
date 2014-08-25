class Kewpa11Pdf < Prawn::Document
  def initialize(location, view)#, asset)
    super({top_margin: 50, page_size: 'A4', page_layout: :portrait })
    @location = location
    @view = view
    #@assets = asset
    font "Times-Roman"
    text "KEW.PA-11", :align => :right, :size => 16, :style => :bold
    move_down 20
    text "LAPORAN PEMERIKSAAN INVENTORY", :align => :center, :size => 14, :style => :bold
    text "(Diisi oleh Pegawai Pemeriksa)", :align => :center, :size => 12
    move_down 10
    make_table1
    make_table2
    make_table3
    tandatangan

  end
  
  def make_table1
    
    data = [["","","Daftar","","","",""]]
            
    table(data, :column_widths => [30, 60,120,100,100,50,70], :cell_style => { :size => 9}) do
      row(0).height = 18
    row(0).columns(0).borders = [:top, :left, :right]
    row(0).columns(1).borders = [:top, :left, :right]
    row(0).columns(3).borders = [:top, :left, :right]
    row(0).columns(4).borders = [:top, :left, :right]
    row(0).columns(5).borders = [:top, :left, :right]
    row(0).columns(6).borders = [:top, :left, :right]
    columns(2).align = :center
    self.row_colors = ["FEFEFE", "FFFFFF"]
    self.header = true
    self.width = 530
    header = true
  end
    data2 = [["Bil","Jenis Inventori","Lengkap","Kemaskini","Lokasi","Kuantiti","Keadaan", "Catatan"]]
            
    table(data2, :column_widths => [30, 60,60,60,100,100,50,70], :cell_style => { :size => 9}) do
      row(0).height = 18  
    row(0).columns(0).borders = [:left, :right]
    row(0).columns(1).borders = [:left, :right]
    row(0).columns(4).borders = [:left, :right]
    row(0).columns(5).borders = [:left, :right]
    row(0).columns(6).borders = [:left, :right]
    row(0).columns(7).borders = [:left, :right]
    columns(4).align = :center
    columns(5).align = :center
    columns(1).align = :center
    columns(7).align = :center
    self.row_colors = ["FEFEFE", "FFFFFF"]
    self.header = true
    self.width = 530
    header = true
  end
 
  end
  
  def data2
    counter = counter || 0
    header = [[ '', '', "Ya", 'Tidak',"Ya","Tidak","Mengikut Rekod", "Sebenar","Mengikut Rekod","Sebenar","Inventori",""]]
    header +
    
    #@location.asset.map do |asset|
    @location.asset_placements.p_inventory.map do |asset_placement|
      ["#{counter += 1}", "#{asset_placement.asset.name}","", "","","","#{asset_placement.try(:location).try(:name)}","", "#{asset_placement.quantity}","","",""]
    end
   end
   def make_table2
    
     table(data2, :column_widths => [30, 60,30,30,30,30,50,50,50,50,50,70], :cell_style => { :size => 9}) do 
       row(0).height = 28
       row(0).columns(0).borders = [:left, :right, :bottom]
       row(0).columns(1).borders = [:left, :right, :bottom]
       row(0).columns(10).borders = [:left, :right, :bottom]
       row(0).columns(11).borders = [:left, :right, :bottom]
       self.header = true
       self.width = 530
       header = true
     end
     
   end 
    
   def make_table3 
     data = [["","","","","","","","","","","",""],
            ["","","","","","","","","","","",""],
          ["","","","","","","","","","","",""]]
          
    table(data, :column_widths => [30, 60,30,30,30,30,50,50,50,50,50,70], :cell_style => { :size => 10}) do
            row(0).height = 25
            row(1).height = 25
            row(2).height = 25
            self.width = 530
          end
          move_down 30
        end
   def tandatangan
     
     data = [["#{'.'*40}","#{'.'*40}","Nota:"],
             ["(Tandatangan)", "(Tandatangan)","Lokasi: Nyatakan lokasi inventori mengikut rekod dan lokasi inventori semasa pemeriksaan."],
             ["#{'.'*40}","#{'.'*40}",""],
             ["(Nama Pegawai Pemeriksa 1)","(Nama Pegawai Pemeriksa 2)","Daftar: Tandakan  /  pada yang berkenaan."],
             ["#{'.'*40}","#{'.'*40}",""],
             ["(Jawatan)","(Jawatan)","Keadaan Inventori: Nyatakan samada sedang diguna atau tidak digunakan"],
             ["#{'.'*40}","#{'.'*40}",""],
             ["(Tarikh Pemeriksaan)","(Tarikh Pemeriksaan)","Catatan : Penjelasan kepada penemuan pemeriksaan"]]
     
      table(data, :column_widths => [140,140,200], :cell_style => { :size => 10}) do
        row(0).height = 18
        row(2).height = 18
        row(4).height = 18
        row(6).height = 18
        row(0).columns(0).borders = [ ]
        row(1).columns(0).borders = [ ]
        row(2).columns(0).borders = [ ]
        row(3).columns(0).borders = [ ]
        row(4).columns(0).borders = [ ]
        row(5).columns(0).borders = [ ]
        row(6).columns(0).borders = [ ]
        row(7).columns(0).borders = [ ]
        row(0).columns(1).borders = [ ]
        row(1).columns(1).borders = [ ]
        row(2).columns(1).borders = [ ]
        row(3).columns(1).borders = [ ]
        row(4).columns(1).borders = [ ]
        row(5).columns(1).borders = [ ]
        row(6).columns(1).borders = [ ]
        row(7).columns(1).borders = [ ]
        row(0).columns(2).borders = [:left, :right, :top]
        row(1).columns(2).borders = [:left, :right]
        row(2).columns(2).borders = [:left, :right]
        row(3).columns(2).borders = [:left, :right]
        row(4).columns(2).borders = [:left, :right]
        row(5).columns(2).borders = [:left, :right]
        row(6).columns(2).borders = [:left, :right]
        row(7).columns(2).borders = [:left, :right, :bottom]
        
   end
 end
    
end