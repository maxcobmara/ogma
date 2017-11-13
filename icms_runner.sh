#!/bin/bash -v
#set -o verbose
#rm .bundle/config
ps -ef |  grep -v grep | grep ruby && ps aux | grep -v grep | grep ruby | awk '{print $2}' | xargs kill -9;
pg_dump icms_demo_production > /Users/apmm/ICMS/database_backup/icms_demo_production_$(date +%d%b%Y_%H-%M-%S).dump
source ~/.rvm/scripts/rvm
git pull &&
RAILS_ENV=production bundle install &&
RAILS_ENV=production bundle exec rake db:migrate &&
bundle exec rake assets:precompile &&
rails s -p 3003 -e production -b 0.0.0.0

#d: git pull upstream amsas_demonstration
#p: git pull
