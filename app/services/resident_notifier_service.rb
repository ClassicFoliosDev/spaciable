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
    missing_residents = service.all_missing_plots

    yield(residents_notified, missing_residents)

    service
  end

  def notify_residents
    notification.update(sent_at: Time.zone.now)
    SendResidentNotificationsJob.perform_later(residents_in_scope.pluck(:id), notification)

    residents_in_scope
  end

  def all_missing_plots
    return [] if notification.send_to_all?

    if notification.plot_numbers && notification.plot_prefix?
      missing_resident_plots_with_prefix.sort
    else
      missing_resident_plots.sort
    end
  end

  private

  def missing_resident_plots
    sent_residents = notification.send_to.residents
    missing_plot_names = plots_no_residents(potential_plots, sent_residents)

    potential_plot_numbers = potential_plots.map(&:number)
    notification.plot_numbers.each do |sent_number|
      # Plot numbers in the plot number list, where there is no matching plot in the development
      missing_plot_names.push(sent_number) unless potential_plot_numbers.include?(sent_number)
    end

    missing_plot_names
  end

  def missing_resident_plots_with_prefix
    sent_residents = notification.send_to.residents
    missing_plot_names = plots_no_residents(potential_plots, sent_residents)

    potential_plot_full_numbers = potential_plots.map(&:to_s)
    sent_full_numbers = notification.plot_numbers.map do |plot_number|
      "#{notification.plot_prefix} #{plot_number}".strip
    end

    missing_plot_names + (potential_plot_full_numbers - sent_full_numbers)
  end

  def plots_no_residents(potential_plots, sent_residents)
    missing_plot_names = Set.new
    sent_resident_full_numbers = []
    sent_residents.each do |resident|
      resident.plots.each do |plot|
        sent_resident_full_numbers << plot.to_s
      end
    end

    potential_plots.each do |potential_plot|
      unless sent_resident_full_numbers.include?(potential_plot.to_s)
        missing_plot_names.add(potential_plot.to_s)
      end
    end

    missing_plot_names.to_a
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

    filter_by_role
  end

  def filter_by_role
    return @residents if notification.send_to_role == "both"

    filtered_residents = []
    @residents.each do |resident|
      resident.plot_residencies.each do |residency|
        filtered_residents.push(resident) if residency.role == notification.send_to_role
      end
    end

    @residents = filtered_residents
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
    residents_with_plots = notification.send_to.residents

    residents_with_plots.each do |resident|
      residents_in_scope.push(resident)
    end

    residents_in_scope
  end

  def numbered_residents_in_scope
    residents = []

    filtered_residents = notification.send_to.residents
                                     .where(plots: { number: notification.plot_numbers })

    filtered_residents.each do |resident|
      resident.plots.each do |plot|
        residents.push(resident) if plot.prefix == notification.plot_prefix
      end
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
