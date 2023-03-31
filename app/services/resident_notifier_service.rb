# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength
class ResidentNotifierService
  attr_reader :notification
  attr_reader :sender

  def initialize(notification, sender = RequestStore.store[:current_user])
    @notification = notification
    @sender = sender
    set_and_save_notification_plot_numbers
  end

  def self.call(notification, sender = RequestStore.store[:current_user])
    service = new(notification, sender)
    residents_notified = service.notify_residents

    missing_residents = service.all_missing_plots(residents_notified)

    yield(residents_notified, missing_residents)

    service
  end

  def notify_residents
    notification.update(sent_at: Time.zone.now)
    SendResidentNotificationsJob.perform_later(residents_in_scope.pluck(:id),
                                               notification, true, sender)

    Living::Notification.notify(notification, residents_in_scope)

    residents_in_scope
  end

  def all_missing_plots(residents_notified = nil)
    return [] if notification.send_to_all? || !notification.all_plots?

    residents_notified = notify_residents if residents_notified.nil?

    missing_resident_plots(residents_notified).sort
  end

  private

  def missing_resident_plots(residents_notified)
    missing_plot_names = plots_no_residents(potential_plots, residents_notified)

    potential_plot_numbers = potential_plots.map(&:number)
    notification.plot_numbers.each do |sent_number|
      # Plot numbers in the plot number list, where there is no matching plot in the development
      missing_plot_names.push(sent_number) unless potential_plot_numbers.include?(sent_number)
    end

    missing_plot_names
  end

  def plots_no_residents(potential_plots, residents_notified)
    missing_plot_names = Set.new
    sent_resident_full_numbers = []
    residents_notified.each do |resident|
      resident.plots.each do |plot|
        sent_resident_full_numbers << plot.number
      end
    end

    potential_plots.each do |potential_plot|
      unless sent_resident_full_numbers.include?(potential_plot.number)
        missing_plot_names.add(potential_plot.number)
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
    return @residents unless @residents.nil?

    @residents = if notification.send_to_all?
                   Resident.all
                 elsif notification.plot_numbers.any?
                   numbered_residents_in_scope
                 else
                   all_residents_in_scope
                 end

    filter_by_role
  end

  def filter_by_role
    return @residents if notification.send_to_role == "both"

    filtered_residents = []
    @residents.each do |resident|
      resident.plot_residencies.each do |residency|
        if residency.role == notification.send_to_role
          filtered_residents.push(resident) if potential_plots.include?(residency.plot)
        end
      end
    end

    @residents = filtered_residents.uniq
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

  # rubocop:disable Metrics/MethodLength
  def all_residents_in_scope
    residents_in_scope = []
    residents_with_plots ||= begin
      case notification.plot_filter.to_sym
      when :all_plots
        notification.send_to.residents
      when :completed_plots
        notification.send_to.residents
                    .where("plots.completion_date <= ?", Time.zone.today)
      when :reservation_plots
        notification.send_to.residents
                    .where("plots.completion_date > ?", Time.zone.today)
      end
    end

    residents_with_plots.each do |resident|
      residents_in_scope.push(resident)
    end

    residents_in_scope
  end
  # rubocop:enable Metrics/MethodLength

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def numbered_residents_in_scope
    residents = []

    filtered_residents ||= begin
      case notification.plot_filter.to_sym
      when :all_plots
        notification.send_to.residents
                    .where(plots: { number: notification.plot_numbers })
      when :completed_plots
        notification.send_to.residents
                    .where(plots: { number: notification.plot_numbers })
                    .where("plots.completion_date <= ?", Time.zone.today)
      when :reservation_plots
        notification.send_to.residents
                    .where(plots: { number: notification.plot_numbers })
                    .where("plots.completion_date > ?", Time.zone.today)
      end
    end

    filtered_residents.each do |resident|
      resident.plots.each do |_plot|
        residents.push(resident)
      end
    end

    residents.uniq
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

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
