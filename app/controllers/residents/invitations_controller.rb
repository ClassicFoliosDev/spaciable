# frozen_string_literal: true
module Residents
  class InvitationsController < Devise::InvitationsController
    layout "accept"

    def update
      super

      subscribed = if params[:resident][:subscribe_emails].to_i.positive?
                     Rails.configuration.mailchimp[:subscribed]
                   else
                     Rails.configuration.mailchimp[:unsubscribed]
                   end

      Mailchimp::MarketingMailService.call(current_resident,
                                           nil,
                                           Rails.configuration.mailchimp[:activated],
                                           subscribed)
    end
  end
end
