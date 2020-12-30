# frozen_string_literal: true

module Api
  class Controller < ActionController::Base
    before_action :doorkeeper_authorize!
    before_action :sign_user_in
    respond_to :json

    private

    def sign_user_in
      sign_in(User.find(doorkeeper_token.resource_owner_id))
      RequestStore.store[:current_user] = current_user
    end
  end
end
