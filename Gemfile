# frozen_string_literal: true
source "https://rubygems.org"

ruby "2.3.1"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem "rails", "~> 5.0.0", ">= 5.0.0.1"
# Use postgresql as the database for Active Record
gem "pg", "~> 0.18"
# Use Puma as the app server
gem "puma", "~> 3.0"
# Use SCSS for stylesheets
gem "sass-rails", "~> 5.0"
# Use Uglifier as compressor for JavaScript assets
gem "uglifier", ">= 1.3.0"
# Use CoffeeScript for .coffee assets and views
# gem "coffee-rails", "~> 4.2"
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem "jquery-rails"

# Use jQuery UI for widgets
gem "jquery-ui-rails"

# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem "turbolinks", "~> 5"
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Forms
gem "simple_form"
gem "ckeditor"

gem "cancancan", "~> 1"
gem "gretel" # breadcrumbs

# File Uploads
gem "carrierwave"
gem "carrierwave_backgrounder"
gem "mini_magick"
gem "fog-aws"
gem "rmagick"

# Authentication
gem "devise", "~> 4.2"
gem "devise_invitable", "~> 1.7.0"

# Rollbar for exception monitoring, see https://rollbar.com/alliants/Hoozzi/#rails
gem "rollbar"

# New relic for performance monitoring, logging, and auditing
# see https://rpm.newrelic.com
gem "newrelic_rpm"

# Frontend
gem "font-awesome-rails"
gem "livingstyleguide", git: "https://github.com/Alliants/livingstyleguide.git", branch: "rails_5"
gem "bourbon"
gem "neat", "~> 1"

# Pagination with kaminari: https://github.com/amatsuda/kaminari
gem "kaminari"

# Soft Delete
gem "paranoia", branch: "rails5", git: "https://github.com/rubysherpas/paranoia.git"

# Background Jobs
gem "sucker_punch", "~> 2.0"

group :development, :test, :qa, :staging do
  # populate the environments with data from factories
  gem "factory_girl_rails"
  gem "faker"
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem "byebug", platform: :mri
  gem "pry-rails"
  gem "rubocop"
  gem "rails_best_practices", require: false
  gem "brakeman", require: false
end

group :development do
  # View Emails Locally
  gem "letter_opener"

  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem "web-console"
  gem "listen", "~> 3.0.5"
  # Spring speeds up development by keeping your application
  # running in the background.
  # Read more: https://github.com/rails/spring
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "guard"
  gem "guard-rake"
  gem "guard-sass", require: false
end

group :development, :qa do
  # Bullet for analysing DB queries, see https://github.com/flyerhzm/bullet
  gem "bullet"
end

group :test do
  gem "codeclimate-test-reporter"
  gem "cucumber-rails", require: false
  gem "database_cleaner"
  gem "rspec-rails"
  gem "simplecov", require: false
  gem "timecop"
  gem "webmock"
  gem "launchy"
  # Headless browser, see https://github.com/teampoltergeist/poltergeist
  gem "poltergeist"
  gem "rails-controller-testing"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
