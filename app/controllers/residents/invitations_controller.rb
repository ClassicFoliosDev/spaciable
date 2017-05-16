# frozen_string_literal: true
module Residents
  class InvitationsController < Devise::InvitationsController
    layout "accept"

    def update
      super

      if params[:resident][:subscribe_emails].to_i.positive?
        current_resident&.update(hoozzi_email_updates: 1)
        current_resident&.update(developer_email_updates: 1)
      end

      Mailchimp::MarketingMailService.call(current_resident,
                                           nil,
                                           Rails.configuration.mailchimp[:activated])
    end
  end
end
