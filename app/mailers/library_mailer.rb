class LibraryMailer < ActionMailer::Base
  default from: "pustakabistari_kskbjb@yahoo.com"
  
  def library_student_late_reminder(email, transactions)
    @transactions = transactions
    mail(:to => email, subject: "Late Return of Library Books")
  end
  
  def library_staff_late_reminder(email, transactions)
    @transactions = transactions
    mail(:to => email, subject: "Late Return of Library Books")
  end
end
