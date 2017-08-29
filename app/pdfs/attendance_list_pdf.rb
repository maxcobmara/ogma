class Attendance_listPdf < Prawn::Document
  def initialize(attendances, group_sa_by_day, search, view, college)
    super({top_margin: 40, left_margin: 40, page_size: 'A4', page_layout: :portrait })
    @ooo = attendances
    @group_sa_by_day=group_sa_by_day
    @view = view
    @college=college
    @search2=search
    
    @thumb_ids =  StaffAttendance.get_thumb_ids_unit_names(1)
    @unit_names = StaffAttendance.get_thumb_ids_unit_names(2)
    @all_thumb_ids = StaffAttendance.thumb_ids_all 
    
    font "Helvetica"
    #record
    retrieve_data
    record2
    page_count.times do |i|
      go_to_page(i+1)
      footer
    end
  end
  
  def retrieve_data
    date_row=[]
    unit_row=[]
    sa_row=[]
    counting=1
    counter = counter||0
    body=[]
    @ooo.each do |date, staff_attendances|
        @groupped_sa = Array.new(@thumb_ids.count) { Array.new }
        @hula= staff_attendances[staff_attendances.count-1].thumb_id
        @last_person_oftheday=@group_sa_by_day[date].last.thumb_id
        @group_sa_current_date = @group_sa_by_day[date]
        staff_attendances.each_with_index do |sas,nos|    
            @thumb_ids.each_with_index do |tis,index|
              if tis.include?(sas.thumb_id)
                @groupped_sa[index]<< sas
              end
	    end
        end
	date_row << counting+=1
        body << [{content: "#{I18n.t('staff_attendance.date')} #{date.to_date.try(:strftime, "%d-%m-%Y")}", colspan: 10}]
        @groupped_sa.each_with_index do |g_sa,ind|
	    if g_sa.count>0 
	        unit_row << counting+=1
	        body << [{content: "#{I18n.t('staff_attendance.unit')} #{@unit_names[ind]}", colspan: 10}]
	    end
	    g_sa.group_by{|y|y.thumb_id}.each do |aastaff, sa_beforesort|
	        sa_beforesort.sort_by{|t|[t.log_type, t.logged_at]}.each_with_index do |sa, ind3|
		    if (sa.log_type=="I" || sa.log_type=="i") || (sa.log_type=="O" || sa.log_type=="o")
		        curr_date=sa.logged_at.strftime('%Y-%m-%d')
		        shiftid = StaffShift.shift_id_in_use(curr_date, sa.thumb_id)
			flag_col="#{sa.r_u_late(shiftid) == 'flag' ? '<b>*</b>' : ''} #{sa.r_u_early(shiftid) == 'flag' ? '<b>*</b>' : ''}"
			staff_col="#{sa.attended.try(:staff_with_rank)} (#{sa.id.to_s}) (#{sa.thumb_id}) "
			if @college.code=='amsas'
			  in_col="#{sa.log_type == 'I' ? sa.logged_at.strftime('%H:%M') : '' }"
			  if sa.log_type == "O" || sa.log_type == "o"
			    out_col=sa.logged_at.strftime('%H:%M')   #sa.logged_at.in_time_zone('UTC').strftime('%l:%M %P')
			  end
			else
			  in_col="#{sa.log_type == 'I' ? sa.logged_at.strftime('%l:%M %P') : '' }"
			  if sa.log_type == "O" || sa.log_type == "o"
			    out_col=sa.logged_at.strftime('%l:%M %P')   #sa.logged_at.in_time_zone('UTC').strftime('%l:%M %P')
			  end
			end
			#Display shift in use (start time & end time plus 'activation date' [ie. 1 day after deactivate_date of prev shift used])
                        shiftinuse= StaffShift.shift_in_use(curr_date,sa.thumb_id)
			if shiftinuse.include?("~")==false
			  shift= shiftinuse
			else
			  shift= "#{shiftinuse.split("~")[0]} <br>(#{shiftinuse.split("~")[1]})"  #%font{size: "-2px", color: "grey"}
			end
                        if sa.log_type == "I" 
			  if sa.late_early(shiftid)=="-"
			    late_in_col="-"
			  else
			    late_in_col= sa.late_early(shiftid)
			  end
			else
			  late_in_col="-"
			end
                        if sa.log_type == "O" 
                          if sa.late_early(shiftid)=="-"
			    early_out_col="-"
			  else
			    early_out_col= sa.late_early(shiftid)
			  end
			else
			  early_out_col="-"
			end
			if (sa.trigger == nil && sa.r_u_late(shiftid) == "flag") || (sa.trigger == nil && sa.r_u_early(shiftid) == "flag")
			  trigger="#{I18n.t('staff_attendance.not_yet_triggered')}"
			elsif sa.trigger == true
			  trigger="#{I18n.t('yes2')}"
			else
			  trigger="-"
			end
			 if (sa.trigger == nil && sa.r_u_late(shiftid) == "flag") ||(sa.trigger == nil && sa.r_u_early(shiftid) == "flag")
			   ignore="#{I18n.t('staff_attendance.not_yet_ignored')}"
			 elsif sa.trigger == false
			   ignore="#{I18n.t('yes2')}"
			 else
			   ignore="-"
			 end
			 sa_row << counting+=1
			 body << ["#{counter+=1}", flag_col, staff_col, in_col, out_col, shift, late_in_col, early_out_col, trigger, ignore]
		    end
		   
		end
	    end  
        end  #ending for @group_sa.each_with_index....

	#display unit name for non-exist sa
	#text "#{@search2} #{@search2==nil} #{@search2.keyword_search==nil}"
        if @hula == @last_person_oftheday && (@search2==nil || @search2.keyword_search==nil) #&& (params[:q]==nil || (params[:q][:keyword_search]==nil))
            @groupped_sa_fornodata=Array.new(@thumb_ids.count) { Array.new }
	    @group_sa_current_date.each do |stfa|
	        @thumb_ids.each_with_index do |tis,index|
		     if tis.include?(stfa.thumb_id)
		         @groupped_sa_fornodata[index]<< stfa
		     end
		end
	    end
	    @groupped_sa_fornodata.each_with_index do |g_sa2,ind2|
	        if g_sa2.count == 0
		    unit_row << counting+=1
		    body << [{content: "#{I18n.t('staff_attendance.unit')} #{@unit_names[ind2]}", colspan: 10}]
		end
	    end
	end 
	  
    end  #ending for @ooo.each....
    @body=body
    @date_row=date_row
    @unit_row=unit_row
    @sa_row=sa_row
  end
  
  def record2
     date_row=@date_row
     unit_row=@unit_row
     sa_row=@sa_row
     table(line_item_rows2, :column_widths => [30, 30, 110, 45, 45, 60, 50, 50, 50, 50], :cell_style => { :size => 9,  :inline_format => :true}, :header => 2) do
      row(0).borders =[]
      row(0).height=50
      row(0).style size: 11
      row(0).align = :center
      row(0..1).font_style = :bold
      row(1).background_color = 'FFE34D'
      
      self.width = 520
      for adate in date_row
	row(adate).align =:center
	row(adate).font_style = :bold
	row(adate).background_color='f8dd78'
      end
      for aunit in unit_row
	row(aunit).align=:center
	row(aunit).font_style = :bold
	row(aunit).background_color='ffe3b5'
      end
      for asa in sa_row
	row(asa).columns(6..9).align=:center
	row(asa).columns(6..7).text_color ='EC0C16'
	row(asa).columns(1).text_color ='EC0C16'
	row(asa).columns(1).align=:center
      end
    end
  end
  
  def line_item_rows2
    header=[[{content: "#{I18n.t('staff_attendance.list').upcase}<br> #{@college.name.upcase}", colspan: 10}],
            ["No", I18n.t('staff_attendance.flag'), I18n.t('staff_attendance.thumb_id'), I18n.t('staff_attendance.logged_in'), I18n.t('staff_attendance.logged_out'), I18n.t('staff_attendance.shift'), I18n.t('staff_attendance.late'), I18n.t('staff_attendance.early'), I18n.t('staff_attendance.action'), I18n.t('staff_attendance.ignore')]]
    header+@body
  end
  
  def footer
    draw_text "#{page_number} / #{page_count}",  :size => 8, :at => [500,-5]
  end
 
####################
#   def record
#     counting=1
#     date_row=[]
#     unit_row=[]
#     sa_row=[]
#     @ooo.each do |date, staff_attendances|
#         @groupped_sa = Array.new(@thumb_ids.count) { Array.new }
#         @hula= staff_attendances[staff_attendances.count-1].thumb_id
#         @last_person_oftheday=@group_sa_by_day[date].last.thumb_id
#         @group_sa_current_date = @group_sa_by_day[date]
#         staff_attendances.each_with_index do |sas,nos|    
#             @thumb_ids.each_with_index do |tis,index|
#               if tis.include?(sas.thumb_id)
#                 @groupped_sa[index]<< sas
#               end
# 	    end
#         end
# 	date_row << counting+=1
#         @groupped_sa.each_with_index do |g_sa,ind|
# 	    unit_row << counting+=1 if g_sa.count>0 
# 	    g_sa.group_by{|y|y.thumb_id}.each do |aastaff, sa_beforesort|
# 	        sa_beforesort.sort_by{|t|[t.log_type, t.logged_at]}.each_with_index do |sa, ind3|
# 		    sa_row << counting+=1 if (sa.log_type=="I" || sa.log_type=="i") || (sa.log_type=="O" || sa.log_type=="o")
# 		end
# 	    end
# 	end
# 	if @hula == @last_person_oftheday && (@search2==nil || @search2.keyword_search==nil) 
#             @groupped_sa_fornodata=Array.new(@thumb_ids.count) { Array.new }
# 	    @group_sa_current_date.each do |stfa|
# 	        @thumb_ids.each_with_index { |tis,index| @groupped_sa_fornodata[index]<< stfa if tis.include?(stfa.thumb_id)}
# 	    end
# 	    @groupped_sa_fornodata.each_with_index { |g_sa2,ind2|  unit_row << counting+=1 if g_sa2.count == 0}
# 	end 
#     end
#     text "PERTAMA #{date_row}  #{unit_row}"
#     
#     table(line_item_rows, :column_widths => [30, 30, 110, 45, 45, 60, 50, 50, 50, 50], :cell_style => { :size => 9,  :inline_format => :true}, :header => 2) do
#       row(0).borders =[]
#       row(0).height=50
#       row(0).style size: 11
#       row(0).align = :center
#       row(0..1).font_style = :bold
#       row(1).background_color = 'FFE34D'
#       
#       self.width = 520
#       for adate in date_row
# 	row(adate).align =:center
# 	row(adate).font_style = :bold
# 	row(adate).background_color='f8dd78'
#       end
#       for aunit in unit_row
# 	row(aunit).align=:center
# 	row(aunit).font_style = :bold
# 	row(aunit).background_color='ffe3b5'
#       end
#       for asa in sa_row
# 	row(asa).columns(6..9).align=:center
# 	row(asa).columns(6..7).text_color ='EC0C16'
# 	row(asa).columns(1).text_color ='EC0C16'
# 	row(asa).columns(1).align=:center
#       end
#     end
#   end
# 
#   def line_item_rows
#     date_row=[]
#     unit_row=[]
#     sa_row=[]
#     counting=1
#     counter = counter||0
#     header=[[{content: "#{I18n.t('staff_attendance.list').upcase}<br> #{@college.name.upcase}", colspan: 10}],
#             ["No", I18n.t('staff_attendance.flag'), I18n.t('staff_attendance.thumb_id'), I18n.t('staff_attendance.logged_in'), I18n.t('staff_attendance.logged_out'), I18n.t('staff_attendance.shift'), I18n.t('staff_attendance.late'), I18n.t('staff_attendance.early'), I18n.t('staff_attendance.action'), I18n.t('staff_attendance.ignore')]]
#     body=[]
#     @ooo.each do |date, staff_attendances|
#         @groupped_sa = Array.new(@thumb_ids.count) { Array.new }
#         @hula= staff_attendances[staff_attendances.count-1].thumb_id
#         @last_person_oftheday=@group_sa_by_day[date].last.thumb_id
#         @group_sa_current_date = @group_sa_by_day[date]
#         staff_attendances.each_with_index do |sas,nos|    
#             @thumb_ids.each_with_index do |tis,index|
#               if tis.include?(sas.thumb_id)
#                 @groupped_sa[index]<< sas
#               end
# 	    end
#         end
# 	date_row << counting+=1
#         body << [{content: "#{I18n.t('staff_attendance.date')} #{date.to_date.try(:strftime, "%d-%m-%Y")}", colspan: 10}]
#         @groupped_sa.each_with_index do |g_sa,ind|
# 	    if g_sa.count>0 
# 	        unit_row << counting+=1
# 	        body << [{content: "#{I18n.t('staff_attendance.unit')} #{@unit_names[ind]}", colspan: 10}]
# 	    end
# 	    g_sa.group_by{|y|y.thumb_id}.each do |aastaff, sa_beforesort|
# 	        sa_beforesort.sort_by{|t|[t.log_type, t.logged_at]}.each_with_index do |sa, ind3|
# 		    if (sa.log_type=="I" || sa.log_type=="i") || (sa.log_type=="O" || sa.log_type=="o")
# 		        curr_date=sa.logged_at.strftime('%Y-%m-%d')
# 		        shiftid = StaffShift.shift_id_in_use(curr_date, sa.thumb_id)
# 			flag_col="#{sa.r_u_late(shiftid) == 'flag' ? '<b>*</b>' : ''} #{sa.r_u_early(shiftid) == 'flag' ? '<b>*</b>' : ''}"
# 			staff_col="#{sa.attended.try(:staff_with_rank)} (#{sa.id.to_s}) (#{sa.thumb_id}) "
# 			if @college.code=='amsas'
# 			  in_col="#{sa.log_type == 'I' ? sa.logged_at.strftime('%H:%M') : '' }"
# 			  if sa.log_type == "O" || sa.log_type == "o"
# 			    out_col=sa.logged_at.strftime('%H:%M')   #sa.logged_at.in_time_zone('UTC').strftime('%l:%M %P')
# 			  end
# 			else
# 			  in_col="#{sa.log_type == 'I' ? sa.logged_at.strftime('%l:%M %P') : '' }"
# 			  if sa.log_type == "O" || sa.log_type == "o"
# 			    out_col=sa.logged_at.strftime('%l:%M %P')   #sa.logged_at.in_time_zone('UTC').strftime('%l:%M %P')
# 			  end
# 			end
# 			#Display shift in use (start time & end time plus 'activation date' [ie. 1 day after deactivate_date of prev shift used])
#                         shiftinuse= StaffShift.shift_in_use(curr_date,sa.thumb_id)
# 			if shiftinuse.include?("~")==false
# 			  shift= shiftinuse
# 			else
# 			  shift= "#{shiftinuse.split("~")[0]} <br>(#{shiftinuse.split("~")[1]})"  #%font{size: "-2px", color: "grey"}
# 			end
#                         if sa.log_type == "I" 
# 			  if sa.late_early(shiftid)=="-"
# 			    late_in_col="-"
# 			  else
# 			    late_in_col= sa.late_early(shiftid)
# 			  end
# 			else
# 			  late_in_col="-"
# 			end
#                         if sa.log_type == "O" 
#                           if sa.late_early(shiftid)=="-"
# 			    early_out_col="-"
# 			  else
# 			    ear_out_col= sa.late_early(shiftid)
# 			  end
# 			else
# 			  early_out_col="-"
# 			end
# 			if (sa.trigger == nil && sa.r_u_late(shiftid) == "flag") || (sa.trigger == nil && sa.r_u_early(shiftid) == "flag")
# 			  trigger="#{I18n.t('staff_attendance.not_yet_triggered')}"
# 			elsif sa.trigger == true
# 			  trigger="#{I18n.t('yes')}"
# 			else
# 			  trigger="-"
# 			end
# 			 if (sa.trigger == nil && sa.r_u_late(shiftid) == "flag") ||(sa.trigger == nil && sa.r_u_early(shiftid) == "flag")
# 			   ignore="#{I18n.t('staff_attendance.not_yet_ignored')}"
# 			 elsif sa.trigger == false
# 			   ignore="#{I18n.t('yes')}"
# 			 else
# 			   ignore="-"
# 			 end
# 			 sa_row << counting+=1
# 			 body << ["#{counter+=1}", flag_col, staff_col, in_col, out_col, shift, late_in_col, early_out_col, trigger, ignore]
# 		    end
# 		   
# 		end
# 	    end  
#         end  #ending for @group_sa.each_with_index....
# 
# 	#display unit name for non-exist sa
# 	#text "#{@search2} #{@search2==nil} #{@search2.keyword_search==nil}"
#         if @hula == @last_person_oftheday && (@search2==nil || @search2.keyword_search==nil) #&& (params[:q]==nil || (params[:q][:keyword_search]==nil))
#             @groupped_sa_fornodata=Array.new(@thumb_ids.count) { Array.new }
# 	    @group_sa_current_date.each do |stfa|
# 	        @thumb_ids.each_with_index do |tis,index|
# 		     if tis.include?(stfa.thumb_id)
# 		         @groupped_sa_fornodata[index]<< stfa
# 		     end
# 		end
# 	    end
# 	    @groupped_sa_fornodata.each_with_index do |g_sa2,ind2|
# 	        if g_sa2.count == 0
# 		    unit_row << counting+=1
# 		    body << [{content: "#{I18n.t('staff_attendance.unit')} #{@unit_names[ind2]}", colspan: 10}]
# 		end
# 	    end
# 	end 
# 	  
#     end  #ending for @ooo.each....
#     header+body
#   end

end