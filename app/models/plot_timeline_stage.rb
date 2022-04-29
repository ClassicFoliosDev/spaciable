# frozen_string_literal: true

class PlotTimelineStage < ApplicationRecord
  belongs_to :plot_timeline
  belongs_to :timeline_stage
end
