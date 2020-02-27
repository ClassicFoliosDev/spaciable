# frozen_string_literal: true

module Homeowners
  class WelcomeHomeController < Homeowners::BaseController
    skip_authorization_check

    def show
      @next_page = intro_video_enabled ? intro_video_path : services_or_dashboard
    end

    private

    def intro_video_enabled
      @setting = Setting.first
      @setting&.intro_video_enabled?
    end

    def services_or_dashboard
      current_resident.services_enabled? ? services_path : dashboard_path
    end
  end
end
