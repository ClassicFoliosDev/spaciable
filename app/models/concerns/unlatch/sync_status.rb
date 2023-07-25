# frozen_string_literal: true

module Unlatch
  module SyncStatus
    extend ActiveSupport::Concern

    included do
      enum sync_status: %i[
        unsynchronised
        no_match
        synchronised
        failed_to_synchronise
      ]
    end
  end
end
