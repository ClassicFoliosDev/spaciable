# frozen_string_literal: true

class PlotPrivateDocument < ApplicationRecord
  self.table_name = "plots_private_documents"
  belongs_to :plot, optional: false
  belongs_to :private_document, optional: false, autosave: true

  validates :plot, uniqueness: { scope: :private_document }, on: :create
end
