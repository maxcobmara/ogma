source 'https://rubygems.org'
ruby '2.1.4'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.9'
gem "thin", "~> 1.6.3"
gem "devise", "~> 4.7.1"
gem 'declarative_authorization', '~> 0.5.7'
gem 'paperclip', '~> 4.2.0'
gem "ancestry", "~> 2.1.0"
gem "ransack", "~> 1.8.0"
#gem 'ransack', github: 'activerecord-hackery/ransack'#, branch: 'rails-4.1'
#gem 'ransack', :path=>'vendor/ransack', branch: 'rails-4.1'
gem "prawn", "~> 1.3.0"
gem 'prawn-table', '~> 0.2.1'
gem "chartkick", "~> 1.3.2"
gem 'country_select', '~> 2.1.0'
gem 'mailboxer', '~> 0.13.0'
gem 'sqlite3', '~> 1.3'
gem 'pg', '~> 0.17.1'



#stuff for layout
#gem "bootstrap-sass", "~> 3.0.3.0"
gem 'sass-rails', '~> 5.0', '>= 5.0.4'
gem 'uglifier', '~> 2.1.1'  # Use Uglifier as compressor for JavaScript assets
gem 'coffee-rails', '~> 4.0.0'  # Use CoffeeScript for .js.coffee assets and views
gem "jquery-ui-rails", "~> 4.1.1"
gem 'jquery-rails', '~> 3.1.0'  # Use jquery as the JavaScript library
gem 'turbolinks', '~> 1.1.1'  # Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
#gem 'jbuilder', '~> 1.2'  # Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "haml", "~> 5.0.0"
gem "kaminari", "~> 1.2.1"
gem "bootstrap-kaminari-views", "~> 0.0.3"
gem 'font-awesome-rails', '~> 4.3.0.0'
gem "bootstrap-datepicker-rails", "~> 1.3.0.1"
gem "bootstrap-switch-rails", "~> 2.0.2"
gem "modernizr-rails", "~> 2.6.2.3"
#gem "jquery-ui-bootstrap-rails", "~> 0.0.2"
gem "whenever", "~> 0.9.2", require: false
#gem 'rmagick', #, :git=>'http://github.com/rmagick/rmagick.git'
#gem 'rmagick', '2.13.2', :require => 'RMagick'
gem 'ruby_parser', '~> 3.6.3' #requirement for graphviz
gem "roo"
gem 'chosen-rails', '~> 1.4', '>= 1.4.3'




group :assets do
end

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

group :development do
  gem "quiet_assets", "~> 1.0.2"
  gem "seed_dump", "~> 3.1.0"
  gem "annotate", "~> 2.6.1"
end

group :development, :test do
  gem 'rspec-rails', '~> 3.0.1'
  gem 'guard-rspec', '~> 4.2.9'
  gem 'faker', '~> 1.9.1', '>= 1.9.1'

end

group :test do
  gem 'factory_girl_rails', '~> 4.4.1'
  gem "selenium-webdriver", "~> 2.42.0"
  gem 'capybara', '~> 2.3.0'
  gem 'growl', '1.0.3'
  gem "launchy", "~> 2.4.2"
  gem 'database_cleaner', '~> 1.3.0'
end

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

group :production do
  #gem 'pg', '~> 1.1'
  gem 'rails_12factor', '0.0.2'
  gem 'rack-cache', '~> 1.2'
  gem 'unicorn'
  gem 'capistrano'
  gem 'capistrano-rails', '~> 1.1'
  gem 'capistrano-rvm'
  gem 'capistrano-bundler'
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
