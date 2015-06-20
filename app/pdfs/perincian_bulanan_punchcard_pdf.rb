class Perincian_bulanan_punchcardPdf < Prawn::Document
  def initialize(staff_attendances, monthly_list, unit_department, thumb_id, list_type, view)
    super({top_margin: 20, page_size: 'A4', page_layout: :portrait })
    @staff_attendances = staff_attendances
    @monthly_list=monthly_list
    @unit_department=unit_department
    @thumb_id=thumb_id
    @list_type=list_type
    @view = view
    @total_days=Time.days_in_month(monthly_list.month)

    font "Times-Roman"
    repeat :all do
      text "#{@monthly_list.beginning_of_month.strftime('%d-%m-%Y')} to #{@monthly_list.end_of_month.strftime('%d-%m-%Y')}", :align => :right, :size => 9
    end
    move_down 10
    text "Details of Attendance", :align => :center, :size => 12, :style => :bold
    move_down 10
    text "Department / Unit : #{@unit_department}", :size => 11
    text "#{Staff.where(thumb_id: @thumb_id).first.name.upcase}", :size => 11
    move_down 5
    attendance_list
    move_down 10
    repeat(lambda {|pg| pg > 1}) do
      draw_text "#{Staff.where(thumb_id: @thumb_id).first.name}", :at => bounds.bottom_left, :size =>9
    end
  end

  def attendance_list
    total_rows=@total_days 
    table(line_item_rows, :column_widths => [60, 35, 35, 95, 80, 80, 40, 90], :cell_style => { :size => 10,  :inline_format => :true}) do
      column(1..2).align=:center
      rows(0..total_rows).height=20
    end
  end
  
  def line_item_rows     
    counter = counter || 0    
    header=[["Date", "C/In", "C/Out","Shift", "Late", "Early", "Absent", "Exception"]]
    attendance_list = []
    day_count=1
    @staff_attendances.group_by{|x|x.logged_at.strftime('%d/%m/%Y')}.each do |ddate, sas|
        oneday=[]
        cnt_i=0
        cnt_o=0
	curr_date=sas[0].logged_at.strftime('%Y-%m-%d')
	shift_id=StaffShift.shift_id_in_use(curr_date,sas[0].thumb_id)
	
        sas.sort_by{|y|y.logged_at}.each_with_index do |sa, indx|
	   if indx==0 && (sa.log_type=='I' || sa.log_type=='i')
             oneday<< "#{sa.logged_at.strftime('%H:%M')}"
	     @lateness = sa.late_early(shift_id)
	     cnt_i+=1
	   end
	   if cnt_i==0 && indx==0
	     oneday << ""
	   end
	   if indx==sas.count-1 && (sa.log_type=='O' || sa.log_type=='o')
	     oneday<< "#{sa.logged_at.strftime('%H:%M') }"
	     @early = sa.late_early(shift_id)
	     cnt_o+=1
	   end
	   if cnt_o==0 && indx==sas.count-1
	     oneday << ""
	   end
	end 
	datte=ddate[0,2].to_i 
	if day_count < datte
	  day_count.upto(datte-1).each do |cc|
	    attendance_list << ["#{'0'+cc.to_s if cc < 10}#{cc if cc > 9}/#{ddate[3,2]}/#{ddate[6,4]}", "", "", "", "", "", "Y / N", "Cuti XXXXX"]
	    #if no leave recorded & no course attended, Cuti Gantian / Cuti Sakit / Cuti Kecemasan
	  end
	end
	day_count=datte+1
        if @list_type=="1"
          attendance_list << ["#{ddate}"]+ oneday  + ["#{StaffShift.find(shift_id).start_end}", "#{@lateness}", "#{@early}", "", ""] 
        end
        @sas=sas

    end
    datte2a=@sas.sort_by{|y|y.logged_at}.last.logged_at
    datte2b=datte2a.day     #ddate[0,2].to_i  #28
    if datte2b < @total_days
      datte2b.upto(@total_days).each do |dd|
        attendance_list << ["#{'0'+dd.to_s if dd < 10}#{dd if dd > 9}/#{datte2a.month}/#{datte2a.year}", "", "", "", "", "", "Y / N", "Cuti XXXXX"]
	#if no leave recorded & no course attended, Cuti Gantian / Cuti Sakit / Cuti Kecemasan
      end
    end
    
    header+attendance_list
  end

end