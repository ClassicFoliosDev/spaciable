# frozen_string_literal: true

# A Stage of a Timeline.  E.g. 'Reservation'
class Stage < ApplicationRecord

  def self.set
    Stage.all.order(:id)
  end
end
