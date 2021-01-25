# frozen_string_literal: true

class StageSet < ApplicationRecord
  has_many :timelines
  has_many :stages, -> { order(:order) }, dependent: :destroy
  accepts_nested_attributes_for :stages, reject_if: :all_blank, allow_destroy: true

  enum stage_set_type: %i[
    uk
    scotland
    proforma
  ]

  amoeba do
    include_association :stages
  end

  def self.sets
    StageSet.where(clone: false).order(:id)
  end
end
