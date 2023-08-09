# frozen_string_literal: true

class Report
  include ActiveModel::Model
  include ActiveRecord::AttributeAssignment

  attr_accessor :report_from, :report_to, :plot_type
  attr_accessor :developer_id, :division_id, :development_id, :csv_type

  validates :report_from, :report_to, presence: true
  validate :report_from_not_in_future
  validate :report_to_not_before_report_from

  def report_from_not_in_future
    return if extract_date(report_from) <= Time.zone.now.to_date

    errors.add(:report_from, :future)
  end

  def report_to_not_before_report_from
    return if extract_date(report_to) >= extract_date(report_from)

    errors.add(:report_to, :before_report_from)
  end

  def extract_date(date_input)
    if date_input.respond_to?(:to_date)
      date_input.to_date
    elsif date_input.is_a?(Hash)
      Time.zone.local(date_input[1], date_input[2], date_input[3])
    end
  end
end
