# frozen_string_literal: true
class PlotResident < ApplicationRecord
  self.table_name = "plots_residents"

  belongs_to :plot
  belongs_to :resident
end
