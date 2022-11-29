# frozen_string_literal: true

module Api
  module Admin
    class AdminController < ActionController::Base
      before_action -> { doorkeeper_authorize! :admin } if :create
      before_action :sign_user_in if :create

      before_action -> { doorkeeper_authorize! } if :single_page_app_create
      before_action :sign_app_in if :single_page_app_create

      respond_to :json

      private

      def sign_user_in
        sign_in(doorkeeper_token.resource)
        RequestStore.store[:current_user] = current_user
      end

      def sign_app_in
        sign_in(User.find(146))
        RequestStore.store[:current_user] = current_user
      end

    end
  end
end
