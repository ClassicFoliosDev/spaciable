# frozen_string_literal: true

class EventResource < ApplicationRecord
  validates :event, presence: true
  belongs_to :event, required: true
  belongs_to :resourceable, polymorphic: true, required: true

  after_save :check_status

  enum status: %i[
    invited
    accepted
    declined
    reproposed
  ]

  # rubocop:disable SkipsModelValidations
  def check_status
    return unless status_changed? || proposed_start_changed? || proposed_end_changed?

    update_column(:status_updated_at, Time.zone.now)
  end
  # rubocop:enable SkipsModelValidations
end
