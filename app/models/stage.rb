# frozen_string_literal: true

# A Stage of a Timeline.  E.g. 'Reservation'
class Stage < ApplicationRecord
  belongs_to :stage_set

  def self.set
    stage_set.stages
  end
end
