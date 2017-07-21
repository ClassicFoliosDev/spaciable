# frozen_string_literal: true
module JobManagementService
  module_function

  def call(resident_id)
    scheduled_jobs = Sidekiq::ScheduledSet.new

    scheduled_jobs.each do |job|
      job_params = JSON.parse job.value
      job_global_id = job_params["args"][0]["arguments"][0]["_aj_globalid"]
      job_resident_id = job_global_id.split("/").last

      job.delete if job_resident_id.to_i == resident_id.to_i
    end
  end
end
