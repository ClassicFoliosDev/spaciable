# frozen_string_literal: true

module ProgressHelper
  # rubocop:disable MethodLength
  def progress_collection(current_progress)
    case current_progress
    when "soon"
      [[t("#{progress_scope}.in_progress"), :in_progress]]
    when "in_progress"
      [[t("#{progress_scope}.roof_on"), :roof_on],
       [t("#{progress_scope}.remove"), :soon]]
    when "roof_on"
      [[t("#{progress_scope}.exchange_ready"), :exchange_ready],
       [t("#{progress_scope}.remove"), :soon]]
    when "exchange_ready"
      [[t("#{progress_scope}.complete_ready"), :complete_ready],
       [t("#{progress_scope}.remove"), :soon]]
    when "complete_ready"
      [[t("#{progress_scope}.completed"), :completed],
       [t("#{progress_scope}.remove"), :soon]]
    else
      [[t("#{progress_scope}.remove"), :soon]]
    end
  end
  # rubocop:enable MethodLength

  def all_progress_collection
    Plot.progresses.map do |(progress_name, _progress_int)|
      [t(progress_name, scope: progress_scope), progress_name]
    end
  end

  private

  def progress_scope
    "activerecord.attributes.plot.progresses"
  end
end
