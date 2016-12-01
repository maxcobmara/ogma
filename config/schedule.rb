# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
set :environment, 'production' #'development' 
# NOTE - previously tested OK, when time zone @ linode svr is using UTC
# zone=Time.now.zone
# if zone=="MYT"
#   delivery_time="5:00 AM"
#   logclear_time='12am'
# else
#   delivery_time="9:00 PM" #UTC
#   logclear_time="4:00 AM"
# end

# TODO - check again tomorrow - 2Dec2016
# NOTE - time zone @ linode svr is set to MYT (Thu Dec  1 09:22:42 MYT 2016)
delivery_time="5:00 AM"
logclear_time='12am'

every 1.day, at: delivery_time do #"5:00 AM"
  rake "library:all"
end

every :saturday, :at => logclear_time do #'12am' do
  rake "log:clear"
end
