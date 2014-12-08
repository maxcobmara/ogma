class LeaveforstaffsMailer < ActionMailer::Base
  default from: "pustakabistari_kskbjb@yahoo.com"
  
  def staff_leave_notification(leaveforstaff)
    @leaveforstaff = leaveforstaff
    @url = 'http://localhost:3000/staff/leaveforstaffs/19/processing_level_1?locale=ms_MY'
    mail(to: @leaveforstaff.applicant.positions.first.parent.staff.coemail, subject: "Staff Leave Notification") do |format|
      format.html { render action: 'staff_leave_notification' }
      format.text { render action: 'staff_leave_notification' }
    end
  end
  
  def approve_leave_notification(leaveforstaff,applicant)
    @leaveforstaff = leaveforstaff
    @url = 'http://localhost:3000/staff/leaveforstaffs/19/processing_level_1?locale=ms_MY'
    mail(to:  @leaveforstaff.applicant.coemail ) do |format|
      format.html { render action: 'staff_leave_notification' }
      format.text { render action: 'staff_leave_notification' }
    end
  end
end
