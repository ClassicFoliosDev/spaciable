# frozen_string_literal: true

module NotificationSendService
  module_function

  def call(notification, notification_params)
    send_to(notification, notification_params)
    notification.save
    notification
  end

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

  #rubocop:disable all
  def find_address(notification)
    if notification.send_to_type == "Phase"
      phase = Phase.find_by(id: notification.send_to_id)
      development = phase.development
      development_address(development)
    elsif notification.send_to_type == "Development"
      development = Development.find_by(id: notification.send_to_id)
      development_address(development)
    elsif notification.send_to_type == "Division"
      division = Division.find_by(id: notification.send_to_id)
      developer = division.developer
      developer_address(developer)
    elsif notification.send_to_type == "Developer"
      developer = Developer.find_by(id: notification.send_to_id)
      developer_address(developer)
    end
  end
  #rubocop:enable all

  def development_address(development)
    developer = if development.developer_id?
                  development.developer.to_s
                else
                  development.division.developer.to_s
                end

    I18n.t("resident_notification_mailer.notify.new_development_message",
           developer: developer, development: development)
  end

  def developer_address(developer)
    I18n.t("resident_notification_mailer.notify.new_developer_message", developer: developer)
  end
end
