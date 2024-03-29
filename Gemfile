source 'http://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '>= 7.1'
# Use postgresql as the database for Active Record
gem 'pg'
# Use SCSS for stylesheets
# gem 'sassc-rails'
# Use Uglifier as compressor for JavaScript assets
# gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
# gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby
# gem "mini_racer"

gem 'delayed_job_active_record'

#gem 'webpacker'

gem 'importmap-rails'
gem 'propshaft'
gem "cssbundling-rails"

gem 'daemons'

# Use bootstrap4
# gem 'bootstrap', '>= 4.0'
# Japan Holiday
gem 'holiday_jp', :git => 'https://github.com/holiday-jp/holiday_jp-ruby.git'

# In the Loofah gem for Ruby through v2.3.0 unsanitized JavaScript may occur in sanitized output when a crafted SVG element is republished.
gem "loofah", ">= 2.3.1"

# gem 'bootsnap'

gem 'wareki'

# Use jquery as the JavaScript library
# gem 'jquery-ui-rails', '~> 5.0'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbo-rails'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
# gem 'sdoc', '~> 0.4.0', group: :doc
# Internationalization and localization solution
gem 'i18n-js', '~> 3'
# This gem provides XML serialization for your Active Model objects and Active Record models.
gem 'activemodel-serializers-xml'
# ActiveHash is a simple base class that allows you to use a ruby hash as a readonly datasource for an ActiveRecord-like model.
gem 'active_hash', :git => 'https://github.com/gazayas/active_hash.git'
# TZInfo::Data is the public domain IANA Time Zone Database packaged as a set of Ruby modules for use with TZInfo.
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw]
# Paranoia is a re-implementation of acts_as_paranoid for Rails 3/4/5.
gem 'paranoia'
# A paginator for modern web app frameworks and ORMs
gem 'kaminari'
# Draper adds an object-oriented layer of presentation logic to your Rails application.
gem 'draper'
# ActiveRecords infamously doesn't support composite primary keys.
# gem 'composite_primary_keys'
# Comments for migrations
# gem 'migration_comments'

# Library for encoding QR Codes in Ruby.
gem 'rqrcode'
# Read and write PNG files.
gem 'chunky_png'

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

# This gem supports operating on xlsx files (Open XML format).
gem 'rubyXL'

# Ruby library for dealing with iCalendar files
gem 'icalendar'
# Integrate Chart.js into Rails Asset Pipeline
# gem 'chart-js-rails'
# Use Unicorn as the app server
# gem 'unicorn'

# Use Puma as the app server
gem 'puma'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  # gem 'byebug'
  # debase is a fast implementation of the standard Ruby debugger debug.rb for Ruby 2.0
  # gem 'debase'
  # An interface which glues ruby-debug to IDEs
  # gem 'ruby-debug-ide', '~> 0.6'

  #gem 'pry-byebug'
  #gem 'pry-doc'
  #gem 'pry-rails'
  #gem 'pry-stack_explorer'
end

group :development do
  gem 'listen'
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 4.0'
  # Add a comment summarizing the current schema to the top or bottom of each informations.
  gem 'annotate'
  # RuboCop is a Ruby static code analyzer.
  gem 'rubocop', require: false

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  gem 'debug'
end

group :test do
  # This gem is only useful once assigns and assert_template have been removed from Rails.
  gem 'rails-controller-testing'
end

