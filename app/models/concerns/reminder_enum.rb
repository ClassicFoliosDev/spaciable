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
    when "at"
      datetime
    when "hour"
      datetime - 1.hour
    when "day"
      datetime - 1.day
    when "week"
      datetime - 1.week
    end
  end
end
