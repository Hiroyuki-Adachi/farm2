source 'http://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 8.0'
# Use postgresql as the database for Active Record
gem 'pg'
# delayed_job (or DJ) encapsulates the common pattern of asynchronously executing longer tasks in the background.
gem 'delayed_job_active_record'

# The CSV library provides a complete interface to CSV files and data. 
gem 'csv'

# CSSBundling provides a way to bundle CSS files in Rails applications.
gem "cssbundling-rails"
# importmap-rails provides a way to bundle JavaScript files in Rails applications.
gem 'importmap-rails'
# propshaft provides a way to bundle JavaScript files in Rails applications.
gem 'propshaft'
# Use stimulus for JavaScript
gem 'stimulus-rails'

# daemons provides an easy way to wrap existing ruby scripts (for example a self-written server) to be run as a daemon and to be controlled by simple start/stop/restart commands.
gem 'daemons'

# Japanese Holiday
gem 'holiday_jp'

# In the Loofah gem for Ruby through v2.3.0 unsanitized JavaScript may occur in sanitized output when a crafted SVG element is republished.
gem "loofah", ">= 2.3.1"

# Japanese Era
gem 'wareki'

# Nokogiri is an HTML, XML, SAX, and Reader parser.
gem 'nokogiri'
# mechanize is a ruby library that makes automated web interaction easy.
gem 'mechanize'
# dotenv is a Ruby gem to load environment variables from .env into ENV in development.
gem 'dotenv-rails'

# turbo-rails is a set of tools for building modern web applications with Turbo.
gem 'turbo-rails'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'
# This gem provides XML serialization for your Active Model objects and Active Record models.
gem 'activemodel-serializers-xml'
# ActiveHash is a simple base class that allows you to use a ruby hash as a readonly datasource for an ActiveRecord-like model.
gem 'active_hash'
# TZInfo::Data is the public domain IANA Time Zone Database packaged as a set of Ruby modules for use with TZInfo.
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw]
# Logical deletion for ActiveRecord. Documentation: https://github.com/jhawthorn/discard
gem 'discard'
# A paginator for modern web app frameworks and ORMs
gem 'kaminari'
# Draper adds an object-oriented layer of presentation logic to your Rails application.
gem 'draper'
# A simple and efficient way to handle file uploads in your Rails application.
gem 'lograge'

# Encoding QR Codes in Ruby.
gem 'rqrcode'
# Read and write PNG files.
gem 'chunky_png'

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

# This gem supports operating on xlsx files (Open XML format).
gem 'rubyXL'

# Ruby library for dealing with iCalendar files
gem 'icalendar'

# Use Puma as the app server
gem 'puma'

# Rubyzip is a ruby library for reading and writing zip files.
gem 'rubyzip'

# Clean ruby syntax for writing and deploying cron jobs.
gem 'whenever', require: false

# omniauth is a generalized Rack framework for multiple-provider authentication.
gem 'omniauth'
# OmniAuth strategy for Google OAuth2
gem 'omniauth-google-oauth2'

# Reduces the size of your HTML output by removing unnecessary whitespace and comments.
gem "commonmarker"
# Rouge is a pure-ruby syntax highlighter.
gem "rouge"

group :development, :test do
  gem 'ruby-lsp'
  # Debugging tool
  gem 'debug'
end

group :development do
  # listen to file modifications
  gem 'listen'
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 4.0'
  # Add a comment summarizing the current schema to the top or bottom of each informations.
  gem 'annotaterb'
  # RuboCop is a Ruby static code analyzer.
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

group :test do
  # capybara helps you test web applications by simulating how a real user would interact with your app.
  gem 'capybara'
  # cuprite is a Capybara driver for headless Chrome/Chromium
  gem 'cuprite', '0.15.1'
  # minitest is a complete suite of testing facilities supporting TDD, BDD, mocking, and benchmarking.
  gem 'mocha'
  # minitest-rails provides a set of Rails generators for Minitest.
  gem 'webmock'
end
