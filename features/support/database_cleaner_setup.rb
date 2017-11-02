# frozen_string_literal: true

DatabaseCleaner.strategy = :truncation
Cucumber::Rails::Database.javascript_strategy = :truncation

# Recommended by database cleaner README
# https://github.com/DatabaseCleaner/database_cleaner#rspec-with-capybara-example
Around do |_scenario, block|
  DatabaseCleaner.cleaning(&block)
end
