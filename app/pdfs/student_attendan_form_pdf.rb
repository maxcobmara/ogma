class Student_attendan_formPdf < Prawn::Document
  def initialize(student, view, programme_id)
    super({top_margin: 50, page_size: 'A4', page_layout: :portrait })
    @student = student
    @view = view
    @programme_id = programme_id
    font "Times-Roman"
    image "#{Rails.root}/app/assets/images/logo_kerajaan.png", :position => :center, :scale => 0.5
    move_down 15
    text "KEMENTERIAN KESIHATAN MALAYSIA", :align => :center, :size => 12, :style => :bold
    text "BORANG KEHADIRAN PELATIH", :align => :center, :size => 12, :style => :bold
    move_down 15
    tajuk
    list
    pengajar
   
  end
  
  def tajuk 
    data = [["","","","Tarikh"," ", " ", " "],
             ["Bil", "No Matrik", " Nama Pelatih", "Masa", "", "", ""]]
             
      table(data, :column_widths => [40, 80, 100 ,50 , 90, 90, 90], :cell_style => { :size => 10}) do
      row(0).background_color = 'FFE34D'
      row(1).background_color = 'FFE34D'
      self.width = 540
      row(0).column(0).borders = [ :top, :left, :right]
      row(1).column(0).borders = [ :left, :right, :bottom]
      row(0).column(1).borders = [ :top, :left, :right]
      row(1).column(1).borders = [ :left, :right, :bottom]
      row(0).column(2).borders = [ :top, :left, :right]
      row(1).column(2).borders = [ :left, :right, :bottom]
    end
  end
  
  
  def list
    
    table(line_item_rows, :column_widths => [40, 80, 150 , 90, 90, 90], :cell_style => { :size => 10}) do
     self.width = 540
    end
  end
  
  def line_item_rows
    counter = counter || 0
      @student.map do |student|
      ["#{counter += 1}", " ", " ", " ", " ", " "]
    end
  end
  
  def pengajar
    data = [[" ", " ", "Nama dan Tandatangan Pengajar ", " ", " ", " "]]
    
    table(data, :column_widths => [40, 80, 150 , 90, 90, 90], :cell_style => { :size => 10}) do
     self.width = 540
    end
    move_down 15
    text "Nota :", :align => :left, :size => 11, :style => :bold
    text "Setiap pelatih perlu menandatangani borang kehadiran", :align => :left, :size => 11, :style => :bold
  end
end