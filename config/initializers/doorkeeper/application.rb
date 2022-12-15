# frozen_string_literal: true

module Doorkeeper
  class Application < ActiveRecord::Base
  	has_one :app_user, class_name: '::User', foreign_key: 'oauth_applications_id'
  end
end