require "spec_helper"

RSpec.describe LeaveforstaffsMailer, :type => :mailer do
#   describe "staff_leave_notification" do
#     let(:mail) { LeaveforstaffsMailer.staff_leave_notification }
# 
#     it "renders the headers" do
#       expect(mail.subject).to eq("Staff leave notification")
#       expect(mail.to).to eq(["to@example.org"])
#       expect(mail.from).to eq(["from@example.com"])
#     end
# 
#     it "renders the body" do
#       expect(mail.body.encoded).to match("Hi")
#     end
#   end
  before(:each) do
    leaveforstaff = assign(:leaveforstaff, Leaveforstaff.create!(
      :staff_id => 1,
      :leavetype => 1,
      :college_id => 1,
      :leavestartdate => "2017-10-21 08:00",
      :leavenddate => "2017-10-22 08:00",                                                        
      :data => {}))
  end
  
#   #####
#   association :applicant, factory: :basic_staff
#     association :replacement, factory: :basic_staff
#     association :seconder, factory: :basic_staff
#     association :approver, factory: :basic_staff
#     association :college, factory: :college
#     leavetype 1
#     leavestartdate {Date.today.tomorrow+(366*rand()).to_f}
#     leaveenddate {Date.today+2.days+(366*rand()).to_f}
#     leavedays 1.0
#     reason "Some reason"
#     notes "Some notes"
#     submit {rand(2)==1}
#     approval1 {rand(2)==1}
#     approval1date {Date.today+(366*rand()).to_f}
#     approver2 {rand(2)==1}
#     approval2date {Date.today+(366*rand()).to_f}
#     data {{}}
#     address_on_leave "Some address"
#     phone_on_leave (0...12).map {rand(10).to_s}.join
#   #####
  
  describe "support_approve_leave_notification" do
    let(:mail) { LeaveforstaffsMailer.support_approve_leave_notification(leaveforstaff, ahost, view)}

    it "renders the headers" do
      #expect(mail.subject).to eq("Staff leave notification")
      #asubject=leaveforstaff.approval1==true ? I18n.t('staff_leave.mailer.approval_subject') : I18n.t('staff_leave.mailer.support_subject')
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("#{I18n.t('staff_leave.mailer.apply_for_leave')}")
    end
  end
  
   describe "successfull_leave_notification" do
    let(:mail) { LeaveforstaffsMailer.successfull_leave_notification(leaveforstaff, ahost, view) }

    it "renders the headers" do
      expect(mail.subject).to eq("#{I18n.t('staff_leave.mailer.final_subject')}")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to 
      match("#{I18n.t('staff_leave.application_status')}")
    end
  end

end

# support_approve_leave_notification
# successfull_leave_notification
