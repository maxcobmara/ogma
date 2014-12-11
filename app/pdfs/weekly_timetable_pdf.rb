class Weekly_timetablePdf < Prawn::Document
  def initialize(weeklytimetable, view)
    super({top_margin: 50, page_size: 'A4', page_layout: :landscape })
    @weeklytimetable = weeklytimetable
    @view = view
 

    font "Times-Roman"
    text "BPL.KKM.PK(T)", :align => :right, :size => 12
    image "#{Rails.root}/app/assets/images/logo_kerajaan.png", :position => :center, :scale => 0.5
    move_down 10
    text "KEMENTERIAN KESIHATAN MALAYSIA", :align => :center, :size => 12
    text "JADUAL WAKTU MINGGUAN", :align => :center, :size => 12
    move_down 10
    text "INSTITUSI :", :align => :left, :size => 12
    text "KUMPULAN PELATIH :", :align => :left, :size => 12
    text "TARIKH : ..... HINGGA : .......... SEMESTER : ....... MINGGU : .......", :align => :left, :size => 12
    move_down 5
    timetable


  end
  
  def timetable
    
    data = [["MASA","7.30am - 9.30 am -", "9.30am"," 10.00am - 12.00pm","12.00pm - 1.00","1.00pm - ","2.00pm - 4.00pm","4.00pm - 5.00pm"],
            ["HARI"," ", "10.00am","  "," "," 2.00pm"," "," "],
           ["ISNIN"," ", "","  "," ",""," "," "],
           ["SELASA"," ", "","  "," ",""," "," "],
           ["RABU"," ", "REHAT","  "," ","REHAT"," "," "],
           ["KHAMIS"," ", "","  "," ",""," "," "]]
    
           table(data, :column_widths => [70, 120, 50 ,120 , 120, 50, 120, 120], :cell_style => { :size => 10}) do
             row(0).column(0).borders = [ :top, :left, :right]
             row(0).column(1).borders = [ :top, :left, :right]
             row(0).column(2).borders = [ :top, :left, :right]
             row(0).column(3).borders = [ :top, :left, :right]
             row(0).column(4).borders = [ :top, :left, :right]
             row(0).column(5).borders = [ :top, :left, :right]
             row(0).column(6).borders = [ :top, :left, :right]
             row(0).column(7).borders = [ :top, :left, :right]
             row(1).column(0).borders = [ :left, :right]
             row(1).column(1).borders = [ :left, :right]
             row(1).column(2).borders = [ :left, :right, :bottom]
             row(1).column(3).borders = [ :left, :right]
             row(1).column(4).borders = [ :left, :right]
             row(1).column(5).borders = [ :left, :right, :bottom]
             row(1).column(6).borders = [ :left, :right]
             row(1).column(7).borders = [ :left, :right]
             row(2).column(2).borders = [ :left, :right]
             row(2).column(5).borders = [ :left, :right]
             row(3).column(2).borders = [ :left, :right]
             row(3).column(5).borders = [ :left, :right]
             row(4).column(2).borders = [ :left, :right]
             row(4).column(5).borders = [ :left, :right]
             row(5).column(2).borders = [ :left, :right]
             row(5).column(5).borders = [ :left, :right]
             row(0).column(0).align = :right
             row(0).background_color = 'FFE34D'
             row(1).background_color = 'FFE34D'
             self.width = 770
           end
           
           data1 = [[" "," ", "", "10.00am - 12.15pm","12.15pm - 2.45pm ","2.45pm - 4.00pm"],
                  ["JUMAAT"," ", " ","  "," REHAT ",""]]
    
                  table(data1, :column_widths => [70, 120, 50 ,200 , 130, 200], :cell_style => { :size => 10}) do
                    self.width = 770
                    row(0).column(3).background_color = 'FFE34D'
                    row(0).column(4).background_color = 'FFE34D'
                    row(0).column(5).background_color = 'FFE34D'
                    row(0).column(0).borders = [ :top, :left, :right]
                    row(0).column(1).borders = [ :top, :left, :right]
                    row(0).column(2).borders = [ :left, :right]
                    row(1).column(0).borders = [ :bottom, :left, :right]
                    row(1).column(1).borders = [ :bottom, :left, :right]
                    row(1).column(2).borders = [ :bottom, :left, :right]
                  end
              move_down 20    
           text "Disediakan Oleh :                                                          Disemak Oleh  :", :align => :left, :size => 12
             move_down 20   
           text "--------------------                                                              ---------------------", :align => :left, :size => 12 
            text "Nama                                                                             Nama", :align => :left, :size => 12    
            text "PENGAJAR PENYELARAS                                     TIMBALAN PENGARAH AKADEMIK/ KETUA PROGRAM", :align => :left, :size => 12          
  end
  


  
  
end

  
