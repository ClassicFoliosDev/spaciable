
# frozen_string_literal: true

class ResidentNotificationMailer < ApplicationMailer
  add_template_helper(PlotRouteHelper)
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.resident_notification_mailer.notify.subject
  #
  def notify(plot_residency, notification)
    resident = plot_residency.resident
    return unless resident.developer_email_updates?

    template_configuration(plot_residency)
    @content = notification.message

    mail to: resident.email, subject: notification.subject
  end

  # Reminder contents are set in the template
  def remind(plot_residency, subject, token)
    return unless plot_residency

    template_configuration(plot_residency)
    @token = token
    @invited_by = plot_residency.invited_by.to_s
    @plot = plot_residency.plot

    mail to: plot_residency.email, subject: subject
  end

  def new_plot(plot_residency, subject)
    return unless plot_residency

    template_configuration(plot_residency)
    @plot = plot_residency.plot

    mail to: plot_residency.email, subject: subject
  end

  private

  def template_configuration(plot_residency)
    @resident = plot_residency.resident
    @plot = plot_residency.plot
    @logo = @plot&.branded_logo
    @logo = "logo.png" if @logo.blank?
  end
end
