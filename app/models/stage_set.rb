# frozen_string_literal: true

class StageSet < ApplicationRecord
  include StageSetTypeEnum
  has_many :timelines
  has_many :stages, -> { order(:order) }
end
