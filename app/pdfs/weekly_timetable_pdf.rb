class Weekly_timetablePdf < Prawn::Document
  def initialize(weeklytimetable, view)
    super({top_margin: 20, page_size: 'A4', page_layout: :landscape })
    @weeklytimetable = weeklytimetable
    @view = view
    
    @count1=@weeklytimetable.timetable_monthurs.timetable_periods.count
    @count2=@weeklytimetable.timetable_friday.timetable_periods.count 
    @break_format1 = @weeklytimetable.timetable_monthurs.timetable_periods.pluck(:is_break)
    @break_format2 = @weeklytimetable.timetable_friday.timetable_periods.pluck(:is_break)
    @daycount=4
    @weekdays_end = @weeklytimetable.startdate.to_date+4.days
    @daycount2 = (@weeklytimetable.enddate.to_date - @weekdays_end).to_i 
    
    font "Times-Roman"
    text "BPL.KKM.PK(T)", :align => :right, :size => 8
    image "#{Rails.root}/app/assets/images/logo_kerajaan.png", :position => :center, :scale => 0.5
    move_down 3
    text "KEMENTERIAN KESIHATAN MALAYSIA", :align => :center, :size => 9
    text "JADUAL WAKTU MINGGUAN", :align => :center, :size => 9
    move_down 3
    text "INSTITUSI : KOLEJ SAINS KESIHATAN BERSEKUTU JOHOR BAHRU", :align => :left, :size => 9
    text "KUMPULAN PELATIH : #{@weeklytimetable.try(:schedule_intake).try(:group_with_intake_name)}", :align => :left, :size => 9
    table_date_semester_week
    table_schedule_sun_wed
    table_schedule_thurs
    if @daycount2 > 0
      start_new_page
      ##same page header
      text "BPL.KKM.PK(T)", :align => :right, :size => 8
      image "#{Rails.root}/app/assets/images/logo_kerajaan.png", :position => :center, :scale => 0.5
      move_down 3
      text "KEMENTERIAN KESIHATAN MALAYSIA", :align => :center, :size => 9
      text "JADUAL WAKTU MINGGUAN", :align => :center, :size => 9
      move_down 3
      text "INSTITUSI : KOLEJ SAINS KESIHATAN BERSEKUTU JOHOR BAHRU", :align => :left, :size => 9
      text "KUMPULAN PELATIH : #{@weeklytimetable.try(:schedule_intake).try(:group_with_intake_name)}", :align => :left, :size => 9
      table_date_semester_week
      ##same page header
      table_weekend 
    end
    table_signatory
  end
   
  def table_date_semester_week
    data = [[ "TARIKH : #{@weeklytimetable.startdate.try(:strftime, '%d %b %Y') } HINGGA : #{@weeklytimetable.enddate.try(:strftime, '%d %b %Y')}",
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
          all_col << 80 #remove above conditions & use JUST this line if error occurs
        else
          all_col << 122
        end
      end
    end
    
    header_col = [""]
    allrows_content=[]  
    @weeklytimetable.timetable_monthurs.timetable_periods.in_groups_of(@count1, false).map do |row_things|
      #header (Sun - Wed)
      for periods in row_things
        header_col << "#{periods.sequence} <br> #{periods.timing}"
      end
      #rows & columns of data
      1.upto(@daycount) do |row|
        onerow_content=["#{(@weeklytimetable.startdate+(row-1)).try(:strftime, "%A")}<br> #{(@weeklytimetable.startdate+(row-1)).try(:strftime, "%d-%b-%Y")}"]
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
		gg+="#{xx.weeklytimetable_topic.parent.parent.subject_abbreviation.blank? ? "-" :  xx.weeklytimetable_topic.parent.parent.subject_abbreviation.upcase  if xx.weeklytimetable_topic.ancestry_depth == 4} #{ '<br>'+xx.weeklytimetable_topic.parent.name if xx.weeklytimetable_topic.ancestry_depth == 4}  #{xx.weeklytimetable_topic.parent.subject_abbreviation.blank? ? "-" :  xx.weeklytimetable_topic.parent.subject_abbreviation.upcase if xx.weeklytimetable_topic.ancestry_depth != 4} #{'<br>'+xx.weeklytimetable_topic.name  if xx.weeklytimetable_topic.ancestry_depth != 4}#{"(K)" if xx.lecture_method==1} #{"(T)" if xx.lecture_method==2}#{"(A)" if xx.lecture_method==3} #{'<br>'+xx.weeklytimetable_lecturer.name}"
                #above-without location--
                #below-with location--
                #gg+="#{xx.weeklytimetable_topic.parent.parent.subject_abbreviation.blank? ? "-" :  xx.weeklytimetable_topic.parent.parent.subject_abbreviation.upcase  if xx.weeklytimetable_topic.ancestry_depth == 4} #{ '<br>'+xx.weeklytimetable_topic.parent.name if xx.weeklytimetable_topic.ancestry_depth == 4}  #{xx.weeklytimetable_topic.parent.subject_abbreviation.blank? ? "-" :  xx.weeklytimetable_topic.parent.subject_abbreviation.upcase if xx.weeklytimetable_topic.ancestry_depth != 4} #{'<br>'+xx.weeklytimetable_topic.name  if xx.weeklytimetable_topic.ancestry_depth != 4}#{xx.weeklytimetable_location.try(:name)}#{"(K)" if xx.lecture_method==1} #{"(T)" if xx.lecture_method==2}#{"(A)" if xx.lecture_method==3} #{xx.weeklytimetable_lecturer.name}"
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
        self.width = all_col.sum-80#750
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
    @classes_tospan=[5,7]
    @span_count=2
    header_col = [""]
    colfriday=1
    allrows_content=["#{@weekdays_end.try(:strftime, "%A")}#{'<br>'+@weekdays_end.try(:strftime, "%d-%b-%Y")}"]  
    
    #size & columns count
    all_col = [55]
    0.upto(@count1) do |no|
       if (no==1) || (no==4) || (no==7)
        all_col << 45
      else
        if @count1 > 7
          all_col << 80 #remove above conditions & use JUST this line if error occurs
        else
          all_col << 122
        end
      end
    end
    
    ##Header+Thursday Content row - start
    @weeklytimetable.timetable_friday.timetable_periods.in_groups_of(@count2, false).map do |row_things|  
      #Header (Thursday)
      for periods in row_things
        if colfriday == @break_tospan || colfriday == @classes_tospan[0] || colfriday == @classes_tospan[1] 
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
              if xx.is_friday == true && xx.time_slot == @count1+col2 
                #= render 'subtab_class_details', {:xx=>xx}   
                gg+="#{xx.weeklytimetable_topic.parent.parent.subject_abbreviation.blank? ? "-" :  xx.weeklytimetable_topic.parent.parent.subject_abbreviation.upcase  if xx.weeklytimetable_topic.ancestry_depth == 4} #{ '<br>'+xx.weeklytimetable_topic.parent.name if xx.weeklytimetable_topic.ancestry_depth == 4}  #{xx.weeklytimetable_topic.parent.subject_abbreviation.blank? ? "-" :  xx.weeklytimetable_topic.parent.subject_abbreviation.upcase if xx.weeklytimetable_topic.ancestry_depth != 4} #{'<br>'+xx.weeklytimetable_topic.name  if xx.weeklytimetable_topic.ancestry_depth != 4}#{"(K)" if xx.lecture_method==1} #{"(T)" if xx.lecture_method==2}#{"(A)" if xx.lecture_method==3} #{'<br>'+xx.weeklytimetable_lecturer.name}"
              end
            end
            allrows_content<< {content: gg, colspan: @span_count}
          else
            hh=""
            @weeklytimetable.weeklytimetable_details.each do |xx|
              if xx.is_friday == true && xx.time_slot == @count1+col2
                #=render 'subtab_class_details', {:xx=>xx}
                hh+="#{xx.weeklytimetable_topic.parent.parent.subject_abbreviation.blank? ? "-" :  xx.weeklytimetable_topic.parent.parent.subject_abbreviation.upcase  if xx.weeklytimetable_topic.ancestry_depth == 4} #{ '<br>'+xx.weeklytimetable_topic.parent.name if xx.weeklytimetable_topic.ancestry_depth == 4}  #{xx.weeklytimetable_topic.parent.subject_abbreviation.blank? ? "-" :  xx.weeklytimetable_topic.parent.subject_abbreviation.upcase if xx.weeklytimetable_topic.ancestry_depth != 4} #{'<br>'+xx.weeklytimetable_topic.name  if xx.weeklytimetable_topic.ancestry_depth != 4}#{"(K)" if xx.lecture_method==1} #{"(T)" if xx.lecture_method==2}#{"(A)" if xx.lecture_method==3} #{'<br>'+xx.weeklytimetable_lecturer.name}"
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
      #self.width = all_col.sum-80 #use this if below error
      if header_col.count > 8
        self.width = all_col.sum-80#750
      else
        self.width = all_col.sum-45#755
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
          all_col << 80 #remove above conditions & use JUST this line if error occurs
        else
          all_col << 122
        end
      end
    end  
    
    ##Header : Weekend+WeekendContent row - start
    if @daycount2 > 0
      @weeklytimetable.timetable_monthurs.timetable_periods.in_groups_of(@count1, false).map do |row_things|  
        #Header (Weekend)
        for periods in row_things
          header_col << "#{periods.sequence} <br> #{periods.timing}"
        end
        #Day & date(column) : (ADDITIONAL - Weekends classes) - row starts after timeslot header
        1.upto(@daycount2) do |row2|
          onerow_content=["#{(@weekdays_end+row2).try(:strftime, "%A")}<br> #{(@weekdays_end+row2).try(:strftime, "%d-%b-%Y")}"]

          #Content - (ADDITIONAL - Weekends classes)
          #span BREAK fields & display CLASSES fields accordingly - col (column) starts after day/date column
          1.upto(@count1) do |col2|
            if @break_format1[col2-1]==true && row2==1
              onerow_content << {content: "REHAT", rowspan: @daycount2}
            elsif @break_format1[col2-1]==true && row2!=1
              #do-not-remove : should not have any field or value
            elsif @break_format1[col2-1]==false
              gg=""
              @weeklytimetable.weeklytimetable_details.each do |xx|
                if xx.day2 == row2+@daycount+1 && xx.time_slot2 == col2 
                  gg+="#{xx.weeklytimetable_topic.parent.parent.subject_abbreviation.blank? ? "-" :  xx.weeklytimetable_topic.parent.parent.subject_abbreviation.upcase  if xx.weeklytimetable_topic.ancestry_depth == 4} #{ '<br>'+xx.weeklytimetable_topic.parent.name if xx.weeklytimetable_topic.ancestry_depth == 4}  #{xx.weeklytimetable_topic.parent.subject_abbreviation.blank? ? "-" :  xx.weeklytimetable_topic.parent.subject_abbreviation.upcase if xx.weeklytimetable_topic.ancestry_depth != 4} #{'<br>'+xx.weeklytimetable_topic.name  if xx.weeklytimetable_topic.ancestry_depth != 4}#{"(K)" if xx.lecture_method==1} #{"(T)" if xx.lecture_method==2}#{"(A)" if xx.lecture_method==3} #{'<br>'+xx.weeklytimetable_lecturer.name}"
                end
              end
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
        self.width = all_col.sum-80#750
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
    data1 = [["Disediakan Oleh :","Disemak Oleh :" ],
                  ["#{'.'*90}","#{'.'*90}"],
                  ["Nama: #{@weeklytimetable.schedule_creator.name}","Nama #{@weeklytimetable.endorsed_by? ? @weeklytimetable.schedule_approver.name : "-"}"],
                  ["Pengajar Penyelaras","#{@weeklytimetable.endorsed_by? ? @weeklytimetable.schedule_approver.positions.first.try(:name) : "-"}"],
                  ["Pelatih Ambilan #{@weeklytimetable.try(:schedule_intake).try(:name)}","KSKB JB"]]
    table(data1, :column_widths => [350], :cell_style => { :size => 10}) do
      columns(0..1).borders=[]
      rows(0..4).height=18
      self.width = 700
    end
  end 
  
end

  
