# frozen_string_literal: true

module JobManagementService
  module_function

  def call(resident_id)
    return unless resident_id

    scheduled_jobs = Delayed::Job.all

    scheduled_jobs.each do |job|
      job_resident_segment = job.handler.split("PlotResidency/").last
      job_resident_id = job_resident_segment.split("\n").first

      job.delete if job_resident_id.to_i == resident_id.to_i
    end
  end
end
