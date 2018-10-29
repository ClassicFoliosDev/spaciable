# frozen_string_literal: true

module ProgressHelper
  def all_progress_collection
    Plot.progresses.map do |(progress_name, _progress_int)|
      [t(progress_name, scope: progress_scope), progress_name]
    end
  end

  def progress_collection(existing_progress_name)
    progress_list = Plot.progresses.map do |(progress_name, _progress_int)|
      next if progress_name == existing_progress_name
      [t(progress_name, scope: progress_scope), progress_name]
    end

    progress_list.compact
  end

  private

  def progress_scope
    "activerecord.attributes.plot.progresses"
  end
end
