# frozen_string_literal: true

module Residents
  class InvitationsController < Devise::InvitationsController
    layout "accept"

    def create
      super
    end

    def edit
      development = DevelopmentFinderService.call(params)
      @brand = development&.brand_any
      super
    end

    def update
      development = DevelopmentFinderService.call(params)
      @brand = development&.brand_any
      super

      JobManagementService.call(current_resident&.id)
      update_resident_subscribe_params

      current_resident.plots.each do |plot|
        Mailchimp::MarketingMailService.call(current_resident,
                                             plot,
                                             Rails.configuration.mailchimp[:activated])
      end
    end

    def after_accept_path_for(resource)
      services_enabled = resource.plots.any? { |plot| plot.developer.enable_services? }

      services_enabled ? services_path : root_path
    end

    private

    def update_resident_subscribe_params
      if params[:resident][:subscribe_emails].to_i.positive?
        current_resident&.update(hoozzi_email_updates: 1)
        current_resident&.update(developer_email_updates: 1)
      else
        current_resident&.update(hoozzi_email_updates: 0)
        current_resident&.update(developer_email_updates: 0)
      end
    end
  end
end
