class Laporan_mingguan_punchcardPdf < Prawn::Document
  def initialize(staff_attendances,leader, weekly_date, notapproved_lateearly, thumb_ids, college, view)
    super({top_margin: 50, left_margin: 50, page_size: 'A4', page_layout: :portrait })
    @staff_attendances = staff_attendances
    @leader = leader
    @view = view
    @notapproved_lateearly = notapproved_lateearly
    @total_staff=thumb_ids.count
    @college=college
    weekly_start=weekly_date.beginning_of_week
    weekly_end=weekly_date.end_of_week
    if weekly_date.year < 2015
      @wstart=weekly_start
      @wend=weekly_end
    elsif weekly_date.year > 2014 && @college.code=='kskbjb'
      @wstart=(weekly_start-1.days).to_time.beginning_of_day
      @wend=(weekly_start+3.days).to_time.end_of_day
    end
    font "Helvetica"
    text "Lampiran B 2", :align => :right, :size => 11, :style => :bold
    move_down 20
    text "Laporan Mingguan", :align => :center, :size => 11, :style => :bold
    move_down 20
    if @leader=='update_db'
      text "<color rgb='#EC0C16'>#{I18n.t('attendance.min_grade_post_required')}</color>", :inline_format => true, :align => :center, :size => 11   
    else
      heading_details
      @y=("#{y}").to_i
      record
      jumlah
    end
  end
  
  def heading_details
    data = [["Nama Pegawai : ","#{@leader.staff_name_with_position_grade}"],
      ["Tarikh : ", "#{@wstart.try(:strftime, '%d-%m-%Y')} hingga #{@wend.try(:strftime, '%d-%m-%Y')}"]]
   
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
    xx=@staff_attendances.group_by{|x|x.thumb_id}.count
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
        row(1).height = 400
      end
    end
  end
  
  def line_item_rows
    ###########################################################################
    @green_count = 0
    @red_count = 0
    @color_in_columns=[]
    @notapproved_lateearly.each do |thumb_id, items|
       
       #1-start-CURRENT DATA-To check colour status for selected week
       @start_date = @wstart.to_s #@weekly_date.beginning_of_week.to_s
       @next_date = @wend.to_s #@weekly_date.end_of_week.to_s
       @count_non_approved = StaffAttendance.count_non_approved(thumb_id,@start_date,@next_date).count
       #1-end-CURRENT DATA-To check colour status for selected week

       #2-PREVIOUS DATA-To check colour status between - beginning of (ALL) PREVIOUS month - until 1 day before selected week/month
       #previous status from staffs table if exist?
       # @previous_status_staff = Staff.find(:first, :conditions=> ['thumb_id=?',thumb_id]).att_colour
       # @previous_colour_staff = (StaffAttendance::ATT_STATUS.find_all{|disp, value| value == @previous_status_staff}).map {|disp, value| disp}

       #start-previous status...data retrieved from staff attendance table all existing data
       @previous_status_for_SA = 1      #set default : previous status as 1; ie:yellow 
       @previous_colour = "Yellow"        #will be use if no changes on previous status
       @all_dates = StaffAttendance.where('thumb_id=? and logged_at>=? and logged_at<?',thumb_id,"2012-05-07",@wstart).order(logged_at: :asc) .map(&:logged_at)
       @previous_status_SA = StaffAttendance.set_colour_status(@all_dates,thumb_id, @previous_status_for_SA)
       #end-previous status...data retrieved from staff attendance table all existing data

       #to choose either one : attendance colour status (1)from staffs table-or (2)compare values from staff_attendances table
       @previous_status = @previous_status_SA
       @previous_colour = (StaffAttendance::ATT_STATUS.find_all{|disp, value| value == @previous_status}).map {|disp, value| disp}[0]
       #2-PREVIOUS DATA-To check colour status between - beginning of the (ALL) PREVIOUS month - until 1 day before selected week/month

       #3a-start-WEEKLY REPORT-check previous status & ASSIGN LATEST STATUS-for selected week
       if @previous_status == 1            #!--if yellow-
         if @count_non_approved>= 3   #!--change to 1 for checking, original value:3*** re-update after UAT completed on 25th June 2015
           @latest_colour = "Green"        #!--previous:yellow & >= 3 red marking, change status into GREEN
         else
           @latest_colour = @previous_colour   #!--current:yellow & < 3 red marking, NO CHANGES
         end 
       elsif @previous_status == 2       #!--if green-
         if @count_non_approved >= 2  #!--change to 1 for checking, original value:2*** re-update after UAT completed on 25th June 2015
           @latest_colour = "Red"            #!--previous:green & >=2 red marking, [GREEN->RED]
         elsif @count_non_approved == 1
           @latest_colour = @previous_colour #!--current:green & = 1 red marking, NO CHANGES
         elsif @count_non_approved == 0
           @latest_colour = "Yellow"
         end 
       elsif @previous_status == 3
         if @next_date.to_date-1.day == @dadidu.to_date.end_of_month   #!--IF selected week-END OF THE MONTH
           if @count_non_approved == 0 
             @latest_colour = "Green"      #!--previous(MONTH+@dadidu-1day):red, NO red marking [RED->GREEN]
           else 
             @latest_colour = @previous_colour
           end
         else    #--IF selected week-NOT END OF THE MONTH
           @latest_colour = @previous_colour #!--although there's NO red marking, NO CHANGES
         end 
       end 
       #!--weekly--VIEW DLM COLUMN- SEBAB DLM LOOP
       if @latest_colour=="Green"
         @latest_colour2="Hijau" 
       elsif @latest_colour=="Red"
          @latest_colour2="Merah"
       elsif @latest_colour=="Yellow"
         @latest_colour2="Kuning"
       end
       @color_in_columns << @latest_colour2
       #!--3a-end-WEEKLY REPORT-check previous status & ASSIGN LATEST STATUS-for selected week-->

       if @latest_colour == "Green" || @previous_status == 2
         @green_count+=1
       elsif @latest_colour == "Red" || @previous_status == 3 
         @red_count+=1 
       end
       ######
    end
    ###########################################################################
     
    counter = counter || 0
    cnt = -1
    header = [[ "Bil", "Nama Pegawai / Kakitangan Yang Datang Lambat / Pulang Awal",  "Jumlah Catitan Merah dalam tempoh seminggu","Warna Kad Pegawai / Kakitangan akhir minggu"]]
        
    attendance_list = 
      @staff_attendances.group_by{|x|x.thumb_id}.map do |attended, sa|
      ["#{counter += 1}", "#{Staff.where(thumb_id: attended).first.name}", "#{StaffAttendance.count_non_approved(attended, @wstart, @wend).count}" , " #{@color_in_columns[cnt+=1]}"]
    end
    
    if @staff_attendances.count > 0
      header + attendance_list + [["", "", "", ""]]
    else
      header << ["", "", "", ""]
    end
  end
  
  def jumlah 
    move_down 20
    text "Jumlah Pegawai / Kakitangan                                       #{@total_staff}", :align => :left, :size => 11
    move_down 5
    text "Jumlah Pegawai / Kakitangan                                       #{@green_count}", :align => :left, :size => 11
    text "Yang memegang kad hijau", :align => :left, :size => 11
    move_down 5
    text "Jumlah Pegawai / Kakitangan                                       #{@red_count}", :align => :left, :size => 11
    text "Yang memegang kad merah", :align => :left, :size => 11
  end
end