# frozen_string_literal: true

class Ptimeline < ApplicationRecord
  self.table_name = "phase_timelines"

  belongs_to :timeline
  belongs_to :phase
end
