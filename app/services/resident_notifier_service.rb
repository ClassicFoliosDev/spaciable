# frozen_string_literal: true
# rubocop:disable Metrics/ClassLength
class ResidentNotifierService
  attr_reader :notification

  def initialize(notification)
    @notification = notification
    set_and_save_notification_plot_numbers
  end

  def self.call(notification)
    service = new(notification)
    residents_notified = service.notify_residents
    missing_residents = service.missing_resident_plots

    yield(residents_notified, missing_residents)

    service
  end

  def notify_residents
    notification.update(sent_at: Time.zone.now)

    SendResidentNotificationsJob.perform_later(residents_in_scope.pluck(:id), notification)

    residents_in_scope
  end

  def missing_resident_plots
    return [] if notification.send_to_all?

    sent_residents = notification.send_to.residents
    missing_plot_names = plots_with_no_residents(potential_plots, sent_residents)

    potential_plot_numbers = potential_plots.map(&:number)
    notification.plot_numbers.each do |potential_number|
      # Plot numbers in the plot number list, where there is no matching plot in the development
      unless potential_plot_numbers.include?(potential_number)
        missing_plot_names.push("#{notification.plot_prefix} #{potential_number}".strip)
      end
    end

    missing_plot_names
  end

  private

  def plots_with_no_residents(potential_plots, sent_residents)
    missing_plot_names = []
    sent_resident_numbers = sent_residents.map(&:number)
    potential_plots.each do |potential_plot|
      index = sent_resident_numbers.index(potential_plot.number)

      if index && index >= 0
        if sent_residents[index].prefix != notification.plot_prefix
          # If number matches, but prefix does not match
          missing_plot_names.push(potential_plot.to_s)
        end
      else
        # If number does not match
        missing_plot_names.push(potential_plot.to_s)
      end
    end

    missing_plot_names
  end

  def potential_plots
    @potential_plots ||= begin
      if notification.send_to_all?
        Plot.all
      elsif notification.plot_numbers.any?
        notification.send_to.plots
                    .where(number: notification.plot_numbers)
      else
        notification.send_to.plots
      end
    end
  end

  def residents_in_scope
    @residents ||= begin
      if notification.send_to_all?
        Resident.all
      elsif notification.plot_numbers.any?
        numbered_residents_in_scope
      else
        all_residents_in_scope
      end
    end

    @residents
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

  def all_residents_in_scope
    residents_in_scope = []
    residents_with_plots = notification.send_to.residents.includes(plot_residency: :plot)

    residents_with_plots.each do |resident|
      residents_in_scope.push(resident) && next if resident.plot.prefix == notification.plot_prefix
    end

    residents_in_scope
  end

  def numbered_residents_in_scope
    residents = []

    filtered_residents = notification.send_to.residents.includes(plot_residency: :plot)
                                     .where(plots: { number: notification.plot_numbers })

    filtered_residents.each do |resident|
      residents.push(resident) if resident.plot.prefix == notification.plot_prefix
    end

    residents
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
# rubocop:enable Metrics/ClassLength
