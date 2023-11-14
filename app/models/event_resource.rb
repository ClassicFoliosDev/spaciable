# frozen_string_literal: true

# rubocop:disable Rails/HasManyOrHasOneDependent, Lint/DuplicateMethods
class EventResource < ApplicationRecord
  validates :event, optional: false
  belongs_to :event, optional: false
  belongs_to :resourceable, polymorphic: true, optional: false
  delegate :proposed_start, :proposed_end, :notify, :eventable, to: :event
  has_one :plot

  after_save :check_status

  attr_accessor :identity

  enum status: %i[
    invited
    accepted
    declined
    rescheduled
  ]

  # rubocop:disable SkipsModelValidations
  def check_status
    update_column(:status_updated_at, Time.zone.now)
  end
  # rubocop:enable SkipsModelValidations

  def attributes
    attrs = super
    if eventable.is_a?(Development) || eventable.is_a?(Phase)
      # resourceable will be a plot
      attrs[:confirm_multiple] = resourceable.residents.count > 1
    end
    attrs.merge(identity: identity)
  end

  def identity
    (resourceable.is_a?(Plot) ? resourceable : eventable).signature(false)
  end
end
# rubocop:enable Rails/HasManyOrHasOneDependent, Lint/DuplicateMethods
