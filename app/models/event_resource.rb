# frozen_string_literal: true

class EventResource < ApplicationRecord
  belongs_to :event, required: true
  belongs_to :resourceable, polymorphic: true, required: true

  enum status: %i[
    unassigned
    awaiting_acknowledgement
    acknowledged
    cancelled
  ]

  def self.assigned_statuses
    statuses.reject { |key, _| ["unassigned", "awaiting_acknowledgement"].include?(key) }
  end

end
