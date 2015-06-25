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
    @staffid=Staff.where(thumb_id: @thumb_id).first.id
    font "Times-Roman"
    move_down 10
    text "Details of Attendance (incl. Shift Exception)", :align => :center, :size => 13, :style => :bold
    move_down 10
    text "Department / Unit : #{@unit_department}", :size => 11
    text "#{Staff.where(thumb_id: @thumb_id).first.name.upcase}", :size => 11
    #text "#{@monthly_list.beginning_of_month.strftime('%d-%m-%Y')} to #{@monthly_list.end_of_month.strftime('%d-%m-%Y')}", :size => 11
    move_down 5
    if @staff_attendances.count > 0
      attendance_list
      move_down 10
      repeat(lambda {|pg| pg > 1}) do
        draw_text "#{Staff.where(thumb_id: @thumb_id).first.name} (#{@unit_department})", :at => bounds.bottom_left, :size =>9
      end
    else
      move_down 50
      text "No data exist!"
    end
  end

  def attendance_list
    total_rows=@total_days 
    table(line_item_rows, :column_widths => [70, 35, 35, 70, 35, 35, 40, 165, 40], :cell_style => { :size => 10,  :inline_format => :true}) do
      column(1..2).align=:center
      column(6).align=:center
      self.width = 525
      #rows(0..total_rows).height=20
    end
  end
  
  def line_item_rows     
    counter = counter || 0    
    header=[["Date", "C/In", "C/Out","Shift", "Late", "Early", "Absent", "Exception", "Week"]]
    attendance_list = []
    day_count=1
    @holidays=Holiday.all.pluck(:hdate)
    @staff_attendances.group_by{|x|x.logged_at.strftime('%d/%m/%Y')}.each do |ddate, sas|
        oneday=[]
        cnt_i=0
        cnt_o=0
        curr_date=sas[0].logged_at.strftime('%Y-%m-%d')
        shift_id=StaffShift.shift_id_in_use(curr_date,sas[0].thumb_id)

        #assign values(c/in, c/out, late, early columns) for days(one by one day) with logged records exist, but only capture the 1st occurance of IN & last occurance of OUT.
        sas.sort_by{|y|y.logged_at}.each_with_index do |sa, indx|
           if indx==0 && (sa.log_type=='I' || sa.log_type=='i')
             oneday<< "#{sa.logged_at.strftime('%H:%M')}"
             @lateness = sa.late_early(shift_id)
             @lateness2 = sa.number_format(@lateness)
             @approved_details=sa.approval_details
             cnt_i+=1
           end
           if cnt_i==0 && indx==0
             oneday << ""
            @lateness2=""
           end
           if indx==sas.count-1 && (sa.log_type=='O' || sa.log_type=='o')
             oneday<< "#{sa.logged_at.strftime('%H:%M') }"
             @early = sa.late_early(shift_id)
             @early2=sa.number_format(@early)
             @approved_details=sa.approval_details
             cnt_o+=1
           end
           if cnt_o==0 && indx==sas.count-1
             oneday << ""
             @early2=""
           end
        end 
        datte=ddate[0,2].to_i 
        mnth=ddate[3,2].to_i
        yyr=ddate[6,4].to_i

        #assign complete/all values for days without any logged records-before existing logged records
        if day_count < datte
          day_count.upto(datte-1).each do |cc|
            ccdate=Date.new(yyr,mnth,cc)
            ccdate_rev=ccdate.strftime('%d/%m/%Y')
            dyname=ccdate.strftime('%a')
            shift_id=StaffShift.shift_id_in_use(ccdate.strftime('%Y-%m-%d'), @staff_attendances[0].thumb_id)
            if ((dyname=="Sat" || dyname=="Sun") && ccdate.year < 2015) || ((dyname=="Sat" || dyname=="Fri") && ccdate.year > 2014)
              absent=""
              leave_taken=""
            else
              leave_taken=Leaveforstaff.leavetype_when_day_taken_off(@staffid, ccdate) #"Cuti YYYYYY"
              travel_outstation=TravelRequest.day_outstation(@staffid, ccdate)
              fingerprint_nothumbprint=Fingerprint.where(thumb_id: @thumb_id, fdate: ccdate)
              if leave_taken=="" && travel_outstation=="" && fingerprint_nothumbprint.count==0
                if @holidays.include?(ccdate)
                  absent=""
                else        
                  #note - if public holidays fall on Friday, the next Sunday will be replace as holiday (not saturday)
                  if (@holidays.include?(ccdate-1.day) && (dyname=="Mon" && ccdate.year < 2015) || (@holidays.include?(ccdate-2.day) && dyname=="Sun" && @next_date.year > 2014))
		    absent=""
		    replace_holiday="**"
	          else
                    absent="Y"
	          end
                end
                leave_or_travel_nothumb=""
              else
                if leave_taken==""  && fingerprint_nothumbprint.count==0 && travel_outstation!="" 
                  leave_or_travel_nothumb=travel_outstation
                elsif travel_outstation=="" && fingerprint_nothumbprint.count==0 && leave_taken!=""
                  leave_or_travel_nothumb=leave_taken
                elsif fingerprint_nothumbprint.count > 0 && leave_taken=="" && travel_outstation=="" 
                  leave_or_travel_nothumb=fingerprint_nothumbprint.first.exception_details
                end
                absent=""
              end 
            end
            attendance_list << ["#{ccdate_rev} #{'*' if @holidays.include?(ccdate)} #{replace_holiday if replace_holiday}", "", "", "#{StaffShift.find(shift_id).start_end2}", "", "", absent, leave_or_travel_nothumb, dyname]
            #when no leave recorded(Cuti Gantian / Cuti Sakit / Cuti Kecemasan) & no course/travel attended(travel request approved+claim created), absent=Y
          end
        end

        #combine (days with logged records exist) oneday (one by one day - c/in, c/out, late, early) with date & dayname + exception data (if any) 
        day_count=datte+1
        if @list_type=="1"
          dy=datte
          ddate_rev=Date.new(yyr,mnth,dy)
          dyname=ddate_rev.strftime('%a')
          #when logged at least ONCE/day - NO DATA for absent, but may also - taken the rest of the day off (eg. mc etc) or travel outstation or keluar pejabat pagi keluar pejabat petang - later after logged-in / before logged_out(morning not thumb)
          #this 'leave_or_travel' column will also help admin in triggering / ignore - when late or early exist
          leave_taken=Leaveforstaff.leavetype_when_day_taken_off(@staffid, ddate_rev) 
          travel_outstation=TravelRequest.day_outstation(@staffid, ddate_rev)
          fingerprint_nothumbprint=Fingerprint.where(thumb_id: @thumb_id, fdate: ddate_rev)
          if leave_taken=="" && travel_outstation=="" && fingerprint_nothumbprint.count==0
            leave_or_travel_nothumb_apprlatearly=""
          else
            #either take leave, outstation(movement), other keluar pej/movement etc-locally(keyed-in by late or early fingerprint), fingerprint(no fingerprint exist)
            if leave_taken==""  && fingerprint_nothumbprint.count==0 && travel_outstation!="" 
              leave_or_travel_nothumb_apprlatearly=travel_outstation
            elsif travel_outstation=="" && fingerprint_nothumbprint.count==0 && leave_taken!=""
              leave_or_travel_nothumb_apprlatearly=leave_taken
	      #at least 1 log record should not exist
            elsif fingerprint_nothumbprint.count > 0 && (@lateness2=="" || @early2=="") && leave_taken=="" && travel_outstation==""
              leave_or_travel_nothumb_apprlatearly=fingerprint_nothumbprint.first.exception_details
	    end
          end 
	  #if there's a day with 1 logged record(late early only) & 1 w/o logged record: user can have both Fingeprint(via late early) && Fingerprint(via No fingerprint)
	  #but gives priority to lateearly first(display Fingerprint), ignore Fingerprint(no fingerprint) if @approved_details EXIST
	  #otherwise display Fingerprint(no thumbprint) - best ever sample 21Jun2015, Maslinda
          attendance_list << ["#{ddate} #{'*' if @holidays.include?(ddate_rev)}"]+oneday+["#{StaffShift.find(shift_id).start_end2}", @lateness2, @early2, "", "OPPA #{@approved_details if @approved_details!=""} *ii #{leave_or_travel_nothumb_apprlatearly if @approved_details.nil?} ", dyname] 
        end
        @sas=sas

    end
    
    #assign complete/all values for days without any logged records-after existing logged records
    datte2a=@sas.sort_by{|y|y.logged_at}.last.logged_at
    datte2b=datte2a.day
    @next_date=datte2a
    if datte2b < @total_days
      (datte2b+1).upto(@total_days).each do |dd|
        @next_date+=1.day
        dyname=@next_date.strftime('%a')
        shift_id=StaffShift.shift_id_in_use(@next_date.strftime('%Y-%m-%d'), @staff_attendances[0].thumb_id)
        if ((dyname=="Sat" || dyname=="Sun") && @next_date.year < 2015) || ((dyname=="Sat" || dyname=="Fri") && @next_date.year > 2014)
          absent=""
          leave_or_travel=""
        else
          leave_taken=Leaveforstaff.leavetype_when_day_taken_off(@staffid, @next_date) #"Cuti YYYYYY"
          travel_outstation=TravelRequest.day_outstation(@staffid, @next_date)
          fingerprint_nothumbprint=Fingerprint.where(thumb_id: @thumb_id, fdate: @next_date.to_date)
          if leave_taken=="" && travel_outstation=="" && fingerprint_nothumbprint.count==0
            if @holidays.include?(@next_date.to_date)
              absent=""
            else   
	      #if @holidays.include?(@next_date.to_date-1.day) && ((dyname=="Mon" && @next_date.year < 2015)||(dyname=="Sun" && @next_date.year > 2014))
	      #note - if public holidays fall on Friday, the next Sunday will be replace as holiday (not saturday)
              if (@holidays.include?(@next_date.to_date-1.day) && (dyname=="Mon" && @next_date.year < 2015) || (@holidays.include?(@next_date.to_date-2.day) && dyname=="Sun" && @next_date.year > 2014))
		absent=""
		replace_holiday="**"
	      else
                absent="Y"
	      end
            end
            leave_or_travel_nothumb=""
          else
            if leave_taken==""  && fingerprint_nothumbprint.count==0 && travel_outstation!=""
              leave_or_travel=travel_outstation
            elsif travel_outstation=="" && fingerprint_nothumbprint.count==0 && leave_taken!="" 
              leave_or_travel_nothumb=leave_taken
	    elsif fingerprint_nothumbprint.count > 0 && leave_taken=="" && travel_outstation==""
	      leave_or_travel_nothumb=fingerprint_nothumbprint.first.exception_details
            end
            absent=""
          end   
        end
        attendance_list << ["#{@next_date.strftime('%d/%m/%Y')} #{'*' if @holidays.include?(@next_date.to_date)} #{replace_holiday if replace_holiday}", "", "", "#{StaffShift.find(shift_id).start_end2}", "", "", absent, leave_or_travel_nothumb, dyname]
        #when no leave recorded(Cuti Gantian / Cuti Sakit / Cuti Kecemasan) & no course/travel attended(travel request approved+claim created), absent=Y
      end
    end
    
    header+attendance_list
  end

end