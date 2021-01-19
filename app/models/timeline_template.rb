# frozen_string_literal: true

class TimelineTemplate < ApplicationRecord
  has_many :timelines
  has_many :stages

  enum template_type: %i[
    uk
    scotland
    proforma
  ]
end
