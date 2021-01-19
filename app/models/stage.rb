# frozen_string_literal: true

# A Stage of a Timeline.  E.g. 'Reservation'
class Stage < ApplicationRecord
  belongs_to :timeline_template

  def self.set
    Stage.all.order(:id)
  end
end
