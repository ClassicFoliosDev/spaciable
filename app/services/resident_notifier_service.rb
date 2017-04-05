# frozen_string_literal: true
class ResidentNotifierService
  attr_reader :notification

  def initialize(notification)
    @notification = notification
    set_and_save_notification_plot_numbers
  end

  def self.call(notification)
    service = new(notification)
    residents = service.notify_residents
    missing_residents = service.missing_resident_plots

    yield(residents, missing_residents)

    service
  end

  def notify_residents
    notification.update(sent_at: Time.zone.now)

    SendResidentNotificationsJob.perform_later(residents.pluck(:id), notification)

    residents
  end

  def missing_resident_plots
    return [] if notification.send_to_all?

    resident_plot_numbers = residents.map(&:plot_number)

    plot_numbers.reject { |number| resident_plot_numbers.include?(number.to_s) }
  end

  private

  def residents
    @residents ||= begin
      if notification.send_to_all?
        Resident.all
      elsif notification.plot_numbers.any?
        plot_residents
      else
        notification.send_to.residents.includes(plot_residency: :plot)
      end
    end
  end

  def plot_numbers
    @plot_numbers ||= begin
      if notification.plot_numbers.any?
        notification.plot_numbers
      else
        notification.send_to.plots.map(&:number).uniq
      end
    end
  end

  def plot_residents
    notification.send_to.residents
                .includes(plot_residency: :plot)
                .where(plots: { number: notification.plot_numbers })
  end

  def set_and_save_notification_plot_numbers
    notification.plot_numbers = BulkPlots::Numbers.new(
      range_from: notification.range_from,
      range_to: notification.range_to,
      list: notification.list
    ).numbers

    notification.save!
  end
end
