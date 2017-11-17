
# frozen_string_literal: true

class ResidentNotificationMailer < ApplicationMailer
  add_template_helper(ResidentRouteHelper)
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.resident_notification_mailer.notify.subject
  #
  def notify(resident, notification)
    return unless resident.developer_email_updates?

    template_configuration(resident)
    @content = notification.message

    mail to: resident.email, subject: notification.subject
  end

  # Reminder contents are set in the template
  def remind(resident, subject, token)
    template_configuration(resident)
    @token = token
    @invited_by = resident.invited_by.to_s

    mail to: resident.email, subject: subject
  end

  private

  def template_configuration(resident)
    @resident = resident
    @logo = resident&.plot&.branded_logo
    @logo = "logo.png" if @logo.blank?
  end
end
