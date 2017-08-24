# frozen_string_literal: true
class PlotCombinationValidator < ActiveModel::Validator
  def validate(record)
    return unless record.parent

    prefix_and_number_uniqueness(record, record.prefix, record.number)
  end

  private

  def prefix_and_number_uniqueness(record, prefix, number)
    combinations = other_plot_combinations(record)
    return if combinations.empty?

    combination = "#{prefix} #{number}"

    return unless combinations.include?(combination.strip)

    if prefix.present?
      record.errors.add(:base, :combination_taken, value: record.to_s)
    else
      record.errors.add(:base, :number_taken, value: record.to_s)
    end
  end

  def other_plot_combinations(record)
    other_plots = record.parent.plots
    other_plots = other_plots.where.not(id: record.id) if record.persisted?
    other_plots = other_plots.pluck(:prefix, :number)
    other_plots.map { |prefix, number| "#{prefix} #{number}".strip }
  end
end
