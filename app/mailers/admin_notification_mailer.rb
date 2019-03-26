# frozen_string_literal: true

class AdminNotificationMailer < ApplicationMailer
  default from: "feedback@hoozzi.com"

  def admin_notifications(admin_notification, _admin_notification_params)
    @content = admin_notification.message
    @subject = admin_notification.subject
    create_emails

    mail to: "feedback@hoozzi.com", subject: @subject, bcc: @emails
    admin_notification.update(sent_at: Time.zone.now)
  end

  private

  # Create the arrays of emails and names
  def create_emails
    @emails = []
    @admins = User.where.not(role: "cf_admin")
    @admins.each do |u|
      @emails << u[:email]
    end
  end
end
