# frozen_string_literal: true

module ResidentChangeNotifyService
  module_function

  def call(resource, user, verb, parent)
    notification = build_notification(resource, user, verb, parent)

    is_private_document = resource.is_a?(Document) &&
                          resource.documentable_type != "Developer" &&
                          resource.documentable_type != "Division"
    send_residents = subscribed_residents(parent, is_private_document)
    SendResidentNotificationsJob.perform_later(send_residents.pluck(:id), notification)

    I18n.t("resident_notification_mailer.notify.update_sent", count: send_residents.count)
  end

  private

  module_function

  def subscribed_residents(parent, is_private_document)
    plot_residencies = PlotResidency.where(plot_id: plots_for(parent).pluck(:id))
    plot_residencies = plot_residencies.where(role: :homeowner) if is_private_document

    plot_residents = plot_residencies.map(&:resident)
    plot_residents.select(&:developer_email_updates?)
  end

  def build_notification(resource, user, verb, parent)
    return unless resource && parent

    notification = Notification.create(sender: user)
    notification.subject = I18n.t("resident_notification_mailer.notify.update_subject")
    notification.message = I18n.t("resident_notification_mailer.notify.update_message",
                                  type: type(resource), name: resource_name(resource), verb: verb)
    notification.send_to = parent
    notification.sent_at = Time.zone.now

    notification.save!

    all_residents_for(parent).each do |resident|
      ResidentNotification.create(notification_id: notification.id, resident_id: resident.id)
    end

    notification
  end

  def type(resource)
    if resource == :not_set
      "Plot"
    else
      resource.model_name.human
    end
  end

  # Includes unsubscribed residents, this call should only be used for in-app notifications
  def all_residents_for(parent)
    plots = plots_for(parent)
    plots.map(&:residents).flatten
  end

  def plots_for(parent)
    return [parent] if parent.is_a?(Plot)
    parent.plots
  end

  def resource_name(resource)
    return I18n.t("notify.information") if resource == :not_set
    return resource.to_homeowner_s if resource.is_a? Plot
    resource.to_s
  end
end
