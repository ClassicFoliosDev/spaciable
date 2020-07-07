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
end
