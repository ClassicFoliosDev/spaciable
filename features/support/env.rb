# frozen_string_literal: true
require "cucumber/rails"

$LOAD_PATH.unshift("features/support")

ActionController::Base.allow_rescue = false

require "module_importer.rb"
require "feature_application_actions"
require "webmock/cucumber"
require "database_cleaner_setup"
require "drivers_setup"
require "debugging_world"
require "hoozzi_world"
require "goto_page"

World(
  HoozziWorld,
  GotoPage,
  DebuggingWorld,
  Warden::Test::Helpers,
  FactoryGirl::Syntax::Methods,
  WebMock::API
)

WebMock.disable_net_connect!(allow_localhost: true)
Warden.test_mode!
After { Warden.test_reset! }
