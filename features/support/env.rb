# frozen_string_literal: true
require "cucumber/rails"

$LOAD_PATH.unshift("features/support")

ActionController::Base.allow_rescue = false

require "feature_application_actions"
require "webmock/cucumber"
require 'database_cleaner_setup'
require 'drivers_setup'
require 'hoozzi_world'

Dir[Rails.root.join("features/support/fixtures/*.rb")].each { |f| require f }

World(
  HoozziWorld,
  Warden::Test::Helpers,
  FactoryGirl::Syntax::Methods,
  WebMock::API
)

WebMock.disable_net_connect!(allow_localhost: true)
Warden.test_mode!
After { Warden.test_reset! }
