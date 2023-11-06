# frozen_string_literal: true

class DeepSyncJob < ApplicationJob
  queue_as :mailer

  def perform(synchable)
    synchable&.unlatch_deep_sync
  end
end
