# frozen_string_literal: true

class PhaseTimeline < ApplicationRecord
  belongs_to :timeline
  belongs_to :phase
  has_many :plot_timelines, dependent: :destroy
  has_many :plots, through: :plot_timelines, replace_with_destroy: true

  delegate :live?, :stage_set, to: :timeline
  delegate :title, to: :timeline, prefix: true, allow_nil: true

  after_save :reset_plots

  def to_s
    timeline&.title
  end

  # If the timeline has been changed then the all the plots task_logs
  # must be deleted and their plot_timelines reset
  def reset_plots
    return unless timeline_id_changed?

    plot_timelines&.map(&:reset)
  end
end
