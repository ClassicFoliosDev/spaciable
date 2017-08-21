# frozen_string_literal: true
module ResidentChangeNotifyService
  module_function

  def call(resource, user, type)
    send_residents = subscribed_residents(resource)
    notification = build_notification(resource, user, type)
    SendResidentNotificationsJob.perform_later(send_residents.pluck(:id), notification)

    send_residents.count
  end

  private

  module_function

  def subscribed_residents(resource)
    if resource.is_a? Plot
      all_residents = []
      all_residents << resource.resident if resource.resident
    else
      all_residents = Resident.joins(:plot_residency)
                              .where(plot_residencies: { plot_id: resource.plots.pluck(:id) })
    end

    subscribed_residents = all_residents.select do |resident|
      resident.developer_email_updates == 1
    end
    subscribed_residents
  end

  def build_notification(resource, user, type)
    notification = Notification.create(sender: user)
    notification.subject = I18n.t("resident_notification_mailer.notify.update_subject")
    notification.message = I18n.t("resident_notification_mailer.notify.update_message", type: type)
    notification.send_to = resource
    notification.sent_at = Time.zone.now

    notification.save!
    notification
  end
end
