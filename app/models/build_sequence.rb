# frozen_string_literal: true

class BuildSequence < ApplicationRecord
  has_many :developers
  has_many :divisions
  has_many :build_steps, -> { order(:order) }, dependent: :destroy
  accepts_nested_attributes_for :build_steps, allow_destroy: true

  def self.master
    BuildSequence.find_by(master: true)
  end
end
