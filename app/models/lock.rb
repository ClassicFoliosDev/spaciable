# frozen_string_literal: true

class Lock < ApplicationRecord
  enum job: %i[
    activation_report
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
