# frozen_string_literal: true

class PlotChoice < ApplicationRecord
  belongs_to :choices, optional: false
  belongs_to :plots, optional: false
end
