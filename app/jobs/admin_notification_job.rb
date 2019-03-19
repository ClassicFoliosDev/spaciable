# frozen_string_literal: true

class AdminNotificationJob < ApplicationJob
  queue_as :mailer

  def perform(user, admin_notification)
    AdminNotificationMailer.admin_notifications(user, admin_notification).deliver_later
  end
end
