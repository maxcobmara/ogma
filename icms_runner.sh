#!/bin/bash -v
#set -o verbose
#rm .bundle/config
ps -ef |  grep -v grep | grep ruby && ps aux | grep -v grep | grep ruby | awk '{print $2}' | xargs kill -9;
source ~/.rvm/scripts/rvm
git pull &&
RAILS_ENV=production bundle install &&
RAILS_ENV=production rake db:migrate &&
bundle exec rake assets:precompile &&
rails s -p 3003 -e production -b 0.0.0.0

#d: git pull upstream amsas_demonstration
#p: git pull
