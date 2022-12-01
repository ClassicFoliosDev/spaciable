# frozen_string_literal: true

module Doorkeeper
  class AccessToken < ActiveRecord::Base
  	delegate :app_user, to: :application
  end
end
