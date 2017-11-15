# frozen_string_literal: true

module ResidentChangeNotifyService
  module_function

  def call(resource, user, verb, parent)
    send_residents = subscribed_residents(parent)
    notification = build_notification(resource, user, verb, parent)
    SendResidentNotificationsJob.perform_later(send_residents.pluck(:id), notification)

    I18n.t("resident_notification_mailer.notify.update_sent", count: send_residents.count)
  end

  private

  module_function

  def subscribed_residents(parent)
    all_residents = Resident.joins(:plot_residency)
                            .where(plot_residencies: { plot_id: plots_for(parent).pluck(:id) })

    subscribed_residents = all_residents.select do |resident|
      resident.developer_email_updates == 1
    end

    subscribed_residents
  end

  def build_notification(resource, user, verb, parent)
    type = resource.model_name.human

    notification = Notification.create(sender: user)
    notification.subject = I18n.t("resident_notification_mailer.notify.update_subject")
    notification.message = I18n.t("resident_notification_mailer.notify.update_message",
                                  type: type, name: resource_name(resource), verb: verb)
    notification.send_to = parent
    notification.sent_at = Time.zone.now

    notification.save!
    notification
  end

  def plots_for(parent)
    return [parent] if parent.is_a?(Plot)
    parent.plots
  end

  def resource_name(resource)
    return I18n.t("notify.information") if resource.is_a?(Plot)
    resource.to_s
  end
end
