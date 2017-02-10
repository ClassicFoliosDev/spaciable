# frozen_string_literal: true
module Homeowners
  class DashboardController < Homeowners::BaseController
    skip_authorization_check

    def show
      @brand = current_resident.brand
      return unless @brand.nil?
      @brand = Brand.new
    end
  end
end
