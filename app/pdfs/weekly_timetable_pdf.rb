class Weekly_timetablePdf < Prawn::Document
  def initialize(weeklytimetable, view, college)
    super({top_margin: 20, page_size: 'A4', page_layout: :landscape })
    @weeklytimetable = weeklytimetable
    @view = view
    
    @count1=@weeklytimetable.timetable_monthurs.timetable_periods.count
    @count2=@weeklytimetable.timetable_friday.timetable_periods.count 
    @break_format1 = @weeklytimetable.timetable_monthurs.timetable_periods.order(sequence: :asc).pluck(:is_break)
    @break_format2 = @weeklytimetable.timetable_friday.timetable_periods.order(sequence: :asc).pluck(:is_break)
    @daycount=4
    @weekdays_end = @weeklytimetable.startdate.to_date+4.days
    @daycount2 = (@weeklytimetable.enddate.to_date - @weekdays_end).to_i 
    @college=college
    
    font "Times-Roman"
    if college.code=="kskbjb"
      text "BPL.KKM.PK(T)", :align => :right, :size => 8
    else
      move_down 5
    end
    image "#{Rails.root}/app/assets/images/logo_kerajaan.png", :position => :center, :scale => 0.5
    move_down 3
    if college.code=="kskbjb"
      text "KEMENTERIAN KESIHATAN MALAYSIA", :align => :center, :size => 9
    else
      move_down 5
    end
    text "JADUAL WAKTU MINGGUAN", :align => :center, :size => 9
    move_down 3
    text "INSTITUSI : #{college.name.upcase}", :align => :left, :size => 9
    text "KUMPULAN PELATIH : #{@weeklytimetable.try(:schedule_intake).try(:group_with_intake_name)}", :align => :left, :size => 9
    table_date_semester_week
    table_schedule_sun_wed
    table_schedule_thurs
    if @daycount2 > 0
      start_new_page
      ##same page header
      if college.code=="kskbjb"
        text "BPL.KKM.PK(T)", :align => :right, :size => 8
      else
        move_down 5
      end
      image "#{Rails.root}/app/assets/images/logo_kerajaan.png", :position => :center, :scale => 0.5
      move_down 3
      if college.code=="kskbjb"
        text "KEMENTERIAN KESIHATAN MALAYSIA", :align => :center, :size => 9
      else
        move_down 5
      end
      text "JADUAL WAKTU MINGGUAN", :align => :center, :size => 9
      move_down 3
      text "INSTITUSI : #{college.name.upcase}", :align => :left, :size => 9
      text "KUMPULAN PELATIH : #{@weeklytimetable.try(:schedule_intake).try(:group_with_intake_name)}", :align => :left, :size => 9
      table_date_semester_week
      ##same page header
      table_weekend 
    end
    table_signatory
  end
   
  def table_date_semester_week
    data = [[ "TARIKH : #{@weeklytimetable.startdate.try(:strftime, '%d/%m/%Y') } HINGGA : #{@weeklytimetable.enddate.try(:strftime, '%d/%m/%Y')}",
                "SEMESTER : #{ @weeklytimetable.academic_semester.try(:semester).nil? ? "" : @weeklytimetable.academic_semester.try(:semester).split("/").join(" / ")}",
                "MINGGU : #{@weeklytimetable.week.to_s+" / "+@weeklytimetable.academic_semester.try(:total_week).to_s}"]]
    table(data, :column_widths => [250,250,250], :cell_style => { :size => 9}) do
      row(0).borders = []
      row(0).height = 18
      self.width = 750
    end 
  end
  
  def table_schedule_sun_wed
    #size & columns count
    all_col = [55]
    0.upto(@count1) do |no|
      #all_col << 80 #remove below conditions & use JUST this line if error occurs
      if (no==1) || (no==4) || (no==7)
        all_col << 45
      else
        if @count1 > 7
          #all_col << 80 #remove above conditions & use JUST this line if error occurs
	  all_col << 95 ###9July2015
        else
          all_col << 122
        end
      end
    end
    
    header_col = [""]
    allrows_content=[]  
    @weeklytimetable.timetable_monthurs.timetable_periods.order(sequence: :asc).in_groups_of(@count1, false).map do |row_things|
      #header (Sun - Wed)
      for periods in row_things
        header_col << "#{periods.sequence} <br> #{periods.timing}"
      end
      #rows & columns of data
      1.upto(@daycount) do |row|
        onerow_content=["#{I18n.t(:'date.day_names')[(@weeklytimetable.startdate+(row-1)).wday]}<br> #{(@weeklytimetable.startdate+(row-1)).try(:strftime, "%d/%m/%Y")}"]
        1.upto(@count1) do |col|
          #onerow_content << "row = #{row}, col = #{col}"
	  #---------------------
	  if @break_format1[col-1]==true && row==1 
	    #break part
	    onerow_content << {content: "REHAT", rowspan: 4}
	  elsif @break_format1[col-1]==true && row!=1
	    #do-not-remove : should not have any field or value
	  elsif @break_format1[col-1]==false
	    gg=""
            @weeklytimetable.weeklytimetable_details.each do |xx|
	      if xx.day2 == row && xx.time_slot2 == col 
	        #render 'subtab_class_details', {:xx=>xx}
                gg+="#{xx.weeklytimetable_topic.parent.parent.subject_abbreviation.blank? ? "-" :  xx.weeklytimetable_topic.parent.parent.subject_abbreviation.upcase  if xx.weeklytimetable_topic.ancestry_depth == 4} #{ '<br>'+xx.weeklytimetable_topic.parent.name if xx.weeklytimetable_topic.ancestry_depth == 4}  #{xx.weeklytimetable_topic.parent.subject_abbreviation.blank? ? "-" :  xx.weeklytimetable_topic.parent.subject_abbreviation.upcase if xx.weeklytimetable_topic.ancestry_depth != 4} #{'<br>'+xx.weeklytimetable_topic.name  if xx.weeklytimetable_topic.ancestry_depth != 4} #{xx.location_desc}#{"(K)" if xx.lecture_method==1} #{"(T)" if xx.lecture_method==2}#{"(A)" if xx.lecture_method==3} #{xx.weeklytimetable_lecturer.name}"
	      end 
	    end
	    onerow_content << gg
          end
	  #---------------------
        end
        allrows_content << onerow_content
      end
    end
    
    #data = [header_col]+[abab]+[abab]+[abab]
    #data = [header_col, abab, abab, abab]
    #data = [header_col]+[abab, abab, abab]
    data = [header_col]+allrows_content
    table(data, :column_widths => all_col, :cell_style => { :size => 9, :align=> :center,  :inline_format => true}) do
      #self.width = all_col.sum-80 #use this if below error
      if header_col.count > 8
        #self.width = all_col.sum-80#750
        self.width = all_col.sum-95 ###9July2015
      else
        self.width = all_col.sum-45#755
      end
      row(0).background_color = 'ABA9A9'  
      cells[1,2].valign = :center
      cells[1,5].valign = :center
      if header_col.count > 8
        cells[1,8].valign = :center
      end
    end 
  end
  
  def table_schedule_thurs
    @break_tospan=4
    #refer to screen capture -- PDF limitation-schedule.png - temp solution- as below:
#     if @count1==9 && @count2==7 #excluding 1st column 
#       @classes_tospan=[5]
#     else
#       @classes_tospan=[5,7]
#     end
    ###
    #Lunch break for Thursday is similar to Sun-Wed, except : working hours is less than Sun-Wed 
    if @weekdays_end.strftime('%A')=="Friday"
      @break_tospan=4
      #classes_tospan=[5,7]
      if @count1==9 && @count2==7 #excluding 1st column 
        @classes_tospan=[5]
      else
        @classes_tospan=[5,7]
      end
    else
      #Thursday or any other day
      @break_tospan=0
      @classes_tospan=[]
    end
    ###
    
    @span_count=2            
    header_col = [""]
    colfriday=1
    allrows_content=["#{I18n.t(:'date.day_names')[@weekdays_end.wday]}#{'<br>'+@weekdays_end.try(:strftime, "%d/%m/%Y")}"]  
    
    #size & columns count
    all_col = [55]
    0.upto(@count1) do |no|
       if (no==1) || (no==4) || (no==7)
        all_col << 45
      else
        if @count1 > 7
          #all_col << 80 #remove above conditions & use JUST this line if error occurs
          all_col << 95 ###9July2015
        else
          all_col << 122
        end
      end
    end
    
    ##Header+Thursday Content row - start
    @weeklytimetable.timetable_friday.timetable_periods.order(sequence: :asc).in_groups_of(@count2, false).map do |row_things|  
      #Header (Thursday)
      for periods in row_things
        if colfriday == @break_tospan || @classes_tospan.include?(colfriday)==true
          header_col << {content: "#{periods.sequence} <br> #{periods.timing}", colspan: @span_count}
        else
          header_col << "#{periods.sequence} <br> #{periods.timing}"
        end
        colfriday+=1
      end
      
      #Content for THURSDAY-(start) - COMPULSORY long break on the fouth time slot-START
      1.upto(@count2) do |col2|
        if @break_format2[col2-1]==true 
          if col2 == @break_tospan
            allrows_content<< {content: "REHAT", colspan: @span_count}
          else
            allrows_content<< "REHAT"
          end       
 
        #NON-BREAK columns----start
        elsif @break_format2[col2-1]==false 
          if @classes_tospan.include?(col2)
            gg=""
            @weeklytimetable.weeklytimetable_details.each do |xx|
              if xx.is_friday == true && xx.time_slot == col2 #@count1+col2 
                #= render 'subtab_class_details', {:xx=>xx}   
                gg+="#{xx.weeklytimetable_topic.parent.parent.subject_abbreviation.blank? ? "-" :  xx.weeklytimetable_topic.parent.parent.subject_abbreviation.upcase  if xx.weeklytimetable_topic.ancestry_depth == 4} #{ '<br>'+xx.weeklytimetable_topic.parent.name if xx.weeklytimetable_topic.ancestry_depth == 4}  #{xx.weeklytimetable_topic.parent.subject_abbreviation.blank? ? "-" :  xx.weeklytimetable_topic.parent.subject_abbreviation.upcase if xx.weeklytimetable_topic.ancestry_depth != 4} #{'<br>'+xx.weeklytimetable_topic.name  if xx.weeklytimetable_topic.ancestry_depth != 4} #{ xx.location_desc}#{"(K)" if xx.lecture_method==1} #{"(T)" if xx.lecture_method==2}#{"(A)" if xx.lecture_method==3} #{'<br>'+xx.weeklytimetable_lecturer.name}"
              end
            end
            allrows_content<< {content: gg, colspan: @span_count}
          else
            hh=""
            @weeklytimetable.weeklytimetable_details.each do |xx|
              if xx.is_friday == true && xx.time_slot == col2 #@count1+col2
                #=render 'subtab_class_details', {:xx=>xx}
                hh+="#{xx.weeklytimetable_topic.parent.parent.subject_abbreviation.blank? ? "-" :  xx.weeklytimetable_topic.parent.parent.subject_abbreviation.upcase  if xx.weeklytimetable_topic.ancestry_depth == 4} #{ '<br>'+xx.weeklytimetable_topic.parent.name if xx.weeklytimetable_topic.ancestry_depth == 4}  #{xx.weeklytimetable_topic.parent.subject_abbreviation.blank? ? "-" :  xx.weeklytimetable_topic.parent.subject_abbreviation.upcase if xx.weeklytimetable_topic.ancestry_depth != 4} #{'<br>'+xx.weeklytimetable_topic.name  if xx.weeklytimetable_topic.ancestry_depth != 4} #{ xx.location_desc}#{"(K)" if xx.lecture_method==1} #{"(T)" if xx.lecture_method==2}#{"(A)" if xx.lecture_method==3} #{'<br>'+xx.weeklytimetable_lecturer.name}"
              end
            end
            allrows_content<< hh
          end
        end 
        #NON-BREAK columns----end 
      end
      #Content for THURSDAY-(start) - COMPULSORY long break on the fouth time slot-END
    end
    ##Header+Thursday Content row - end
 
    data = [header_col]+[allrows_content]
    table(data, :column_widths => all_col, :cell_style => { :size => 9, :align=> :center,  :inline_format => true}) do
      #self.width = all_col.sum-80 #use this if below error #750 #705
      if @count1==9 && @count2==7
        self.width = 705
      elsif @count1==10 && @count2==7
        self.width = 750
      #else
        #self.width = 750
      end 
      row(0).background_color = 'ABA9A9'  
      cells[1,2].valign = :center
      cells[1,4].valign = :center
      if header_col.count > 8
        cells[1,8].valign = :center
      end
    end 
  end
 
  def table_weekend
    header_col = [""]
    allrows_content=[] 
    
    #size & columns count
    all_col = [55]
    0.upto(@count1) do |no|
       if (no==1) || (no==4) || (no==7)
        all_col << 45
      else
        if @count1 > 7
          #all_col << 80 #remove above conditions & use JUST this line if error occurs
          all_col << 95 ###9July2015
        else
          all_col << 122
        end
      end
    end  
    
    ##Header : Weekend+WeekendContent row - start
    if @daycount2 > 0
      @weeklytimetable.timetable_monthurs.timetable_periods.order(sequence: :asc).in_groups_of(@count1, false).map do |row_things|  
        #Header (Weekend)
        for periods in row_things
          header_col << "#{periods.sequence} <br> #{periods.timing}"
        end
        #Day & date(column) : (ADDITIONAL - Weekends classes) - row starts after timeslot header
        1.upto(@daycount2) do |row2|
          onerow_content=["#{I18n.t(:'date.day_names')[(@weekdays_end+row2).wday]}<br> #{(@weekdays_end+row2).try(:strftime, "%d/%m/%Y")}"]
          weekend_dayname=(@weekdays_end+row2).try(:strftime, "%A")

          #Content - (ADDITIONAL - Weekends classes)
          #span BREAK fields & display CLASSES fields accordingly - col (column) starts after day/date column
          1.upto(@count1) do |col2|
            if @break_format1[col2-1]==true && row2==1
              onerow_content << {content: "REHAT", rowspan: @daycount2}
            elsif @break_format1[col2-1]==true && row2!=1
              #do-not-remove : should not have any field or value
            elsif @break_format1[col2-1]==false
              gg=""
   
              #1-DECLARE BREAK for 4th slot(12:00-13:00) for Weekend class (Friday only) for Week starting on Sunday
              if weekend_dayname=="Friday" && col2==4
                gg+="REHAT"
              else
                #1-display Sat slot accordingly for Week starting on Sunday 
                #2-OR display Weekends slot (Sat & Sun) for week starting on Monday    
                @weeklytimetable.weeklytimetable_details.each do |xx|
                  if xx.day2 == row2+@daycount+1 && xx.time_slot2 == col2 
                    gg+="#{xx.weeklytimetable_topic.parent.parent.subject_abbreviation.blank? ? "-" :  xx.weeklytimetable_topic.parent.parent.subject_abbreviation.upcase  if xx.weeklytimetable_topic.ancestry_depth == 4} #{ '<br>'+xx.weeklytimetable_topic.parent.name if xx.weeklytimetable_topic.ancestry_depth == 4}  #{xx.weeklytimetable_topic.parent.subject_abbreviation.blank? ? "-" :  xx.weeklytimetable_topic.parent.subject_abbreviation.upcase if xx.weeklytimetable_topic.ancestry_depth != 4} #{'<br>'+xx.weeklytimetable_topic.name  if xx.weeklytimetable_topic.ancestry_depth != 4}#{"(K)" if xx.lecture_method==1} #{xx.location_desc}#{"(T)" if xx.lecture_method==2}#{"(A)" if xx.lecture_method==3} #{'<br>'+xx.weeklytimetable_lecturer.name}"
                  end
                end
              end #end for weekend_dayname friday
              onerow_content<< gg
            end
          end

          allrows_content << onerow_content
        end
      end
    end ### end for (if daycount2 > 0)
    ##Header : Weekend+WeekendContent row - end
    
    data = [header_col]+allrows_content
    table(data, :column_widths => all_col, :cell_style => { :size => 9, :align=> :center,  :inline_format => true}) do
      #self.width = all_col.sum-80 #use this if below error
      if header_col.count > 8
        #self.width = all_col.sum-80#750
        self.width = all_col.sum-95 ###9July2015
      else
        self.width = all_col.sum-45#755
      end
      row(0).background_color = 'ABA9A9'  
      cells[1,2].valign = :center
      cells[1,5].valign = :center
       if header_col.count > 8
        cells[1,8].valign = :center
      end
    end 
    
  end
  
  def table_signatory
    if @college.code=="amsas"
      approver="Nama: #{@weeklytimetable.endorsed_by? ? @weeklytimetable.schedule_approver.staff_with_rank : "-"}"
    else
      approver="Nama: #{@weeklytimetable.endorsed_by? ? @weeklytimetable.schedule_approver.name : "-"}"
    end
    data1 = [["Disediakan Oleh :","Disemak Oleh :" ],
                  ["#{'.'*90}","#{'.'*90}"],
                  ["Nama: #{@college.code=="amsas" ? @weeklytimetable.schedule_creator.staff_with_rank : @weeklytimetable.schedule_creator.name}", approver],
                  ["Pengajar Penyelaras","#{@weeklytimetable.endorsed_by? ? @weeklytimetable.schedule_approver.positions.first.try(:name) : "-"}"],
                  ["Pelatih Ambilan #{@weeklytimetable.try(:schedule_intake).try(:name)}", @college.code.upcase]]
    table(data1, :column_widths => [350], :cell_style => { :size => 10}) do
      columns(0..1).borders=[]
      rows(0..4).height=18
      self.width = 700
    end
  end 
  
end

  
