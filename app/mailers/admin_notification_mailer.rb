# frozen_string_literal: true

class AdminNotificationMailer < ApplicationMailer
  default from: "feedback@spaciable.com"

  def admin_notifications(admin_notification, _admin_notification_params)
    @content = admin_notification.message
    @subject = admin_notification.subject
    create_emails(admin_notification)

    mail to: "feedback@spaciable.com", subject: @subject, bcc: @emails
    admin_notification.update(sent_at: Time.zone.now)
  end

  private

  # Create the arrays of emails and names
  def create_emails(admin_notification)
    @admins = User.where.not(role: "cf_admin")
    unless admin_notification.send_to_all
      @admins = filtered_admins(admin_notification)
    end
    @emails = []
    @admins.each do |u|
      @emails << u[:email]
    end
  end

  def filtered_admins(admin_notification)
    filtered = []
    @admins.each do |user|
      filtered << user if user.developer == admin_notification.send_to_id
    end
    filtered
  end
end
