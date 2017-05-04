class LibraryMailer < ActionMailer::Base
  #default from: "pustakabistari_kskbjb@yahoo.com"
  
  default from: College.where(code: Page.find(1).college.code).first.library_email #ENV["GMAIL_USERNAME"]
  
  def library_student_late_reminder(email, transactions)
    @transactions = transactions
    mail(:to => email, subject: "Late Return of Library Books")
  end
  
  def library_staff_late_reminder(email, transactions)
    @transactions = transactions
    mail(:to => email, subject: "Late Return of Library Books")
  end
  
  def library_visitor_late_reminder(email, transactions)
    @transactions = transactions
    mail(:to => email, subject: "Late Return of Library Marine Documentation")
  end
  
end
