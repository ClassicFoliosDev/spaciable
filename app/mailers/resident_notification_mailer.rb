
# frozen_string_literal: true

class ResidentNotificationMailer < ApplicationMailer
  add_template_helper(PlotRouteHelper)

  def notify(plot_residency, notification)
    resident = plot_residency.resident
    return unless resident.developer_email_updates?

    template_configuration(plot_residency)
    @content = notification.message

    mail to: resident.email, subject: notification.subject
  end

  # Reminder contents are set in the template
  def remind(plot_residency, subject, token, invited_by_name)
    return unless plot_residency

    template_configuration(plot_residency)
    @token = token
    @invited_by_name = invited_by_name
    @plot = plot_residency.plot

    mail to: plot_residency.email, subject: subject
  end

  def new_plot(plot_residency, subject, invited_by_name)
    return unless plot_residency

    template_configuration(plot_residency)
    @plot = plot_residency.plot
    @invited_by_name = invited_by_name

    mail to: plot_residency.email, subject: subject
  end

  def close_account(email, name)
    @name = name
    @logo = email_logo_or_brand_logo

    mail to: email, subject: I18n.t("devise.mailer.close_account.title")
  end

  def transfer_files(email, name, url, plot_name)
    @name = name
    @url = url
    @logo = email_logo_or_brand_logo
    @plot_name = plot_name

    mail to: email, subject: I18n.t("devise.mailer.transfer_files.title")
  end

  private

  def email_logo_or_brand_logo
    @plot&.branded_email_logo ? @plot.branded_email_logo : brand_logo_or_default_logo
  end

  def brand_logo_or_default_logo
    @plot&.branded_logo ? @plot.branded_logo : "logo.png"
  end

  def template_configuration(plot_residency)
    @resident = plot_residency.resident
    @plot = plot_residency.plot
    @logo = email_logo_or_brand_logo
  end
end
