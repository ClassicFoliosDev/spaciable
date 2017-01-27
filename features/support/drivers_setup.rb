# frozen_string_literal: true
require "capybara/poltergeist"

Capybara.javascript_driver = :poltergeist
Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, js_errors: false)
end

if ENV["DEBUG"] == "true"
  Capybara.register_driver :debug do |app|
    Capybara::Poltergeist::Driver.new(app, inspector: true)
  end
  Capybara.javascript_driver = :debug
end
