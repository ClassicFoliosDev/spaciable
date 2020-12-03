# frozen_string_literal: true

class AdminNotificationMailer < ApplicationMailer
  default from: "feedback@spaciable.com"

  def admin_notification(email, admin_notification, _admin_notification_params)
    @content = admin_notification.message
    @subject = admin_notification.subject
    mail to: email, subject: @subject
  end

  def csv_report_download(email, name, url)
    @name = name
    @url = url
    @logo = "Spaciable_full.svg"
    mail to: email,
         subject: I18n.t("devise.mailer.transfer_csv.#{@url.nil? ? 'no_data' : 'success'}")
  end
end
