# frozen_string_literal: true
require "capybara/poltergeist"

Capybara.default_max_wait_time = 10
Capybara.javascript_driver = :poltergeist
Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, js_errors: false, window_size: [1600, 1200])
end

if ENV["DEBUG"] == "true"
  Capybara.register_driver :debug do |app|
    Capybara::Poltergeist::Driver.new(app, inspector: true, window_size: [1600, 1200])
  end
  Capybara.javascript_driver = :debug
end
