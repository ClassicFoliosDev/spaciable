# frozen_string_literal: true

module TimelineHelper
  def collapsed(plot_timeline, stage)
    plot_timeline.plot_timeline_stages.find_by(timeline_stage_id: stage.id)&.collapsed || false
  end
end
