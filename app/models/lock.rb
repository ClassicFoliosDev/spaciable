# frozen_string_literal: true

# Lock to prevent multiple identical cron jobs
class Lock < ApplicationRecord
  enum job: %i[
    activation_report
    package_invoice
    notify_expiry_plots
    notify_expiry_residents
  ]

  # Create a temporary lock for the specified job and run the block
  # otherwise just return
  def self.run(job, &block)
    locked = Lock.create(job: job)
    block.call
  rescue ActiveRecord::RecordNotUnique
    nil
  ensure
    locked&.destroy
  end
end
