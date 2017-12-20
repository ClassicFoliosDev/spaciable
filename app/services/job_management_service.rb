# frozen_string_literal: true

module JobManagementService
  module_function

  def call(resident_id)
    return unless resident_id

    scheduled_jobs = Delayed::Job.all

    plot_residencies = Resident.find(resident_id).plot_residencies
    plot_residency_ids = plot_residencies.map(&:id)

    scheduled_jobs.each do |job|
      job_resident_segment = job.handler.split("PlotResidency/").last
      job_plot_resident_id = job_resident_segment.split("\n").first

      job.delete if plot_residency_ids.include?(job_plot_resident_id.to_i)
    end
  end
end
