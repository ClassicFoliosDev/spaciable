# frozen_string_literal: true
class ResidentNotificationMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.resident_notification_mailer.notify.subject
  #
  def notify(resident, notification)
    @resident = resident
    @content = notification.message
    @logo = resident&.plot.logo
    @logo = "logo.png" if @logo.nil?

    mail to: resident.email, subject: notification.subject
  end
end
