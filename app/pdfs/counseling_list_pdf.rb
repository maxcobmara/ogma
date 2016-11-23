class Counseling_listPdf < Prawn::Document
  def initialize(appointments, appointments_by_case, session_dones, session_dones_by_case, view, college)
    super({top_margin: 40,  page_size: 'A4', page_layout: :portrait })
    @appointments=appointments
    @appointments_by_case=appointments_by_case
    @session_dones=session_dones
    @session_dones_by_case=session_dones_by_case
    @view = view
    @college=college
    font "Helvetica"
    record
    page_count.times do |i|
      go_to_page(i+1)
      footer
    end
  end
  
  
  def record
    if @college.code=='amsas'
      columns_arr=[30, 120, 90, 90, 45, 55, 90]
    else
      columns_arr=[30, 50, 50, 50, 50, 50, 45, 55, 50]
    end
    title_rows=[2]
    title_rows << @appointments.count+4
    table(line_item_rows, :column_widths => columns_arr, :cell_style => { :size => 9,  :inline_format => :true}, :header => 2) do
      row(0).borders =[]
      row(0).height=50
      row(0).style size: 11
      row(0).align = :center
      row(0..1).font_style = :bold
      row(1).background_color = 'FFE34D'
      for title_row in title_rows
        row(title_row).align=:center
	row(title_row).background_color='FDF8A1'
	row(title_row).font_style=:bold
      end
    end
  end
  
  def line_item_rows
    counter = counter || 0
    header = [[{content: "#{I18n.t('student.counseling.title').upcase}<br> #{@college.name.upcase}", colspan: 7}]]
    name_programme=["No", I18n.t('student.counseling.student_id'), I18n.t('student.counseling.programme')]
    details=[I18n.t('student.counseling.appointment_for'), I18n.t('student.counseling.duration'), I18n.t('student.counseling.is_confirmed'), I18n.t('student.counseling.feedback_referrer')]
    if @college.code=='amsas'
      header << name_programme+details
    else
      header << [I18n.t('student.counseling.matrix_no')]+name_programme+[I18n.t('student.counseling.year_semester')]+details
    end
    body=[[{content: I18n.t('student.counseling.appointments'), colspan: 7}]]
    if @appointments && @appointments.count > 0
        @appointments_by_case.each do |case_id, appointments|
	     count=0
	     appointments.each do |appointment|
	       name_programme2=["#{appointment.student.student_with_rank} #{appointment.c_type == 'involuntary' ? '*' : ''}", "#{appointment.student.programme_for_student2 if appointment.student.course_id <15 && @college.code=='kskbjb'} #{appointment.student.course.programme_list}" ]
	       details2=[appointment.duration, "#{appointment.is_confirmed? ? (I18n.t('confirmed')) : (I18n.t('not_confirmed'))}"]
	       
	       if appointment.c_scope == "case" && !appointment.case_id.blank? 
                   if count==0   
		     if appointment.student_discipline_case.counselor_feedback.blank?
		       aa=[{content: "", rowspan: appointments.count}]
		     else
		       aa=[{content: I18n.t('student.counseling.session_complete'), rowspan: appointments.count}]
		     end
		   else
		     aa=[]
		   end
	       else
		 aa = [I18n.t('student.counseling.not_related')]
	       end
	       
	       if @college.code=='amsas'
		   body << ["#{counter+=1}"]+name_programme2+["#{appointment.is_confirmed? ?  appointment.confirmed_at.try(:getlocal).try(:strftime, '%d %b %y, %H:%M') :  appointment.requested_at.try(:getlocal).try(:strftime,'%d %b %y, %H:%M')}"]+details2+aa
	       else
		   body << ["#{counter+=1}"]+[appointment.student.matrixno]+name_programme2+[@view.strip_tags(Student.year_and_sem(appointment.student.intake))]+["#{ appointment.is_confirmed? ?  appointment.confirmed_at.try(:getlocal).try(:strftime, '%d %b %y, %l:%M %P') :  appointment.requested_at.try(:getlocal).try(:strftime,'%d %b %y, %l:%M %P')}"]+details2+aa
	       end
               count+=1
	     end
        end
    end #endof if @app...
    body << [{content: "", colspan: 7}]
    ##----
    body << [{content: I18n.t('student.counseling.sessions'), colspan: 7}]
    if @session_dones && @session_dones.count > 0    
        @session_dones_by_case.each do |case_id, session_dones|
            count2=0
            session_dones.each do |session_done| 
	        name_programme3=["#{session_done.student.student_with_rank} #{session_done.c_type == 'involuntary' ? '*' : ''}", "#{session_done.student.programme_for_student2 if session_done.student.course_id <15 && @college.code=='kskbjb'} #{session_done.student.course.programme_list}" ]
		details3=[session_done.duration, "#{session_done.is_confirmed? ? (I18n.t('confirmed')) : (I18n.t('not_confirmed'))}"]
		
		 if session_done.c_scope == "case" && !session_done.case_id.blank? && !session_done.student_discipline_case.nil?
		      if count2==0
			if session_done.student_discipline_case.counselor_feedback.blank?  
			  bb=[{content: "", rowspan: session_dones.count}]
			else
			  bb=[{content: I18n.t('student.counseling.session_complete'), rowspan: session_dones.count}]
			end
		      else
			bb=[]
		      end
		 else
		      bb = [I18n.t('student.counseling.not_related')]
		 end
		
                if @college.code=='amsas'
		   body << ["#{counter+=1}"]+name_programme3+[session_done.confirmed_at.try(:getlocal).try(:strftime,"%d %b %Y, %H:%M")]+details3+bb
		else
		    body << ["#{counter+=1}"]+[session_done.student.matrixno]+name_programme3+[@view.strip_tags(Student.year_and_sem(session_done.student.intake))]+[session_done.confirmed_at.try(:getlocal).try(:strftime,"%d %b %Y, %l:%M %P")]+details3+bb
		end
		count2+=1
            end
        end
    end
    
    header+body
  end #endof def
  
  def footer
    draw_text "#{page_number} / #{page_count}",  :size => 8, :at => [500,-5]
  end

end