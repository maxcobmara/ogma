class PersonalizetimetablePdf < Prawn::Document
  def initialize(personalize, view, test_lecturer,selected_date, college)
    super({top_margin: 20, page_size: 'A4', page_layout: :landscape })
    @personalize = personalize
    @view = view
    @test_lecturer = test_lecturer 
    @selected_date = selected_date
    @detailing=[]
    @detailing_monthurs=[]
    @detailing_friday=[]
    @college=college
    @personalize.each do |sdate, items2|       
      items2.each_with_index do |item, index|
        if sdate.to_s == @selected_date.to_s
          if index == 0 
            @sdt=item.try(:startdate).try(:strftime, "%d/%m/%Y") 
            @edt= item.try(:enddate).try(:strftime, "%d/%m/%Y") 
          end
          item.weeklytimetable_details.each do |h| 
            if h.lecturer_id == @test_lecturer.userable_id
              @detailing << h 
              if h.day2 != 0 
                @detailing_monthurs<< h
              elsif h.is_friday == true 
                @detailing_friday<< h 
              end
            end
          end
        end
       end
    end
    @j = @detailing[0]
    @column_count_friday=@j.weeklytimetable.timetable_friday.timetable_periods.count
    @column_count_monthur=@j.weeklytimetable.timetable_monthurs.timetable_periods.count
    @break_format1 = @j.weeklytimetable.timetable_monthurs.timetable_periods.order(sequence: :asc).pluck(:is_break)
    @break_format2 = @j.weeklytimetable.timetable_friday.timetable_periods.order(sequence: :asc).pluck(:is_break)
    @daycount=4
    @weekdays_end = @j.weeklytimetable.startdate.to_date+4.days
    @daycount2 = (@j.weeklytimetable.enddate.to_date - @weekdays_end).to_i 
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
    #text "JADUAL WAKTU MINGGUAN", :align => :center, :size => 9
    move_down 3
    text "INSTITUSI : #{college.name.upcase}", :align => :left, :size => 9
    text "NAMA PENSYARAH : #{@test_lecturer.userable.rank_id? ? @test_lecturer.userable.staff_with_rank : @test_lecturer.userable.name}", :align => :left, :size => 9
    text "TARIKH : #{@sdt} HINGGA : #{@edt}", :align =>:left, :size => 9
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
      #text "JADUAL WAKTU MINGGUAN", :align => :center, :size => 9
      move_down 3
      text "INSTITUSI : #{college.name.upcase}", :align => :left, :size => 9
      text "NAMA PENSYARAH : #{@test_lecturer.userable.rank_id? ? @test_lecturer.userable.staff_with_rank : @test_lecturer.userable.name}", :align => :left, :size => 9
      text "TARIKH : #{@j.weeklytimetable.startdate.try(:strftime, '%d/%m/%Y') } HINGGA : #{@j.weeklytimetable.enddate.try(:strftime, '%d/%m/%Y')}", :align =>:left, :size =>9
      ##same page header
      table_weekend 
    end
    table_signatory
  end
  
  def table_schedule_sun_wed
    #size & columns count
    all_col = [55]
    0.upto(@column_count_monthur) do |no|
      if (no==1) || (no==4) || (no==7)
        all_col << 45
      else
        if @column_count_monthur > 7
          all_col << 95 #80 
        else
          all_col << 122
        end
      end
    end
    
    #Header(row) : sequence & time period (Sunday - Wednesday)
    header_col = [""]
    allrows_content=[]  
    @detailing.each_with_index do |j,index|
      if index==0
        j.weeklytimetable.timetable_monthurs.timetable_periods.order(sequence: :asc).in_groups_of(@column_count_monthur, false) do |row_things|
          for periods in row_things
            if periods.day_name == 1
              header_col << "#{periods.sequence} <br> #{periods.timing}"
            end
          end 
        end  
      end
    end
  
    #Content - (Sunday - Wednesday) - rows & columns of data
    onerow_content=[]
    1.upto(@daycount) do |row|
      #first column - date & day
      @detailing.each_with_index do |j,index|
        if index==0
          #onerow_content=["#{(j.weeklytimetable.startdate+(row-1)).try(:strftime, "%A")}<br> #{(j.weeklytimetable.startdate+(row-1)).try(:strftime, "%d-%b-%Y")}"]
        end 
        #onerow_content=["#{(j.weeklytimetable.startdate+(row-1)).try(:strftime, "%A")}<br> #{(j.weeklytimetable.startdate+(row-1)).try(:strftime, "%d-%b-%Y")}"]
        onerow_content=["#{I18n.t(:'date.day_names')[(j.weeklytimetable.startdate+(row-1)).wday]}<br> #{(j.weeklytimetable.startdate+(row-1)).try(:strftime, "%d/%m/%Y")}"]
      end 
      #span BREAK fields & display CLASSES fields accordingly-(start)
      1.upto(@column_count_monthur) do |col|
        if @break_format1[col-1]==true && row==1
          onerow_content << {content: "REHAT", rowspan: @daycount}  
        elsif @break_format1[col-1]==true && row!=1
          #do-not-remove should not have any field or value
        elsif @break_format1[col-1]==false
          gg=""
          nos=0
          @detailing_monthurs.each do |j|
            if j.day2 == row  && j.time_slot2 == col && j.weeklytimetable.hod_approved == true
              if nos==0
                nos+=1
                gg+="#{j.weeklytimetable_topic.parent.parent.subject_abbreviation.blank? ? "-" :  j.weeklytimetable_topic.parent.parent.subject_abbreviation.upcase  if j.weeklytimetable_topic.ancestry_depth == 4} #{ '<br>'+j.weeklytimetable_topic.parent.name if j.weeklytimetable_topic.ancestry_depth == 4}  #{j.weeklytimetable_topic.parent.subject_abbreviation.blank? ? "-" :  j.weeklytimetable_topic.parent.subject_abbreviation.upcase if j.weeklytimetable_topic.ancestry_depth != 4} #{'<br>'+j.weeklytimetable_topic.name  if j.weeklytimetable_topic.ancestry_depth != 4}#{"(K)" if j.lecture_method==1} #{j.location_desc}#{"(T)" if j.lecture_method==2}#{"(A)" if j.lecture_method==3} #{'<br>'+j.weeklytimetable_lecturer.name}#{'<br>'+j.weeklytimetable.schedule_programme.programme_list}#{'<br>'+j.weeklytimetable.schedule_intake.description} #{I18n.t('training.weeklytimetable.intake')+ " ("+ j.weeklytimetable.schedule_intake.name+")"}"
              end
            end
          end
          onerow_content << gg
        end
      end 
      allrows_content << onerow_content
    end
    
    data = [header_col]+allrows_content
    table(data, :column_widths => all_col, :cell_style => { :size => 9, :align=> :center,  :inline_format => true}) do
      if header_col.count > 8
        self.width = all_col.sum-95 #-80
      else
        self.width = all_col.sum-45
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
    #Lunch break for Thursday is similar to Sun-Wed, except : working hours is less than Sun-Wed 
    #PENDING : last class did not span as show (if Friday) - 9July2015
    if @weekdays_end.strftime('%A')=="Friday"
      @break_tospan=4
      #classes_tospan=[5,7]
      if  @column_count_friday==5 #excluding 1st column 
        @classes_tospan=[5]
      elsif @column_count_monthur==9 && @column_count_friday==7
        @classes_tospan=[5,7]
      end
    else 
      #Thursday and any other day
      @break_tospan=0
      @classes_tospan=[]
    end
    @span_count=2
    header_col = [""]
    colfriday=1
 
    #size & columns count
    all_col = [55]
    0.upto(@column_count_friday+1) do |no|   #require additional 1 DUMMY column in order to get last DATA/EMPTY column to span, due to separate tables used
       if (no==1) || (no==4) || (no==7)
        all_col << 45
      else
        if @column_count_friday >= 7
          #all_col << 80 
	  all_col << 95 ###9July2015
        else
          all_col << 122
        end
      end
    end
    
    ##Header+Thursday Content row - start
    @detailing.each_with_index do |j,index|   
      if index==0
        j.weeklytimetable.timetable_friday.timetable_periods.order(sequence: :asc).in_groups_of(@column_count_friday, false) do |row_things|
          colfriday=1
          for periods in row_things
            if periods.day_name == 2  
              #if colfriday == 4 || colfriday == 5 || @classes_tospan.include?(colfriday)
              if colfriday == @break_tospan || @classes_tospan.include?(colfriday)
              ##if colfriday == @break_tospan || colfriday == @classes_tospan[0] || colfriday == @classes_tospan[1] 
                header_col << {content: "#{periods.sequence} <br> #{periods.timing}", colspan: @span_count}
              else
                header_col << "#{periods.sequence} <br> #{periods.timing}"
              end
              colfriday+=1
            end
          end 
        end
      end 
    end

    #Content for THURSDAY-(start) - COMPULSORY long break(fifth day==Friday) on the fouth time slot-START
    allrows_content=[]
    @detailing.each_with_index do |j,index|
       if index==0
         #first column - date & day (Thursday)
         allrows_content=["#{I18n.t(:'date.day_names')[@weekdays_end.wday]}#{'<br>'+@weekdays_end.try(:strftime, "%d/%m/%Y")}"]  
       end
    end 
    1.upto(@column_count_friday) do |col2|
      if @break_format2[col2-1]==true
        #BREAK COLUMNS
        if col2 == @break_tospan
          allrows_content<< {content: "REHAT", colspan: @span_count}
        else
          allrows_content << "REHAT"
        end
      elsif @break_format2[col2-1]==false 
        #NON BREAK COLUMNS
        if @classes_tospan.include?(col2)
          gg=""
          nos=0
          @detailing_friday.each do |j|
            if j.is_friday == true && j.time_slot == col2 && j.weeklytimetable.hod_approved == true
              if nos==0
                nos+=1
                gg="#{j.weeklytimetable_topic.parent.parent.subject_abbreviation.blank? ? "-" :  j.weeklytimetable_topic.parent.parent.subject_abbreviation.upcase  if j.weeklytimetable_topic.ancestry_depth == 4} #{ '<br>'+j.weeklytimetable_topic.parent.name if j.weeklytimetable_topic.ancestry_depth == 4}  #{j.weeklytimetable_topic.parent.subject_abbreviation.blank? ? "-" :  j.weeklytimetable_topic.parent.subject_abbreviation.upcase if j.weeklytimetable_topic.ancestry_depth != 4} #{'<br>'+j.weeklytimetable_topic.name  if j.weeklytimetable_topic.ancestry_depth != 4}#{"(K)" if j.lecture_method==1} #{j.location_desc}#{"(T)" if j.lecture_method==2}#{"(A)" if j.lecture_method==3} #{'<br>'+j.weeklytimetable_lecturer.name}#{'<br>'+j.weeklytimetable.schedule_programme.programme_list}#{'<br>'+j.weeklytimetable.schedule_intake.description} #{I18n.t('training.weeklytimetable.intake')+ " ("+ j.weeklytimetable.schedule_intake.name+")"}"
              end
            end
          end
          allrows_content<< {content: gg, colspan: @span_count}
        else
          hh=""
          nos=0
          @detailing_friday.each do |j|
            if j.is_friday == true  && j.time_slot == col2 && j.weeklytimetable.hod_approved == true
              if nos==0
                nos+=1
                hh="#{j.weeklytimetable_topic.parent.parent.subject_abbreviation.blank? ? "-" :  j.weeklytimetable_topic.parent.parent.subject_abbreviation.upcase  if j.weeklytimetable_topic.ancestry_depth == 4} #{ '<br>'+j.weeklytimetable_topic.parent.name if j.weeklytimetable_topic.ancestry_depth == 4}  #{j.weeklytimetable_topic.parent.subject_abbreviation.blank? ? "-" :  j.weeklytimetable_topic.parent.subject_abbreviation.upcase if j.weeklytimetable_topic.ancestry_depth != 4} #{'<br>'+j.weeklytimetable_topic.name  if j.weeklytimetable_topic.ancestry_depth != 4}#{"(K)" if j.lecture_method==1} #{j.location_desc}#{"(T)" if j.lecture_method==2}#{"(A)" if j.lecture_method==3} #{'<br>'+j.weeklytimetable_lecturer.name}#{'<br>'+j.weeklytimetable.schedule_programme.programme_list}#{'<br>'+j.weeklytimetable.schedule_intake.description} #{I18n.t('training.weeklytimetable.intake')+ " ("+ j.weeklytimetable.schedule_intake.name+")"}"
              end
            end
          end
          allrows_content<< hh
        end
      end
    end 
 
    data = [header_col]+[allrows_content]
    table(data, :column_widths => all_col, :cell_style => { :size => 9, :align=> :center,  :inline_format => true}) do 
#       if header_col.count==8    #7 columns
#         self.width = 620  #760
#       else
#       #elsif header_col.count==9
#         #self.width = 665
#       end
      
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
    0.upto(@column_count_monthur) do |no|
       if (no==1) || (no==4) || (no==7)
        all_col << 45
      else
        if @column_count_monthur > 7
          all_col << 95 #80 
        else
          all_col << 122
        end
      end
    end  

    ##Header : Weekend+WeekendContent row - start
    if @daycount2 > 0
      @detailing.each_with_index do |j,index|
        if index==0 
          j.weeklytimetable.timetable_monthurs.timetable_periods.order(sequence: :asc).in_groups_of(@column_count_monthur, false) do |row_things|
            for periods in row_things
              header_col << "#{periods.sequence} <br> #{periods.timing}"
            end
          end
        end
      end

      #Day & date(column) : (ADDITIONAL - Weekends classes) - row starts after timeslot header
      1.upto(@daycount2) do |row2|
        onerow_content=["#{I18n.t(:'date.day_names')[(@weekdays_end+row2).wday]}<br> #{(@weekdays_end+row2).try(:strftime, "%d/%m/%Y")}"]
        weekend_dayname=(@weekdays_end+row2).try(:strftime, "%A")

        #Content - (ADDITIONAL - Weekends classes)
        #span BREAK fields & display CLASSES fields accordingly - col (column) starts after day/date column
        1.upto(@column_count_monthur) do |col2|
          if @break_format1[col2-1]==true && row2==1
            onerow_content << {content: "REHAT", rowspan: @daycount2}
          elsif @break_format1[col2-1]==true && row2!=1
            #do-not-remove : should not have any field or value
          elsif @break_format1[col2-1]==false
            nos=0
            gg=""

            #1-DECLARE BREAK for 4th slot(12:00-13:00) for Weekend class (Friday only) for Week starting on Sunday
            if weekend_dayname=="Friday" && col2==4
              gg+="REHAT"
            else
              #1-display Sat slot accordingly for Week starting on Sunday 
              #2-OR display Weekends slot (Sat & Sun) for week starting on Monday
              @detailing_monthurs.each do |j2|
                if j2.day2 == row2+@daycount+1 && j2.time_slot2 == col2 && @j.weeklytimetable.hod_approved == true
                  if nos==0
                    nos+=1
                    gg+="#{j2.weeklytimetable_topic.parent.parent.subject_abbreviation.blank? ? "-" :  j2.weeklytimetable_topic.parent.parent.subject_abbreviation.upcase  if j2.weeklytimetable_topic.ancestry_depth == 4} #{ '<br>'+j2.weeklytimetable_topic.parent.name if j2.weeklytimetable_topic.ancestry_depth == 4}  #{j2.weeklytimetable_topic.parent.subject_abbreviation.blank? ? "-" :  j2.weeklytimetable_topic.parent.subject_abbreviation.upcase if j2.weeklytimetable_topic.ancestry_depth != 4} #{'<br>'+j2.weeklytimetable_topic.name  if j2.weeklytimetable_topic.ancestry_depth != 4}#{"(K)" if j2.lecture_method==1} #{j2.location_desc}#{"(T)" if j2.lecture_method==2}#{"(A)" if j2.lecture_method==3} #{'<br>'+j2.weeklytimetable_lecturer.name} #{'<br>'+j2.weeklytimetable.schedule_programme.programme_list}#{'<br>'+j2.weeklytimetable.schedule_intake.description}  #{I18n.t('training.weeklytimetable.intake')+ " ("+ j2.weeklytimetable.schedule_intake.name+")"}"
                  end
                end
              end #end for detailing_monthurs
            end  #end for weekend_dayname friday
            onerow_content<< gg

          end
        end
        allrows_content << onerow_content
      end #end for (1.upto(@daycount2) do |row2|)
      
    end  #(if daycount2 > 0)
    
    data = [header_col]+allrows_content
    table(data, :column_widths => all_col, :cell_style => { :size => 9, :align=> :center,  :inline_format => true}) do
      if header_col.count > 8
        self.width = all_col.sum-95 #-80
      else
        self.width = all_col.sum-45
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
      approver="Nama: #{@j.weeklytimetable.endorsed_by? ? @j.weeklytimetable.schedule_approver.staff_with_rank : "-"}"
    else
      approver="Nama: #{@j.weeklytimetable.endorsed_by? ? @j.weeklytimetable.schedule_approver.name : "-"}"
    end
    data1 = [["Disediakan Oleh :","Disemak Oleh :" ],
                  ["#{'.'*90}","#{'.'*90}"],
                  ["Nama: #{@college.code=="amsas" ? @j.weeklytimetable.schedule_creator.staff_with_rank : @j.weeklytimetable.schedule_creator.name}","Nama #{approver}"],
                  ["Pengajar Penyelaras","#{@j.weeklytimetable.endorsed_by? ? @j.weeklytimetable.schedule_approver.positions.first.try(:name) : "-"}"],
                  ["Pelatih Ambilan #{@j.weeklytimetable.try(:schedule_intake).try(:name)}","#{@college.code.upcase}"]]
    table(data1, :column_widths => [350], :cell_style => { :size => 9}) do
      columns(0..1).borders=[]
      rows(0..4).height=18
      self.width = 700
    end
  end 
  
end

  
