# frozen_string_literal: true

module ReminderEnum
  extend ActiveSupport::Concern

  included do
    enum reminder: %i[
      nix
      at
      hour
      day
      week
    ]
  end

  def remind(reminder, datetime)
    case reminder
    when :at.to_s
      datetime
    when :hour.to_s
      datetime - 1.hour
    when :day.to_s
      datetime - 1.day
    when :week.to_s
      datetime - 1.week
    end
  end

  def self.reminder(reminder)
    case reminder
    when :at.to_s
      "immediately"
    when :hour.to_s
      "in one hour"
    when :day.to_s
      "in one day"
    when :week.to_s
      "in a week"
    end
  end
end
