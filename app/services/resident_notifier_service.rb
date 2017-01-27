# frozen_string_literal: true
class ResidentNotifierService
  attr_reader :notification

  def initialize(notification)
    @notification = notification
  end

  def notify_residents
    notification.update(sent_at: Time.zone.now)

    SendResidentNotificationsJob.perform_async(residents.pluck(:id), notification)

    residents
  end

  private

  def residents
    if notification.send_to_all?
      User.homeowner
    else
      notification.send_to.residents
    end
  end
end
