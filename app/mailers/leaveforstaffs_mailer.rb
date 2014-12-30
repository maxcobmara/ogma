class LeaveforstaffsMailer < ActionMailer::Base
  default from: "icms.kskb.jb@gmail.com"
  
  def staff_leave_notification(leaveforstaff)
    @leaveforstaff = leaveforstaff   
    mail(to: @leaveforstaff.applicant.positions.first.parent.staff.coemail, subject: "Staff Leave Notification") do |format|
      format.html { render action: 'staff_leave_notification' }
      format.text { render action: 'staff_leave_notification' }
    end
  end
  
  def approve_leave_notification(leaveforstaff)
    @leaveforstaff = leaveforstaff
    mail(to: @leaveforstaff.applicant.positions.first.parent.parent.staff.coemail, subject: "Staff Leave Notification") do |format|
      format.html { render action: 'approval_leave_notification' }
      format.text { render action: 'approval_leave_notification' }
    end
  end
end
