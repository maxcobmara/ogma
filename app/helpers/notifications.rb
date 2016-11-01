module Notifications

 #use id if you do not require object relations
 def current_staff_id
  if is_staff?
   current_user.userable_id
  end
 end

 def current_staff
  if is_staff?
   current_user.userable
  end
 end
 
 def current_student_id
   if is_student?
     current_user.userable_id
   end
 end



 def leave_notifications
  my_first_level_approval  = Leaveforstaff.where(approval1_id: current_staff_id).where(approval1: nil).count
  my_second_level_approval = Leaveforstaff.where(approval1: true).where(approval2_id: current_staff_id).where(approver2: nil).count
  my_first_level_approval + my_second_level_approval
 end

 def my_leave_approvals
  Leaveforstaff.where(staff_id: current_staff_id).where(approval1: true).where(approval1: true).where("leavestartdate > ?", Date.today).pluck(:id, :leavestartdate)
 end

 def skts_endorse_ready
  StaffAppraisal.where(eval1_by: current_staff_id).where(is_skt_submit: true).where(is_skt_endorsed: nil).count
 end

 def skt_review_ready
  StaffAppraisal.where(eval1_by: current_staff_id).where(is_skt_pyd_report_done: true).where(skt_ppp_report: nil).count
 end

 def appraisal_requests
  me_as_ppp = StaffAppraisal.where(eval1_by: current_staff_id).where(is_submit_for_evaluation: true).where(is_submit_e2: nil).count
  me_as_ppk = StaffAppraisal.where(eval2_by: current_staff_id).where(is_submit_e2: true).where(is_complete: nil).count
  me_as_ppp + me_as_ppk
 end

 def late_require_approval
  StaffAttendance.where(approved_by: current_staff_id).where(is_approved: nil).count
 end

 def late_need_a_reason
  if current_staff.positions.exists?
   StaffAttendance.where(trigger: true).where(reason: nil).where(thumb_id: current_staff.thumb_id).count
  else
    0
  end
 end

 def travel_request_needs_approval
  TravelRequest.where(hod_id: current_staff_id).where(hod_accept: nil).count
 end

 def your_travel_approved
  TravelRequest.where(staff_id: current_staff_id).where(hod_accept: true).where('depart_at > ? AND depart_at <?', Date.today - 1.month, Date.today).pluck(:id, :depart_at)
 end

 def asset_with_defects
  AssetDefect.where(is_processed: nil).where(processed_by: nil).where('decision_by !=?', current_staff_id ).count
 end

 def defect_actions_for_approval
  AssetDefect.where(decision_by: current_staff_id).where(is_processed: true).where(decision: nil).count
 end

 def student_notification_of_leave
   Leaveforstudent.where(student_id: current_user.userable_id, approved: true, approved2: true).where('leave_startdate >=?', Date.tomorrow).order(leave_startdate: :asc).pluck(:leave_startdate) unless is_staff?
 end
 
 def staff_notifications_of_student_leave
   if is_staff?
     if current_user.roles.pluck(:id).include?(2) #administration
        a = Leaveforstudent.where("studentsubmit =? AND approved IS ? AND leave_startdate >=?", true, nil, Date.tomorrow)
        b = Leaveforstudent.where("studentsubmit =? AND approved2 IS ? AND leave_startdate >=?", true, nil, Date.tomorrow)
        leaveforstudents = (a + b).uniq
     else
       if current_user.roles.pluck(:id).include?(7) #warden
         if current_staff.positions.first.tasks_main.include?('Penyelaras Kumpulan')
           pending_applications = Leaveforstudent.pending_coordinator.map(&:id)
           leaveforstudents = Leaveforstudent.where('student_id IN(?) and id IN(?) and leave_startdate >=?', current_user.under_my_supervision, pending_applications, Date.tomorrow)  
         else #warden, but not a coordinator
           pending_applications = Leaveforstudent.pending_warden.map(&:id)
           leaveforstudents = Leaveforstudent.where('id IN(?) and leave_startdate >=?', pending_applications, Date.tomorrow)  
         end
       else 
         if current_user.roles.pluck(:id).include?(14) #lecturer
           pending_applications = Leaveforstudent.pending_coordinator.map(&:id)
           leaveforstudents = Leaveforstudent.where('student_id IN(?) and id IN(?) and leave_startdate >=?', current_user.under_my_supervision, pending_applications, Date.tomorrow)  
         end
       end
     end
   end
   leaveforstudents.count if leaveforstudents
 end 
 
 def ks_student_discipline
   StudentDisciplineCase.where('assigned_to=? AND assigned2_to is null', current_staff_id).where.not(status: 'Closed').count
 end
 
 def tphep_mentor_counselor_student_discipline
   StudentDisciplineCase.where('assigned2_to=? AND action is null', current_staff_id).where.not(status: 'Closed').count
 end
 
 def comandant_student_discipline
   StudentDisciplineCase.where(comandant_id: current_staff_id).where.not(status: 'Closed').count
 end
 
 def cc1staff_document
   #amsas only (creator --> Pengarah/Komandan..)
   Document.where(cc1staff_id: current_staff_id).where(cc2closed: [nil, false]).where(closed: [nil, false]).count
 end
 
 def recipient_document
   doc_circulates=Circulation.where(staff_id: current_staff_id).where(action_closed: [nil, false]).pluck(:document_id)
   if current_user.college.code=='amsas'
     Document.where(id: doc_circulates).where(cc2closed: true).where(closed: [nil, false]).count
   else
     Document.where(id: doc_circulates).where(cc1closed: true).where(closed: [nil, false]).count
   end
 end
 
 def checker_instructor_appraisal
   InstructorAppraisal.where(qc_sent: true).where(check_qc: current_staff_id).where(checked: [nil, false]).count
 end
 
 def owner_instructor_appraisal
   InstructorAppraisal.where(qc_sent: true).where(staff_id: current_staff_id).where(checked: true).count
 end
 
 def approver_booking_facility
   Bookingfacility.where(approver_id: current_staff_id).where(approval: [nil, false]).where('start_date >=?', Date.today).count
 end
 
 def officer_booking_facility
   # NOTE : require 1)staff to be the administor of location & 2)roles - 'facilities_administrator'
   # NOTE : 'approver_id2' - not define by 1st approver, but selection provided includes location's administrator & access granted by 'facilities administor' role (refer _tab_reservation_edit.html.haml)
   location_ids=Location.where(staffadmin_id: current_staff_id).pluck(:id)
   if current_user.roles.pluck(:authname).include?('facilities_administrator')
     Bookingfacility.where(location_id: location_ids).where(approval: true, approval2: [nil, false]).where('start_date >=?', Date.today).count
   else
     0
   end
 end
 
 def applicant_booking_facility
   Bookingfacility.where(staff_id: current_staff_id).where(approval: true).where(approval: true).where('start_date >=?', Date.today).count
 end
 
 def librarian_staff_late_library_books
   if current_user.roles.pluck(:authname).include?('librarian')
     Librarytransaction.where(ru_staff: true).where(returned: [nil, false]).where('returnduedate <?', Date.today).count
   else
     0
   end
 end
 
 def librarian_student_late_library_books
   if current_user.roles.pluck(:authname).include?('librarian')
     Librarytransaction.where(ru_staff: false).where(returned: [nil, false]).where('returnduedate <?', Date.today).count
   else
     0
   end
 end
 
 def borrower_staff_late_library_books
   Librarytransaction.where(staff_id: current_staff_id).where(returned: [nil, false]).where('returnduedate <?', Date.today).count
 end
 
  def borrower_student_late_library_books
    Librarytransaction.where(student_id: current_student_id).where(returned: [nil, false]).where('returnduedate <?', Date.today).count
  end

  def tenancy_admin_staff_late_keys_return
    location_ids=Location.where(staffadmin_id: current_staff_id).pluck(:id)
    Tenant.where(location_id: location_ids).where('keyexpectedreturn <? AND keyreturned is null', Date.today).where('staff_id is not null').count
  end
   
  def tenancy_admin_student_late_keys_return
    location_ids=Location.where(staffadmin_id: current_staff_id).pluck(:id)
    Tenant.where(location_id: location_ids).where('keyexpectedreturn <? AND keyreturned is null', Date.today).where('student_id is not null').count
  end
  
  def tenant_staff_late_keys_return
    Tenant.where(staff_id: current_staff_id).where('keyexpectedreturn <? AND keyreturned is null', Date.today).count
  end

  def tenant_student_late_keys_return
    Tenant.where(student_id: current_student_id).where('keyexpectedreturn <? AND keyreturned is null', Date.today).count
  end
  
  def approver_weeklytimetable
    Weeklytimetable.where(is_submitted: true).where(endorsed_by: current_staff_id).where(hod_approved: [nil, false]).count #where(startdate > Date.today).count
  end
  
  def creator_approved_weeklytimetable 
    Weeklytimetable.where(prepared_by: current_staff_id).where(hod_approved: true).count #where(startdate > Date.today).count
  end
  
  def creator_rejected_weeklytimetable 
    Weeklytimetable.where(prepared_by: current_staff_id).where(hod_rejected: true).count #where(startdate > Date.today).count
  end
  
  
end


=begin
<!-- Notification on Asset Defect -->

	<!-- Notification on Losses -->
	<% permitted_to? :manage, :assets do %>
	<%# if Login.current_login.staff.position.code == "1" %>
	<% loss_require_endorse = AssetLoss.count(:all, :conditions => ['is_submit_to_hod = ? AND endorsed_on IS ?', true, nil ]) %>
	<% if loss_require_endorse > 0 %>
		<%= link_to "#{loss_require_endorse} Asset Losses require verifying", { :controller => "asset_losses", :action => "index" } %><br/>
	<% end %>
	<%# end -%>
	<% end %>


	<!-- Notification on Asset Disposal -->
	<% disposal_require_verify = AssetDisposal.count(:all, :conditions => ['is_checked = ? AND is_verified = ? AND verified_by =?', true, true, Login.current_login.staff_id ]) %>
	<% if disposal_require_verify > 0 %>
		<%= link_to "#{disposal_require_verify} Asset Disposal require verifying", { :controller => "asset_disposals", :action => "index" } %><br/>
	<% end %>


	<!--Notification for Asset Loan-->

<% unless Login.current_login.staff.blank? %>
	<%#****special case for PA Pengarah%****%>
	<% if Login.current_login.staff.id != 101 %>
	<%#**************************************%>

	<% unless Login.current_login.staff.position.blank?  %><!--15Jul2013-added-->
	<%#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%><!--15Jul2013-added-->
	<!--25Apr2013-check if ANY OF logged-in unit members of DEPT/UNIT same as loaned_by(asset owner); HAVE request of asset loan that still pending-->
	<% hods = [6,7,8,9,10,11,12,13,14,15,16,17,18,19,25,26,27,28,29,30,31] %>
	<% logged_login_positionid=Login.current_login.staff.position.id %>
	<% assetloanrequest2=[]%>
	<% unless hods.include?(logged_login_positionid)%><!--NOT HOD-->
		<% unit_members=[]%>
		<% if current_login.staff.position.is_root? %>
		<% else %>
			<% superior = Position.find(:first,:conditions=>['staff_id=?',current_login.staff_id]).parent.staff_id %>
	  	<% end %>
		<% subordinates = Position.find(:first,:conditions=>['staff_id=?',current_login.staff_id]).siblings %>
	  	<% unit_members << superior if superior != nil %>
		<% subordinates.each do |x| %>
			<% unit_members << x.staff_id if x.staff_id !=nil %>
		<% end %><!--
		<%#=current_login.staff_id%>~
		<%#=unit_members %>-->

		<% 0.upto(unit_members.count-1) do |index|%>
			<% assetloanrequest3 = AssetLoan.count(:all, :conditions => ['loaned_by = ? AND is_approved IS NULL', unit_members[index]])%>
			<% if assetloanrequest3 > 0 %>
				<% assetloanrequest2 << assetloanrequest3 %>
			<% end %>
		<% end %>
		<% assetloanrequest2[0]=0 if assetloanrequest2[0].blank? %>
	<% else %>
		<% assetloanrequest2[0]=0%>
	<% end %>

	<!--25Apr2013-check if ANY OF logged-in unit members of DEPT/UNIT same as loaned_by(asset owner); HAVE request of asset loan that still pending-->

	<!--25Apr2013-to notify user for not yet return on-loan asset on due date (expected_on)-->
	<% assetloan_due = AssetLoan.count(:all, :conditions =>['is_approved IS true AND is_returned IS NULL AND staff_id=? AND expected_on<=?',Login.current_login.staff_id,Date.today])
	%>
	<% if assetloan_due > 0 %>
		<%= link_to "#{assetloan_due} Asset on loan due/overdue", { :controller => "asset_loans", :action => "index" } %><br/>
	<% end %>
	<!--25Apr2013-to notify user for not yet return on-loan asset on due date (expected_on)-->

	<!--25Apr2013-asset loan request for processing-->
	<% assetloanrequest = AssetLoan.count(:all, :conditions => ['loaned_by = ? AND is_approved IS NULL', Login.current_login.staff_id]) %>
	<% if assetloanrequest > 0 %>
		<%#= link_to "#{assetloanrequest} Asset Loan requests for approval", { :controller => "asset_loans", :action => "index" } %><br/>
	<% end %>
	<% if assetloanrequest2[0] > 0 && assetloanrequest==0 %>
	<!--assetloanrequest giving 0, when logged-in as OTHER unit member of loaned_by's unit/dept-->
		<%#= link_to "#{assetloanrequest2} Asset Loan requests for approval", { :controller => "asset_loans", :action => "index" } %><br/>
	<% end %>
	<!--25Apr2013-asset loan request for processing-->

	<!--25Apr2013-notify HOD on approval of asset loan regardless of loantype (internal or external) -->
	<% assetnotify_hod = AssetLoan.count(:all, :conditions=>['is_approved IS true AND is_returned IS NOT true AND hod=?',Login.current_login.staff_id]) %>
	<% if assetnotify_hod > 0 %>
		<% if Login.current_login.staff.position.root %>
			<%= link_to "#{assetnotify_hod} Asset Loan requests require your final approval", { :controller => "asset_loans", :action => "index" } %><br/>
		<% else %>
			<%= link_to "#{assetnotify_hod} Asset Loan requests approved for your information", { :controller => "asset_loans", :action => "index" } %><br/>
		<% end %>
	<% end %>
	<!--25Apr2013-notify HOD on approval of asset loan regardless of loantype (internal or external) -->

	<%#=AssetLoan.count(:all, :conditions=>['is_approved IS true AND is_returned IS NOT true AND hod=?',Login.current_login.staff_id])%><%#=current_login.staff_id%>


<% end %><!--end for unless Login.current_login.staff.blank?-->
	<%#****special case for PA Pengarah%****%>

	<% end %><!--15Jul2013-added-->
	<%#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%><!--15Jul2013-added-->

	<% end %>
	<%#**************************************%>


=end
