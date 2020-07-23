# frozen_string_literal: true

class EventResource < ApplicationRecord
  validates :event, presence: true
  belongs_to :event, required: true
  belongs_to :resourceable, polymorphic: true, required: true

  enum status: %i[
    invited
    accepted
    declined
    updated
  ]

end
