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

      Mailchimp::MarketingMailService.call(current_resident,
                                           nil,
                                           Rails.configuration.mailchimp[:activated])
    end

    def after_accept_path_for(resource)
      # TODO: Which plot
      return services_path if resource.plots.first.developer.enable_services?
      root_path
    end

    private

    def update_resident_subscribe_params
      # The subscribe_emails checkbox is inverted in the UI
      # value of 1 => Unsubscribe
      # not set or 0 => Subscribe
      if params[:resident][:subscribe_emails].to_i.positive?
        current_resident&.update(hoozzi_email_updates: 0)
        current_resident&.update(developer_email_updates: 0)
      else
        current_resident&.update(hoozzi_email_updates: 1)
        current_resident&.update(developer_email_updates: 1)
      end
    end
  end
end
