class Kewpa10Pdf < Prawn::Document
  def initialize(location, view, assets_located_at, college)
    super({top_margin: 50, page_size: 'A4', page_layout: :landscape })
    @location = location
    @view = view
    @assets_located_at = assets_located_at

    font "Times-Roman"
    text "KEW.PA-10", :align => :right, :size => 16, :style => :bold
    move_down 20
    text "LAPORAN PEMERIKSAAN HARTA MODAL", :align => :center, :size => 14, :style => :bold
    text "(Diisi oleh Pegawai Pemeriksa)", :align => :center, :size => 14
    move_down 10
    text "Kementerian/Jabatan: #{college.name}                                                        Bahagian:_________________________", :align => :left, :size => 12
    move_down 5
    make_heading1
    make_heading2
    make_data1 if @assets_located_at.hm.count > 1
    #text "#{y}"
    #move_down 500 #for test
    if y < 240
      start_new_page
      make_heading1
      make_heading2
    end
    make_data2 if @assets_located_at.hm.count > 0
    make_empty_rows
    signatory
    #text "#{y}"
  end
  
  def make_heading1
    heading1 = [["","","","","Daftar"," (KEW.PA-2)","",""],
            ["Bil","No. Siri","Jenis Harta","Lokasi","Lengkap","Kemaskini", "Keadaan Harta","Catatan"]]
            
    table(heading1, :column_widths => [30, 130,130,140,80,80,70,70], :cell_style => { :size => 9}) do
      row(0..1).height = 18
      row(0).columns(4).borders = [:top, :left, :bottom]
      row(0).columns(0..3).borders = [:top, :left, :right]
      row(0).columns(6..7).borders = [:top, :left, :right]
      row(1).columns(0..3).borders = [:left, :right]
      row(1).columns(6..7).borders = [:left, :right]
      row(0).columns(4).align = :right
      row(0).columns(5).borders = [:top, :right, :bottom]
      columns(3).align = :center
      self.row_colors = ["FEFEFE", "FFFFFF"]
      self.header = true
      self.width = 730
      header = true
    end
  end
  
  def make_heading2
     heading2= [[ '', 'Pendaftaran', "Modal", 'Mengikut Rekod',"Sebenar","Ya","Tidak","Ya", "Tidak","Modal",""]]
     table(heading2, :column_widths => [30, 130,130,70,70,40,40,40,40,70,70], :cell_style => { :size => 9}) do
       row(0).columns(0).borders = [:left, :right, :bottom]
       columns(0).align = :center
       row(0).columns(1..2).borders = [:left, :right, :bottom]
       row(0).columns(9..10).borders = [:left, :right, :bottom]
       self.header = true
       self.width = 730
       header = true
     end
  end 
  
  def data1
    counter = counter || 0
    boddy =[]
    @assets_located_at.hm.each do |asset_placement|
      boddy << ["#{counter += 1}", "#{asset_placement.assetcode}","#{asset_placement.name}", "#{asset_placement.try(:location).try(:name)}","","","","", "","",""] 
    end
    boddy
  end

  def make_data1
     table(data1, :column_widths => [30, 130,130,70,70,40,40,40,40,70,70], :cell_style => { :size => 9}) do
       row(0).columns(0).borders = [:left, :right, :bottom]
       columns(0).align = :center
       row(0).columns(1..2).borders = [:left, :right, :bottom]
       row(0).columns(9..10).borders = [:left, :right, :bottom]
       self.header = true
       self.width = 730
       header = true
     end
  end 
  
  def data2
    ccount=@assets_located_at.hm.count
    asset_placement=@assets_located_at.hm[ccount-1]
    boddy =[["#{ccount}", "#{asset_placement.assetcode}","#{asset_placement.name}", "#{asset_placement.try(:location).try(:name)}","","","","", "","",""]]
  end

  def make_data2
     table(data2, :column_widths => [30, 130,130,70,70,40,40,40,40,70,70], :cell_style => { :size => 9}) do
       row(0).columns(0).borders = [:left, :right, :bottom]
       columns(0).align = :center
       row(0).columns(1..2).borders = [:left, :right, :bottom]
       row(0).columns(9..10).borders = [:left, :right, :bottom]
       self.header = true
       self.width = 730
       header = true
     end
  end

  def make_empty_rows
    ccount=indx=@assets_located_at.hm.count
    data=[]
    if ccount < 5 #2 #for test use 2 - http://localhost:3003/campus/locations/1/kewpa10.pdf?locale=en
      while ccount < 5 #2
        ccount+=1
        data << ["","","","","","","","","","",""]
      end
    end
    if indx < 5 #2
      table(data, :column_widths => [30, 130,130,70,70,40,40,40,40,70,70], :cell_style => { :size => 10}) do
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
             ["(Jawatan)","","(Jawatan)","","Keadaan Harta Modal: Nyatakan samada sedang diguna atau tidak digunakan"],
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