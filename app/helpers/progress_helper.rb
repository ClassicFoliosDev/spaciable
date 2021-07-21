
# frozen_string_literal: true

module ProgressHelper
  def all_progress_collection(parent)
    parent.build_steps.pluck(:title, :id)
  end

  def progress_collection(plot)
    plot.build_steps.reject { |s| s.id == plot.build_step_id }.pluck(:title, :id)
  end

  private
end
