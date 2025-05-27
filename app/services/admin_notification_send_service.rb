# frozen_string_literal: true

module AdminNotificationSendService
  module_function

  def call(admin_notification, admin_notification_params)
    return admin_notification if admin_notification.send_to_all

    send_to(admin_notification, admin_notification_params)
    admin_notification.save

    admin_notification
  end

  def send_to(admin_notification, admin_notification_params)
    admin_notification.send_to_id = admin_notification_params[:developer_id].to_i
    admin_notification.send_to_type = :Developer

    Living::AdminNotification.notify(admin_notification)
  end
end
