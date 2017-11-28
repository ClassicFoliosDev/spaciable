# frozen_string_literal: true

module NotificationSendService
  module_function

  def call(notification, notification_params)
    send_to(notification, notification_params)
    notification.save

    notification
  end

  private

  module_function

  def send_to(notification, notification_params)
    if notification_params[:phase_id].to_i.positive?
      notification.send_to_id = notification_params[:phase_id].to_i
      notification.send_to_type = :Phase
    elsif notification_params[:development_id].to_i.positive?
      notification.send_to_id = notification_params[:development_id].to_i
      notification.send_to_type = :Development
    elsif notification_params[:division_id].to_i.positive?
      notification.send_to_id = notification_params[:division_id].to_i
      notification.send_to_type = :Division
    elsif notification_params[:developer_id].to_i.positive?
      notification.send_to_id = notification_params[:developer_id].to_i
      notification.send_to_type = :Developer
    end
  end
end
