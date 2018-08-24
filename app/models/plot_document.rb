# frozen_string_literal: true

class PlotDocument < ApplicationRecord
  self.table_name = "documents_plots"
  belongs_to :plot, optional: false
  belongs_to :document, optional: false, autosave: true

  validates :plot, uniqueness: { scope: :document }, on: :create
end
