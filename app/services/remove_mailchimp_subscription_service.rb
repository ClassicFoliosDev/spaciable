# frozen_string_literal: true

module RemoveMailchimpSubscriptionService
  module_function

  def call(resident)
    resident.developer_email_updates = false
    resident.hoozzi_email_updates = false
    resident.telephone_updates = false
    resident.post_updates = false
    resident.save!

    resident.plots.each do |plot|
      Mailchimp::MarketingMailService.call(resident,
                                           plot,
                                           Rails.configuration.mailchimp[:unsubscribed])
    end
  end
end
