# frozen_string_literal: true

module Api
  module Resident
    class ResidentController < ActionController::Base
      before_action -> { doorkeeper_authorize! :resident }
      before_action :sign_user_in
      before_action -> { @plot = current_resident.plots.first }
      respond_to :json

      private

      def sign_user_in
        sign_in(doorkeeper_token.resource)
        RequestStore.store[:current_resident] = current_resident
      end

      def current_ability
        @ability ||= Ability.new(current_resident, plot: @plot)
      end

    end
  end
end
