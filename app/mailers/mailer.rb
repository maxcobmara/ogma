class Mailer < ActionMailer::Base
  default from: "from@example.com"
  
  def library_student_late_reminder(student)
    mail(:to => student.email, subject: "Late Return of Library Books")
  end
  
  def library_staff_late_reminder(staff)
    mail(:to => student.email, subject: "Late Return of Library Books")
  end
end
