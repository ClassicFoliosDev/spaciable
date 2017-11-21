# frozen_string_literal: true

module ResidentResetService
  module_function

  def call(residency)
    return unless residency
    resident = residency.resident

    resident.developer_email_updates = false
    resident.hoozzi_email_updates = false
    resident.telephone_updates = false
    resident.post_updates = false
    resident.save!

    Mailchimp::MarketingMailService.call(resident,
                                         residency,
                                         Rails.configuration.mailchimp[:unassigned])
  end
end
