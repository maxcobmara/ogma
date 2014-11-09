module Notifications

 #staff_leave
 def current_staff
  if is_staff?
   current_user.userable_id
  end
 end

 def leave_notifications
  my_first_level_approval  = Leaveforstaff.where(approval1_id: current_staff).where(approval1: nil).count
  my_second_level_approval = Leaveforstaff.where(approval1: true).where(approval2_id: current_staff).where(approver2: nil).count
  my_first_level_approval + my_second_level_approval
 end

 def blah
 end


end
