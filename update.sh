git pull && bundle install --quiet && rake db:migrate && rake assets:precompile && rake db:test:prepare && rspec
