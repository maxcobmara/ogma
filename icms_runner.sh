#!/bin/bash -v
#set -o verbose
#rm .bundle/config
source ~/.rvm/scripts/rvm
git pull &&
RAILS_ENV=production bundle install &&
RAILS_ENV=production rake db:migrate &&
rake assets:precompile &&
rails s -p 3003 -e production -b 0.0.0.0
