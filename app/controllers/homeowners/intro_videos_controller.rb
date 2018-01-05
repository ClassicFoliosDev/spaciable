# frozen_string_literal: true

module Homeowners
  class IntroVideosController < Homeowners::BaseController
    layout "accept"

    def show
      @setting = Setting.first
      @next_path = current_resident.services_enabled? ? services_path : root_path
    end
  end
end
