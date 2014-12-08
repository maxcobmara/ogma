require "rails_helper"

RSpec.describe LeaveforstaffsMailer, :type => :mailer do
  describe "staff_leave_notification" do
    let(:mail) { LeaveforstaffsMailer.staff_leave_notification }

    it "renders the headers" do
      expect(mail.subject).to eq("Staff leave notification")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
