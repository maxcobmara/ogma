class LeaveforstaffsMailer < ActionMailer::Base
  default from: "pustakabistari_kskbjb@yahoo.com"
  
  def staff_leave_notification(email, transactions)
    @transactions = transactions
    mail(:to => email, subject: "Late Return of Library Books")
  end
  
end
