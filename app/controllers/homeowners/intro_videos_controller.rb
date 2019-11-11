# frozen_string_literal: true

module Homeowners
  class IntroVideosController < Homeowners::BaseController
    layout "accept"

    def show
      @setting = Setting.first
      @next_path = @plot.enable_services? ? services_path : root_path
    end
  end
end
