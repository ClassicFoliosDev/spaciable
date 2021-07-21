# frozen_string_literal: true

class BuildSequence < ApplicationRecord
  belongs_to :build_sequenceable, polymorphic: true
  alias parent build_sequenceable

  has_many :developers
  has_many :divisions
  has_many :build_steps, -> { order(:order) }, dependent: :destroy
  accepts_nested_attributes_for :build_steps, allow_destroy: true

  delegate :update_build_steps, to: :build_sequenceable
end
