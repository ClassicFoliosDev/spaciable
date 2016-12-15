require "capybara/poltergeist"

Capybara.javascript_driver = :poltergeist

if ENV["DEBUG"] == "true"
  Capybara.register_driver :debug do |app|
    Capybara::Poltergeist::Driver.new(app, inspector: true)
  end
  Capybara.javascript_driver = :debug
end
