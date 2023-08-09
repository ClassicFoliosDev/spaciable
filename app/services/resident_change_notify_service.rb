# frozen_string_literal: true

module ResidentChangeNotifyService
  module_function

  def call(resource, user, verb, parent, subject = nil)
    notification = build_notification(resource, user, verb, parent, subject)

    is_private_document = resource.is_a?(Document) &&
                          resource.documentable_type != "Developer" &&
                          resource.documentable_type != "Division"
    send_residents = subscribed_residents(parent, resource, is_private_document)
    SendResidentNotificationsJob.perform_later(send_residents.pluck(:id), notification)

    I18n.t("resident_notification_mailer.notify.update_sent", count: send_residents.count)
  end

  # rubocop:disable LineLength
  def subscribed_residents(parent, resource, is_private_document)
    plot_residencies = PlotResidency.where(plot_id: notifyable_plots_for(parent, resource).pluck(:id))
    plot_residencies = plot_residencies.where(role: :homeowner) if is_private_document

    plot_residents = plot_residencies.map(&:resident)
    plot_residents.select(&:developer_email_updates?)
  end
  # rubocop:enable LineLength

  def build_notification(resource, user, verb, parent, subject)
    return unless resource && parent

    notification = Notification.create(sender: user)
    notification.subject = subject || I18n.t("resident_notification_mailer.notify.update_subject")
    notification.message = I18n.t("resident_notification_mailer.notify.update_message",
                                  address: parent_address(parent),
                                  message: resource_message(resource, verb))
    notification.send_to = parent
    notification.sent_at = Time.zone.now

    notification.save!

    notification
  end

  # Includes unsubscribed residents, this call should only be used for in-app notifications
  def all_residents_for(parent, resource)
    plots = plots_for(parent, resource)
    plots.map(&:residents).flatten
  end

  # Free plots are only able to receive notifications for Phase Documents
  # rubocop:disable Metrics/CyclomaticComplexity
  def notifyable_plots_for(parent, resource)
    notifyable_plots = []

    plots_for(parent, resource).each do |plot|
      next if plot.free? &&
              !((parent.is_a?(Phase) && resource.is_a?(Document)) ||
              (resource.is_a?(Document) && resource.override))
      next if plot.essentials? && resource.is_a?(Faq) && resource.custom?

      notifyable_plots << plot
    end

    notifyable_plots
  end
  # rubocop:enable Metrics/CyclomaticComplexity

  def plots_for(parent, resource)
    return [parent] if parent.is_a?(Plot)

    plots = parent.plots
    if resource.is_a?(Document)
      uploader_type = User.find_by(id: resource.user_id)
      return plots if uploader_type.cf_admin?
    end
    active_plots = []
    plots.each do |plot|
      active_plots << plot unless plot.expired?
    end
    active_plots
  end

  # Builds the opening address for the notification depending on the level
  # at which the notification is sent from
  # rubocop:disable all
  def parent_address(parent)
    if parent.is_a? Plot
      plot = parent.number
      development = parent.development_name
      developer = parent.company_name
      plot_address = [parent.prefix, parent.postal_number,
                      parent.building_name, parent.road_name].compact.join(" ")
      address = I18n.t("resident_notification_mailer.notify.address",
                       plot: plot, development: development, address: plot_address)
      I18n.t("resident_notification_mailer.notify.new_plot_message",
             developer: developer, address: address)
    elsif (parent.is_a? Development) || (parent.is_a? Phase)
      development = parent.is_a?(Phase) ? parent.development.to_s : parent.to_s
      developer = parent.developer_id? ? parent.developer.to_s : parent.division.developer.to_s
      I18n.t("resident_notification_mailer.notify.new_development_message",
             developer: developer, development: development)
    else
      developer = parent.is_a?(Division) ? parent.developer.to_s : parent.to_s
      I18n.t("resident_notification_mailer.notify.new_developer_message", developer: developer)
    end
  end
  # rubocop: enable all

  # Builds the details of the notification as determined by the resource origin
  def resource_message(resource, verb)
    if (resource.is_a? Plot) || (resource == :not_set)
      I18n.t("resident_notification_mailer.notify.verb_message_content", verb: verb)
    else
      resource_type = resource.model_name.human
      resource_type = resource_type == "FAQ" ? resource_type : resource_type.downcase
      description = I18n.t("resident_notification_mailer.notify.description",
                           verb: verb, resource: resource_type)
      details = resource.to_s
      I18n.t("resident_notification_mailer.notify.message_content",
             description: description, details: details)
    end
  end
end
