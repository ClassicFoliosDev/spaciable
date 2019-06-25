# frozen_string_literal: true

module NotificationHelper
  def data_for_notification(notification)
    {
      id: notification.id,
      subject: notification.subject,
      sendername: "#{notification.first_name} #{notification.last_name}
                   (#{notification.permission_level})",
      firstname: notification.first_name,
      message: notification.message,
      sent: notification.sent_at,
      jobtitle: notification.job_title || "",
      imageurl: image_path(notification.picture_name)
    }
  end
end
