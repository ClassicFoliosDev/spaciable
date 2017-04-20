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

# Generate digest and non-digest assets (whitelisted)
gem "non-stupid-digest-assets"

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
gem "ckeditor"
gem "simple_form"

gem "cancancan", "~> 1"
gem "gretel" # breadcrumbs

# File Uploads
gem "carrierwave"
gem "fog-aws"
gem "mini_magick"
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
gem "bourbon"
gem "font-awesome-rails"
gem "livingstyleguide", git: "https://github.com/Alliants/livingstyleguide.git", branch: "rails_5"
gem "neat", "~> 1"

# Pagination with kaminari: https://github.com/amatsuda/kaminari
gem "kaminari"
gem "ransack"

# Soft Delete
gem "paranoia", branch: "rails5", git: "https://github.com/rubysherpas/paranoia.git"

# Background Jobs
gem "sidekiq", "~> 4.2"
gem "carrierwave_backgrounder"

# Process management
gem "foreman" # configuration in the Procfile

group :development, :test, :qa, :staging do
  # populate the environments with data from factories
  gem "factory_girl_rails"
  gem "faker"
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem "brakeman", require: false
  gem "byebug", platform: :mri
  gem "pry-rails"
  gem "rails_best_practices", "~> 1.17", require: false
  gem "rubocop", "~> 0.43"
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
end

group :development, :qa do
  # Bullet for analysing DB queries, see https://github.com/flyerhzm/bullet
  gem "bullet"
end

group :test do
  gem "codeclimate-test-reporter", "~> 0.6"
  gem "cucumber-rails", require: false
  gem "database_cleaner"
  gem "launchy"
  gem "rspec-rails"
  gem "simplecov", "~> 0.12", require: false
  gem "timecop"
  gem "webmock"
  # Headless browser, see https://github.com/teampoltergeist/poltergeist
  gem "poltergeist"
  gem "rails-controller-testing"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
