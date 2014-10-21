class Laporan_mingguan_punchcardPdf < Prawn::Document
  def initialize(staff_attendance, view)
    super({top_margin: 50, page_size: 'A4', page_layout: :portrait })
    @staff_attendance = staff_attendance
    @view = view
    font "Times-Roman"
    text "Lampiran B 2", :align => :right, :size => 12, :style => :bold
    move_down 20
    text "Laporan Mingguan", :align => :center, :size => 12 
    move_down 20
    tajuk1
    #jawatan
    jumlah
   
  end
  
  def tajuk1
    data = [["",""],
    ["Nama Pegawai",""],
      ["",""],
      ["Tarikh", "hingga"]]
   
    table(data , :column_widths => [250,250], :cell_style => { :size => 9}) do
     row(0).column(0).borders = [:left, :top ]
     row(1).column(0).borders = [:left ]
     row(2).column(0).borders = [:left ]
     row(3).column(0).borders = [:left, :bottom ]
     row(0).column(1).borders = [ :right, :top ]
     row(1).column(1).borders = [ :right ]
     row(2).column(1).borders = [ :right ]
     row(3).column(1).borders = [ :right, :bottom ]


    end 
  end

  
  def jawatan
    
    table line_item_rows  do
      self.header = true
      self.width = 500
      self.cell_style = { size: 9 }
      header = true

    end
  end
  
  def line_item_rows
    
            

    counter = counter || 0
    header = [["Bil", "Nama Pegawai / Kakitangan Yang Datang Lambat/pulang Awal", "Jumlah Catitan Merah dalam tempoh seminggu","Warna Kad Pegawai / Kakitangan akhir minggu"]]
      header +
      @staff_attendance.map do |staff_attendance|
      ["#{counter += 1}", "", "", ""]
    end
  move_down 10
  end   
  
 def jumlah 
   move_down 20
  text "Jumlah Pegawai / Kakitangan", :align => :left, :size => 12
  move_down 5
  text "Jumlah Pegawai / Kakitangan", :align => :left, :size => 12
  text "Yang memegang kad hijau", :align => :left, :size => 12
  move_down 5
  text "Jumlah Pegawai / Kakitangan", :align => :left, :size => 12
  text "Yang memegang kad merah", :align => :left, :size => 12
end
end