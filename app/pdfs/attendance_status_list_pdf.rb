class Attendance_status_listPdf < Prawn::Document
  def initialize(all_dates, title_for_month, year_group, view, college)
    super({top_margin: 40, left_margin: 40, page_size: 'A4', page_layout: :portrait })
    @all_dates = all_dates
    @title_for_month = title_for_month
    @year_group = year_group
    @view = view
    @college=college
    
    font "Helvetica"
    retrieve_data
    record
    page_count.times do |i|
      go_to_page(i+1)
      footer
    end
  end
  
  def record
    month_cols=[]
    mnt_cnt=@title_for_month.count
    if mnt_cnt == 0
      total_cols=4
      month_cols << 310
    else
      total_cols=3+mnt_cnt
      balance=520-210
      per_col=balance/mnt_cnt
      0.upto(mnt_cnt-1).each do |cnt|
        month_cols << per_col
      end
      status_bgcolor=@status_bgcolor
    end
    table(line_item_rows, :column_widths => [30, 100, 80]+month_cols, :cell_style => { :size => 9,  :inline_format => :true}, :header => 2) do
      row(0).borders =[]
      row(0).align = :center
      row(0).style size: 11
      row(0).height=50
      row(1).height=5
      row(1).borders=[]
      row(0..3).font_style = :bold
      row(2..3).background_color = 'FFE34D'
      row(2..3).columns(3..total_cols-1).align=:center
      if mnt_cnt==0
        self.width=520
      else
        self.width=210+mnt_cnt*per_col

        #status_bgcolor={"3, 3"=>"K", "3, 4"=>"K", "3, 5"=>"K", "4, 3"=>"", "4,4"=>"", "4, 5"=>"K"}
        status_bgcolor.keys.each_with_index do |row_col, ind|
	  a=status_bgcolor[row_col]
	  if a=="K"
	    bgcolor= 'fafcc9'
          elsif a=="H"
	    bgcolor='c9fccb'
	  elsif a=="M"
	    bgcolor='fcdad9'
	  else
	    bgcolor='fffdfd'
	  end
	  arow,acol=row_col.split(",")
	  row(arow.to_i).column(acol.to_i).background_color= bgcolor
	  row(arow.to_i).column(acol.to_i).style size: 11
	  row(arow.to_i).column(acol.to_i).font_style = :bold
	  row(arow.to_i).column(acol.to_i).align=:center
        end
      end
    end
  end
  
  def retrieve_data
    abody=[]
    ahash=Hash.new
    @all_dates.keys.sort.each_with_index do |thumbid, index|
        thumb_owners=Staff.where(thumb_id: thumbid)
        ######### - per thumd_id liner (start)
        staff_col=""
        unit_col=""
        for astaff in thumb_owners
          staff_col+="#{astaff.staff_thumb}<br>" 
          unit_col+="#{astaff.render_unit}<br>"
        end

        all_begin_months = @all_dates[thumbid].map{|x|x.logged_at.in_time_zone('UTC').to_date.beginning_of_month.to_s}
        in_column = []
        count_status = 0

        for every_month_begin in all_begin_months.uniq
          if count_status == 0
            previous_stat = 1
	    previous_status = StaffAttendance.monthly_colour_status(every_month_begin, thumbid, previous_stat)
	  else
	    previous_status = StaffAttendance.monthly_colour_status(every_month_begin, thumbid, previous_stat)
	  end
	  0.upto(@title_for_month.count-1) do |count2|
	    if every_month_begin == @title_for_month[count2]
	      in_column[count2] = previous_status
	    end
	  end
	  previous_stat = previous_status
	  count_status+=1
        end
	
	status_label=[]
	
	0.upto(@title_for_month.count-1) do |count2|
	  if in_column[count2] == 1
	    color_letter="K"
	  elsif in_column[count2] == 2
	    color_letter="H"
	  elsif in_column[count2] == 3
	    color_letter="M"
	  else
            color_letter=""
	  end
	  status_label << color_letter
	  bhash=Hash["#{index+4}, #{count2+3}", "#{color_letter}"]
	  ahash=ahash.merge(bhash)
	end
	abody << ["#{index+1}", staff_col, unit_col]+status_label
	
        ######### - per thumd_id liner (end)
    end
    @body=abody
    @status_bgcolor=ahash
  end
  
  def line_item_rows
    counter = counter||0
    mnt_cnt=@title_for_month.count
    b=[]
    if mnt_cnt==0
      total_cols=4
      dummy=["", "", "", ""]
      a=[I18n.t('time.years').titleize]
      b=[I18n.t('time.months').titleize ]
    else
      total_cols=3+mnt_cnt
      dummy=["", "", ""]
      for amonth in @title_for_month
        b << "#{I18n.t(:'date.abbr_month_names')[amonth.to_date.strftime("%m").to_i]}"
        dummy << ""
      end
      a=[]
      @year_group.each do |years, months|
        a << {content: "#{years}", colspan: months.count}
      end
    end
    
    header=[[{content: "#{I18n.t('staff_attendance.status_punchcard').upcase}<br> #{@college.name.upcase}", colspan: total_cols}], dummy,
            [{content: "No", rowspan: 2},{content:  "#{I18n.t('staff_attendance.thumb_id')}", rowspan: 2}, {content: "#{I18n.t('staff_attendance.unit_department')}", rowspan: 2} ]+a, b]
  
    header+@body
  end
  
  def footer
    draw_text "#{page_number} / #{page_count}",  :size => 8, :at => [500,-5]
  end

end