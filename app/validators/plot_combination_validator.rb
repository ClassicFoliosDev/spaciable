# frozen_string_literal: true

class PlotCombinationValidator < ActiveModel::Validator
  def validate(record)
    return unless record.parent

    number_uniqueness(record, record.number)
  end

  private

  def number_uniqueness(record, number)
    combinations = other_plot_combinations(record)
    return if combinations.empty?

    return unless combinations.include?(number)

    record.errors.add(:base, :number_taken, value: record.to_s)
  end

  def other_plot_combinations(record)
    other_plots = record.parent.plots
    other_plots = other_plots.where.not(id: record.id) if record.persisted?
    other_plots.pluck(:number)
  end
end
