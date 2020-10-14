# frozen_string_literal: true

module Residents
  class InvitationsController < Devise::InvitationsController
    layout "accept"

    def create
      super
    end

    def edit
      development = if params[:development_id]
                      Development.find(params[:development_id])
                    else
                      DevelopmentFinderService.call(params)
                    end
      @brand = development&.brand_any
      super
    end

    def update
      # add an onboarding session to use for hiding navigation from onboarding process
      session[:onboarding] = true
      # add a dashboard tour cookie
      cookies[:dashboard_tour] = "show"
      development = DevelopmentFinderService.call(params)
      @brand = development&.brand_any
      super

      return if current_resident.blank?

      JobManagementService.call(current_resident.id)
      update_resident_ts_and_cs

      current_resident.plots.each do |plot|
        Mailchimp::MarketingMailService.call(current_resident,
                                             plot,
                                             Rails.configuration.mailchimp[:activated])
      end
    end

    def after_accept_path_for(_resource)
      communication_preferences_path
    end

    private

    def update_resident_ts_and_cs
      return if params[:resident][:ts_and_cs_accepted].blank?

      current_resident.update(ts_and_cs_accepted_at: Time.zone.now)
    end
  end
end
