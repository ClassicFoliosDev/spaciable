# frozen_string_literal: true

class ExpiryResidentMailer < ApplicationMailer
  default from: "hello@spaciable.com"

  def notify_expiry_resident(residency)
    @payment_link = residency.create_extension_payment_link
    @payment_logo = Payment::CHECKOUT_LOGO
    @payment_charge = Payment::EXTENTION_CHARGE
    @email = residency.email
    @name = residency.first_name
    @logo = @plot.platform_logo
    mail to: @email, subject: I18n.t("resident_expiry_email.title")
  rescue => e
    Rails.logger.debug(e.message)
  end
end
