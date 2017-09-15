class LeaveforstaffsMailer < ActionMailer::Base
  
  default from: College.where(code: Page.find(1).college.code).first.library_email #ENV["GMAIL_USERNAME"]
  
  def support_approve_leave_notification(leaveforstaff, ahost, view)
    apage=@leaveforstaff.approval1==true ? "processing_level_2" : "processing_level_1"
    arecipient=College.where(code: Page.find(1).college.code).first.library_email
    #arecipient=@leaveforstaff.approval1==true ? @leaveforstaff.approver.coemail : @leaveforstaff.seconder.coemail
    @leaveforstaff = leaveforstaff
    @view=view
    @url = "http://#{ahost}:3003/staff/leaveforstaffs/#{leaveforstaff.id}/#{apage}?locale=#{I18n.locale}"
    mail(to: arecipient, subject: I18n.t('staff_leave.approval_subject')) 
  end
  
  def successfull_leave_notification(leaveforstaff, ahost, view)
    arecipient=College.where(code: Page.find(1).college.code).first.library_email
    #arecipient=@leaveforstaff.applicant.coemail
    @leaveforstaff = leaveforstaff
    @view=view
    @url = "http://#{ahost}:3003/staff/leaveforstaffs/#{leaveforstaff.id}?locale=#{I18n.locale}"
    mail(to: arecipient, subject: I18n.t('staff_leave.successful_subject')) 
  end
  
   # TODO - 3)raise error when network not avai? / cannot send email (like amsas - last visit)
  
end
