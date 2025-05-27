# frozen_string_literal: true

module ResidentSnagService
  module_function

  def call(user, update, plot)
    build_notification(user, update, plot)
  end

  def resolved(plot)
    build_resolved_notification(plot)
  end

  def delayed_resolved(plot, notification)
    create_notification(plot, notification)
  end

  def get_address(plot)
    @plot_number = plot.number
    @address = [plot.prefix, plot.postal_number,
                plot.building_name, plot.road_name].compact.join(" ")
  end

  def build_notification(user, update, plot)
    get_address(plot)

    notification = Notification.create(sender: user)
    notification.subject = I18n.t("resident_snag_mailer.notify.new_notification")
    notification.message = I18n.t("resident_snag_mailer.notify.message",
                                  plot: @plot_number, address: @address, update: update)

    notification.send_to = plot
    notification.sent_at = Time.zone.now

    notification.save!

    create_notification(plot, notification)
  end

  def build_resolved_notification(plot)
    get_address(plot)
    developer = plot.developer_id
    sender = User.where(permission_level_id: developer).first

    notification = Notification.create(sender: sender)
    notification.subject = I18n.t("resident_snag_mailer.notify.new_notification")
    notification.message = I18n.t("resident_snag_mailer.all_snags_resolved_email.resolved",
                                  plot: @plot_number, address: @address)

    notification.send_to = plot
    notification.sent_at = Time.zone.now

    notification.save!

    prepare_notification(plot, notification)
  end

  def prepare_notification(plot, notification)
    if plot.snagging_expiry_date < Time.zone.today
      create_notification(plot, notification)
    else
      date = plot.snagging_expiry_date.end_of_day
      SnagsResolvedJob.set(wait_until: date).perform_later(notification.id)
    end
  end

  def create_notification(plot, notification)
    plot.residents.each do |resident|
      if resident.plot_residency_homeowner?(plot)
        ResidentNotification.create(notification_id: notification.id, resident_id: resident.id)
      end
    end
    notification
  end
end
