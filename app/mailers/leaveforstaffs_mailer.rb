class LeaveforstaffsMailer < ActionMailer::Base
  default from: "pustakabistari_kskbjb@yahoo.com"
  
  def staff_leave_notification(leaveforstaff)
    @leaveforstaff = leaveforstaff
    mail(to: "mustafakamalsaedon@gmail.com") do |format|
      format.html { render action: 'staff_leave_notification' }
      format.text { render action: 'staff_leave_notification' }
    end
  end
end
