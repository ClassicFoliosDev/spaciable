# frozen_string_literal: true

module RepeatEnum
  extend ActiveSupport::Concern

  included do
    enum repeat: %i[
      never
      daily
      weekly
      biweekly
      monthly
      yearly
    ]
  end

  def repeat_interval(repeat)
    case repeat
    when "never"
      0
    when "daily"
      1.day
    when "weekly"
      1.week
    when "biweekly"
      2.weeks
    when "monthly"
      1.month
    when "yearly"
      1.year
    end
  end
end
