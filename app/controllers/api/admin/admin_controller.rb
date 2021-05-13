# frozen_string_literal: true

module Api
  module Admin
    class AdminController < ActionController::Base
      before_action -> { doorkeeper_authorize! :admin }
      before_action :sign_user_in
      respond_to :json

      private

      def sign_user_in
        sign_in(doorkeeper_token.resource)
        RequestStore.store[:current_user] = current_user
      end
    end
  end
end
