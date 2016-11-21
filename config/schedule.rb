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
zone=Time.now.zone
if zone=="MYT"
  delivery_time="5:00 AM"
  logclear_time='12am'
else
  delivery_time="9:00 PM" #UTC
  logclear_time="4:00 AM"
end

every 1.day, at: delivery_time do #"5:00 AM"
  rake "library:all"
end

every :saturday, :at => logclear_time do #'12am' do
  rake "log:clear"
end
