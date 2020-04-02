# frozen_string_literal: true

module Homeowners
  class IntroVideosController < Homeowners::BaseController
    def show
      @setting = Setting.first
      @next_path = @plot.enable_services? ? services_path : dashboard_path
    end
  end
end
