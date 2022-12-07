# frozen_string_literal: true

module Api
  module Admin
    class AdminController < ActionController::Base
      before_action -> { doorkeeper_authorize! :admin }, only: %i[create]
      before_action :sign_user_in, only: %i[create]

      before_action -> { doorkeeper_authorize! }, only: %i[single_page_app_create]
      before_action :sign_app_in, only: %i[single_page_app_create]

      respond_to :json

      private

      def sign_user_in
        sign_in(doorkeeper_token.resource)
        RequestStore.store[:current_user] = current_user
      end

      def sign_app_in
        # Yes this looks wrong!  doorkeeper_token.app_user DOES
        # return a User but it fails to satisfy 'is_a? User' for
        # some reason.  It looks like a bug cleared in later
        # versions of Ruby
        sign_in(User.find(doorkeeper_token.app_user.id))
        RequestStore.store[:current_user] = current_user
      end
    end
  end
end
