# frozen_string_literal: true
class PlotResidency < ApplicationRecord
  belongs_to :plot
  belongs_to :resident
end
