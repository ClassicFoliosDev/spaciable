# frozen_string_literal: true

class ExpiryPlotsMailer < ApplicationMailer
  default from: "hello@spaciable.com"

  def notify_expiry_residents(residency)
    residency_information(residency)
    @payment_link = residency.create_extension_payment_link
    @payment_logo = Payment::CHECKOUT_LOGO
    @payment_charge = Payment::EXTENTION_CHARGE
    mail to: @email, subject: I18n.t("expiry_email.title")
  rescue => e
    Rails.logger.debug(e.message)
  end

  def notify_reduced_expiry_residents(residency)
    residency_information(residency)
    mail to: @email, subject: I18n.t("reduced_expiry_email.title")
  end

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
