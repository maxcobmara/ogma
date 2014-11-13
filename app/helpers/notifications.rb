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
  end
 end

 def travel_request_needs_approval
  TravelRequest.where(hod_id: current_staff_id).where(hod_accept: nil).count
 end

 def your_travel_approved
  TravelRequest.where(staff_id: current_staff_id).where(hod_accept: true).where('depart_at > ? AND depart_at <?', Date.today - 1.month, Date.today).pluck(:id, :depart_at)
 end



end


=begin
<!-- Notification on Asset Defect -->

	<% asset_with_defects = AssetDefect.count(:all, :conditions => ['is_processed IS ? AND processed_by IS ? AND decision_by !=?', nil, nil, Login.current_login.staff_id ]) %>
	<% if asset_with_defects > 0 %>
		<%= link_to "#{asset_with_defects} Defect reports require processing", { :controller => "asset_defects", :action => "index" } %><br/>
	<% end %>

	<% defect_action_for_approval = AssetDefect.count(:all, :conditions => ['is_processed = ? AND decision_by =? AND decision IS ?', true, Login.current_login.staff_id, nil]) %>
	<% if defect_action_for_approval > 0 %>
		<%= link_to "#{defect_action_for_approval} Defect reports for decision", { :controller => "asset_defects", :action => "index" } %><br/>
	<% end %>

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
