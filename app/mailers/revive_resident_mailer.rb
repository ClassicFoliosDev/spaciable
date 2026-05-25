# frozen_string_literal: true

class ReviveResidentMailer < ApplicationMailer
  default from: "hello@spaciable.com"

  # rubocop:disable Style/RescueStandardError
  def revive_expired_resident(residency)
    residency_information(residency)
    @payment_link = residency.create_extension_payment_link
    @payment_logo = Payment::CHECKOUT_LOGO
    @payment_charge = Payment::EXTENTION_CHARGE
    mail to: @email, subject: I18n.t("expiry_email.title")
  rescue => e
    Rails.logger.debug(e.message)
  end
  # rubocop:enable Style/RescueStandardError

  def residency_information(residency)
    @email = residency.email
    @name = residency.first_name
    @plot = residency.plot
    @development = @plot.development
    @developer = @plot.developer
    @address = [@plot.prefix, @plot.postal_number,
                @plot.building_name, @plot.road_name].compact.join(" ")
    @logo = @plot.platform_logo
  end
end
