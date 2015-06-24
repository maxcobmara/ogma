class Laporan_harian_punchcardPdf < Prawn::Document
  def initialize(staff_attendances, leader, daily_date, thumbids, view)
    super({top_margin: 50, page_size: 'A4', page_layout: :portrait })
    @staff_attendances = staff_attendances
    @view = view
    @leader = leader
    @daily_date = daily_date
    @thumbids=thumbids
    font "Times-Roman"
    text "Lampiran B 1", :align => :right, :size => 12, :style => :bold
    move_down 20
    text "Laporan Harian", :align => :center, :size => 12, :style => :bold
    move_down 20
    heading_details
    @y=("#{y}").to_i
    record
  end
  
  def heading_details
    data = [["Nama Pegawai : ","#{@leader.staff_name_with_position_grade if @leader!="not exist"}"],
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
    xx=@thumbids.count 
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
        row(xx+1).height = 500
      end
    end
  end
  
  def line_item_rows
    counter = counter || 0
    header = [[ "Bil", "Nama Pegawai / Kakitangan Yang Datang Lambat / Pulang Awal", "Sebab - Sebab ","Masa Yang Dicatatkan"]]
    
    attendance_list = []
    @staff_attendances.group_by{|x|x.thumb_id}.sort.reverse.each do |thumb, sas|
      shiftid = StaffShift.shift_id_in_use(@daily_date, sas.first.thumb_id)
      if sas.count==1
        exist_log=sas.first.log_type
        status="Tiada rekod masuk" if exist_log=="O" || exist_log=="o"
        status="Tiada rekod keluar" if exist_log=="I" || exist_log=="i"
        status2="Lambat datang" if sas.first.r_u_late(shiftid) == "flag" && sas.first.is_approved==false
        status2="Pulang awal" if sas.first.r_u_early(shiftid) == "flag" && sas.first.is_approved==false

        attendance_list << ["#{counter += 1}", "#{sas.first.attended.name}", "#{status} #{'& '+status2 if status2}" , "#{sas.first.logged_at.strftime('%H:%M') if status2}"]
      elsif sas.count==2
        status2a="Lambat datang" if sas.first.r_u_late(shiftid) == "flag" && sas.first.is_approved==false
        status2a="Pulang awal" if sas.first.r_u_early(shiftid) == "flag" && sas.first.is_approved==false
        status2b="Lambat datang" if sas.last.r_u_late(shiftid) == "flag"  && sas.last.is_approved==false
        status2b="Pulang awal" if sas.last.r_u_early(shiftid) == "flag" && sas.last.is_approved==false
	inbetween=" & " if status2a && status2b
        attendance_list << ["#{counter += 1}", "#{sas.first.attended.name}", "#{status2a} +#{inbetween if inbetween}+ #{status2b}" , "#{sas.first.logged_at.strftime('%H:%M')} / #{sas.last.logged_at.strftime('%H:%M')}"]
      end
    end
    
    without_both_logs=@thumbids-@staff_attendances.pluck(:thumb_id).uniq
    non_attend_list=[]
    without_both_logs.each do |thmb|
      non_attend_list <<  ["#{counter += 1}", "#{Staff.where(thumb_id: thmb).first.name}", "Tiada rekod masuk & keluar" , ""]
    end
    
    if @staff_attendances.count > 0
      header + attendance_list + non_attend_list+ [["", "", "", ""]]
    else
      header+non_attend_list+[["", "", "", ""]]
    end
  end

end