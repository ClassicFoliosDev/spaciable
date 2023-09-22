# frozen_string_literal: true

source "https://rubygems.org"

ruby "2.7.8"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem "rails", "~> 5.2.0", ">= 5.0.0.1"
# Use postgresql as the database for Active Record
gem "pg", "~> 0.18"
# Use Puma as the app server
gem "puma", "~> 3.10"
# Use SCSS for stylesheets
gem "sass-rails", "~> 5.0"
# Use Uglifier as compressor for JavaScript assets
gem "uglifier", ">= 1.3.0"
# Use CoffeeScript for .coffee assets and views
# gem "coffee-rails", "~> 4.2"
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Generate digest and non-digest assets (whitelisted)
gem "non-stupid-digest-assets"

# Use jquery as the JavaScript library
gem "jquery-rails"

# Use jQuery UI for widgets
gem "jquery-ui-rails"

# jQuery library for multi-select
gem "rails-assets-select2", source: "https://rails-assets.org"

# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem "turbolinks", "~> 5"
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
gem "bcrypt", "~> 3.1.12", platforms: %i[ruby x64_mingw mingw]

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Forms
gem "ckeditor", "< 5.0"
gem "simple_form", "~>4.0"
# Validation for phone numbers
gem "phonelib"
# Date/Time input cross-browser support
gem "flatpickr"

gem "cancancan", "~> 2"
gem "gretel" # breadcrumbs

# File Uploads
gem "carrierwave"
gem "carrierwave-aws", "~> 1.3"
gem "fog-aws"
gem "mini_magick", "~> 4.9"

# File share
gem "wetransfer", "~> 0.9.0.beta2"

# Authentication
gem "devise", "~> 4.4.2"
gem "devise_invitable", "~> 1.7.0"

# Rollbar for exception monitoring, see https://rollbar.com/alliants/Hoozzi/#rails
gem "rollbar"

# New relic for performance monitoring, logging, and auditing
# see https://rpm.newrelic.com
gem "newrelic_rpm"

# Frontend
gem "bourbon"
gem "font-awesome-rails", "~> 4.7.0.5"
gem "font-awesome-sass", "~> 5.12.0"
gem "introjs-rails"
gem "neat", "~> 1"
gem "rails-timeago"
gem "simple_calendar", "~> 2.0"

# Pagination with kaminari: https://github.com/amatsuda/kaminari
gem "kaminari"

# Soft Delete
# gem "paranoia", "~>2.4.3" ,branch: 'core',  git: "https://github.com/rubysherpas/paranoia.git"
gem "paranoia", "~> 2.0"

# Background Jobs
gem "carrierwave_backgrounder"
gem "daemons", "~> 1.2"
gem "delayed_job_active_record", "~> 4.1.3"
gem "whenever", "~> 0.10.0"

# Process management
gem "activerecord-session_store", "~>1.1.3" # Store session data to avoid cookie cache overflow
gem "foreman" # configuration in the Procfile

# APIs
gem "gibbon", "~> 3" # Mailchimp API wrapper

# Postgres search helper
gem "pg_search"

# Help with deep cloning
gem "amoeba"

# EU Cookie pop-up
gem "cookies_eu", "~> 1.6"

# make http requests
gem "httparty"

# OAuth2 authorization
gem "oauth2"

# Zoho API
gem "ZCRMSDK", ">= 1.0.1"

# thread safe global variable store
gem "request_store"

# Copy carrierwave images
gem "copy_carrierwave_file"

# Analytics
gem "ahoy_matey"

# full callendar
gem "fullcalendar-rails"
gem "icalendar"
gem "momentjs-rails"

# salesforce
gem "restforce", "<= 3.2.0"

# Natural sort
gem "naturalsort"

gem "stripe", ">= 8.0"

# OAuth2
# git "https://github.com/ClassicFoliosDev/spaciable-doorkeeper.git", branch: "master" do
# end
# gem "doorkeeper", "<= 5.0.3"
gem "doorkeeper", git: "https://github.com/ClassicFoliosDev/spaciable-doorkeeper.git", tag: "v6.0"

gem "rack-cors"

gem "dotenv-rails", "~> 2.8"

group :development, :test, :qa, :staging do
  # populate the environments with data from factories
  gem "email_spec"
  gem "factory_girl_rails"
  gem "faker"
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem "brakeman", require: false
  gem "byebug", platform: %i[mri mingw x64_mingw]
  gem "pry-rails"
  gem "rails_best_practices", "~> 1.17", require: false
  gem "rubocop", "~> 0.71"
  gem "rubocop-rails", "~> 2.0.0"
end

group :development do
  # View Emails Locally
  gem "letter_opener"

  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem "listen", "~> 3.0.5"
  gem "web-console"
  # Spring speeds up development by keeping your application
  # running in the background.
  # Read more: https://github.com/rails/spring
  gem "guard"
  gem "guard-rake"
  gem "guard-sass", require: false
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"

  gem "wdm", ">= 0.1.0" if Gem.win_platform?
end

group :development, :qa do
  # Bullet for analysing DB queries, see https://github.com/flyerhzm/bullet
  gem "bullet"
end

group :test do
  gem "capybara"
  gem "codeclimate-test-reporter", "~> 0.6"
  gem "cucumber-rails", "~>2.0.0", require: false
  gem "database_cleaner", "~>1.6.0"
  gem "launchy"
  gem "rspec-rails"
  gem "simplecov", "~> 0.12", require: false
  gem "timecop"
  gem "webmock", "~> 3.5.0"
  # Headless browser, see https://github.com/teampoltergeist/poltergeist
  gem "poltergeist"
  gem "rails-controller-testing"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]
