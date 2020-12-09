# frozen_string_literal: true

class EventResource < ApplicationRecord
  validates :event, presence: true
  belongs_to :event, required: true
  belongs_to :resourceable, polymorphic: true, required: true
  delegate :proposed_start, :proposed_end, :notify, to: :event
  has_one :plot

  after_save :check_status

  attr_accessor :identity

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

  def attributes
    attrs = super
    attrs.merge(identity: identity)
  end

  def identity
    (resourceable.is_a?(Plot) ? resourceable : event.eventable).signature
  end
end
