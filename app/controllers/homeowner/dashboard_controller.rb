# frozen_string_literal: true
module Homeowner
  class DashboardController < Homeowner::BaseController
    skip_authorization_check

    def show
      @brand = current_user.permission_level&.brand
      return unless @brand.nil?
      @brand = Brand.new
    end
  end
end
