# frozen_string_literal: true

module Admin
  class SettingsController < ApplicationController
    skip_authorization_check

    before_action :global_settings

    def show; end

    def edit; end

    def update
      if @setting.update(setting_params)
        notice = t(".success")
        redirect_to admin_settings_path, notice: notice
      else
        render :edit
      end
    end

    private

    def global_settings
      @setting = Setting.first
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def setting_params
      params.require(:setting).permit(
        :video_link
      )
    end
  end
end
