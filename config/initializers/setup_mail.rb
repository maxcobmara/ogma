ActionMailer::Base.smtp_settings = {
#   :address              => "smtp.gmail.com",
#   :port                 => 587,
#   :domain               => "gmail.com",
#   :user_name            => "icms.kskb.jb@gmail.com",   #College.where(code: 'kskbjb').first.library_email
#   :password             => "Maslinda",                            #College.where(code: 'kskbjb').first.library_pwd
#   :authentication       => :plain,
#   :enable_starttls_auto => true
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :domain               => "gmail.com",
  :user_name => College.where(code: Page.find(1).college.code).first.library_email, #ENV["GMAIL_USERNAME"], 
  :password => College.where(code: Page.find(1).college.code).first.library_pwd, #ENV["GMAIL_PASSWORD"],
  :authentication       => :plain,
  :enable_starttls_auto => true
}