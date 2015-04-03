#!/bin/bash
source ~/.rvm/scripts/rvm
rvm use ruby-2.1.4@ogma4
git pull && bundle install --quiet && rake db:migrate && rake assets:precompile && rake db:test:prepare && rspec
