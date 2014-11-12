module Notifications

 #use id if you do not require object relations
 def current_staff_id
  if is_staff?
   current_user.userable_id
  end
 end

 def current_staff
  if is_staff?
   Staff.find(current_staff_id)
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


=end
