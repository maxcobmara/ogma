ActiveRecord::Base.establish_connection(:production)
#18Nov2016 - shall connect to production database as define in ogma/config/database.yml? but may also define ONE here (as shown in sample below):

#http://apidock.com/rails/ActiveRecord/ConnectionHandling/establish_connection

#sample
# ActiveRecord::Base.establish_connection(
#   adapter:  "mysql",
#   host:     "localhost",
#   username: "myuser",
#   password: "mypass",
#   database: "somedatabase"
# )

# NOTE - this file is read before setup_mail.rb (file naming rules applied)