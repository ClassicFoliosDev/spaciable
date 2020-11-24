# frozen_string_literal: true

class EventResource < ApplicationRecord
  validates :event, presence: true
  belongs_to :event, required: true
  belongs_to :resourceable, polymorphic: true, required: true
  delegate :proposed_start, :proposed_end, :notify, to: :event

  after_save :check_status

  enum status: %i[
    invited
    accepted
    declined
    reproposed
  ]

  # rubocop:disable SkipsModelValidations
  def check_status
    update_column(:status_updated_at, Time.zone.now)
  end
  # rubocop:enable SkipsModelValidations
end
