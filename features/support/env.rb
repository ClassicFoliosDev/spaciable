# frozen_string_literal: true

require "cucumber/rails"

$LOAD_PATH.unshift("features/support")

ActionController::Base.allow_rescue = false

require "webmock/rspec"
require "module_importer.rb"
require "feature_application_actions"
require "webmock/cucumber"
require "database_cleaner_setup"
require "drivers_setup"
require "debugging_world"
require "spec_utilities"
require "goto_page"
require "sleeps"
require_relative "./../../spec/support/login_as"

World(
  SpecUtilities,
  Warden::Test::Helpers,
  LoginAs,
  GotoPage,
  DebuggingWorld,
  FactoryGirl::Syntax::Methods,
  WebMock::API,
  Sleeps
)

WebMock.disable_net_connect!(allow_localhost: true)
Warden.test_mode!
After { Warden.test_reset! }

