class LeaveforstaffsMailer < ActionMailer::Base
  
  default from: College.where(code: Page.find(1).college.code).first.library_email #ENV["GMAIL_USERNAME"]
  
  def support_approve_leave_notification(leaveforstaff, ahost, view)
    apage=leaveforstaff.approval1==true ? "processing_level_2" : "processing_level_1"
    arecipient=College.where(code: Page.find(1).college.code).first.library_email
    asubject=leaveforstaff.approval1==true ? I18n.t('staff_leave.mailer.approval_subject') : I18n.t('staff_leave.mailer.support_subject')
    #arecipient=@leaveforstaff.approval1==true ? @leaveforstaff.approver.coemail : @leaveforstaff.seconder.coemail
    @leaveforstaff = leaveforstaff
    @view=view
    @url = "http://#{ahost}:3003/staff/leaveforstaffs/#{leaveforstaff.id}/#{apage}?locale=#{I18n.locale}"
    mail(to: arecipient, subject: asubject) 
  end
  
  def successfull_leave_notification(leaveforstaff, ahost, view)
    arecipient=College.where(code: Page.find(1).college.code).first.library_email
    #arecipient=@leaveforstaff.applicant.coemail
    @leaveforstaff = leaveforstaff
    @view=view
    @url = "http://#{ahost}:3003/staff/leaveforstaffs/#{leaveforstaff.id}?locale=#{I18n.locale}"
    @final=leaveforstaff.final_status
    mail(to: arecipient, subject: "#{I18n.t('staff_leave.mailer.final_subject')} #{@final.downcase}") 
  end
  
end
