class Laporan_harian_punchcardPdf < Prawn::Document
  def initialize(staff_attendances, leader, daily_date, view)
    super({top_margin: 50, page_size: 'A4', page_layout: :portrait })
    @staff_attendances = staff_attendances
    @view = view
    @leader = leader
    @daily_date = daily_date
    font "Times-Roman"
    text "Lampiran B 1", :align => :right, :size => 12, :style => :bold
    move_down 20
    text "Laporan Harian", :align => :center, :size => 12, :style => :bold
    move_down 20
    heading_details
    #text "#{y}"
    @y=("#{y}").to_i
    record
    #text "#{y}"
   
  end
  
  def heading_details
    data = [["Nama Pegawai : ","#{@leader.staff_name_with_position_grade}"],
      ["Tarikh : ", "#{@daily_date.try(:strftime, '%d-%m-%Y')}"]]
   
    table(data , :column_widths => [150,350], :cell_style => { :size => 10}) do
     row(0).column(0).borders = [:left, :top ]
     row(1).column(0).borders = [:left ]
     row(0).column(1).borders = [ :right, :top ]
     row(1).column(1).borders = [ :right ]
     row(0..1).font_style = :bold
     row(0..1).height = 30
     row(0..1).valign = :center
    end 
  end

  def record
    xx=@staff_attendances.count
    yoy=@y
    table(line_item_rows, :column_widths => [40, 230, 140 ,90], :cell_style => { :size => 10,  :inline_format => :true}) do
      row(0).font_style = :bold
      columns(0..3).align = :center
      self.header = true
      self.width = 500
      header = true
      if xx > 0
        row(1..xx).borders = [:left, :right]
	row(xx+1).height = 1065-yoy
	row(xx+1).borders = [:left, :right, :bottom]
      else
        row(1).height = 500
      end
    end
  end
  
  def line_item_rows
#     @circulation_details=[]
#     @documents.each do |document|
#       circulation_details=""
#       document.circulations.each_with_index do |circulation, ind|
#         circulation_details += "(#{ind+=1}) #{circulation.staff.name} - #{circulation.action_taken}<br>"
#       end
#       @circulation_details << circulation_details
#     end
    counter = counter || 0
    header = [[ "Bil", "Nama Pegawai / Kakitangan Yang Datang Lambat / Pulang Awal", "Sebab - Sebab ","Masa Yang Dicatatkan"]]
    
    attendance_list = 
      @staff_attendances.sort_by{|x|x.thumb_id}.map do |sa|
      ["#{counter += 1}", "#{sa.attended.name}", "#{sa.reason}" , "#{sa.logged_at.strftime('%H:%M')}",]
    end
    
    if @staff_attendances.count > 0
      header + attendance_list + [["", "", "", ""]]
    else
      header << ["", "", "", ""]
    end
    
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