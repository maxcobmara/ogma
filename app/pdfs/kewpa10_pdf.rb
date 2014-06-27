class Kewpa10Pdf < Prawn::Document
  def initialize(location, view, asset)
    super({top_margin: 50, page_size: 'A4', page_layout: :portrait })
    @location = location
    @view = view
    @assets = asset
    font "Times-Roman"
    text "KEW.PA-10", :align => :right, :size => 16, :style => :bold
    move_down 20
    text "LAPORAN PEMERIKSAAN HARTA MODAL", :align => :center, :size => 14, :style => :bold
    text "(Diisi oleh Pegawai Pemeriksa)", :align => :center, :size => 14
    move_down 10
    text "Kementerian/Jabatan:_________________________       Bahagian:_________________________", :align => :left, :size => 12
    move_down 5
    make_table1
    make_table2
    make_table3
    tandatangan

  end
  
  def make_table1
    
    data = [["","","","","Daftar"," (kew.pa-2)","",""],
            ["Bil","No. Siri","Jenis Harta","Lokasi","Lengkap","Kemaskini", "Keadaan Harta","Catatan"]]
            
    table(data, :column_widths => [30, 70,70,100,60,60,70,70], :cell_style => { :size => 9}) do
      row(0).height = 18
      row(1).height = 18
    row(0).columns(4).borders = [:top, :left, :bottom]
    row(0).columns(0).borders = [:top, :left, :right]
    row(0).columns(1).borders = [:top, :left, :right]
    row(0).columns(2).borders = [:top, :left, :right]
    row(0).columns(3).borders = [:top, :left, :right]
    row(0).columns(6).borders = [:top, :left, :right]
    row(0).columns(7).borders = [:top, :left, :right]
    row(1).columns(0).borders = [:left, :right]
    row(1).columns(1).borders = [:left, :right]
    row(1).columns(2).borders = [:left, :right]
    row(1).columns(3).borders = [ :left, :right]
    row(1).columns(6).borders = [:left, :right]
    row(1).columns(7).borders = [:left, :right]
    row(0).columns(4).align = :right
    row(0).columns(5).borders = [:top, :right, :bottom]
    columns(3).align = :center
    self.row_colors = ["FEFEFE", "FFFFFF"]
    self.header = true
    self.width = 530
    header = true
  end
 
  end
  
  def data2
    counter = counter || 0
    header = [[ '', 'Pendaftaran', "Modal", 'Mengikut Rekod',"Sebenar","Ya","Tidak","Ya", "Tidak","Modal",""]]
    header +
    
    @location.asset.map do |asset|
      ["#{counter += 1}", "#{asset.assetcode}","#{asset.name}", "#{asset.try(:location).try(:name)}","","","","", "","",""]
    end
   end
   def make_table2
    
     table(data2, :column_widths => [30, 70,70,50,50,30,30,30,30,70,70], :cell_style => { :size => 9}) do
       row(0).columns(0).borders = [:left, :right, :bottom]
       columns(0).align = :center
       row(0).columns(1).borders = [:left, :right, :bottom]
       row(0).columns(2).borders = [:left, :right, :bottom]
       row(0).columns(9).borders = [:left, :right, :bottom]
       row(0).columns(10).borders = [:left, :right, :bottom]
       self.header = true
       self.width = 530
       header = true
     end
     
   end 
    
   def make_table3 
     data = [["","","","","","","","","","",""],
            ["","","","","","","","","","",""],
          ["","","","","","","","","","",""]]
          
    table(data, :column_widths => [30, 70,70,50,50,30,30,30,30,70,70], :cell_style => { :size => 10}) do
            row(0).height = 25
            row(1).height = 25
            row(2).height = 25
            self.width = 530
          end
          move_down 30
        end
   def tandatangan
     
     data = [["#{'.'*40}","#{'.'*40}","Nota:"],
             ["(Tandatangan)", "(Tandatangan)","Lokasi: Nyatakan lokasi harta modal mengikut rekod dan lokasi harta modal semasa pemeriksaan."],
             ["#{'.'*40}","#{'.'*40}",""],
             ["(Nama Pegawai Pemeriksa 1)","(Nama Pegawai Pemeriksa 2)","Daftar: Tandakan  /  pada yang berkenaan."],
             ["#{'.'*40}","#{'.'*40}",""],
             ["(Jawatan)","(Jawatan)","Keadaan Harta Modal: Nyatakan samada sedang diguna atau tidak digunakan"],
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