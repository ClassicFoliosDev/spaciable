# frozen_string_literal: true

module Unlatch
  class SyncController < ApplicationController
    def sync_with_unlatch
      synchable = params[:linkable_class].constantize.find(params[:linkable_id])
      authorize! :update, synchable
      DeepSyncJob.perform_later(synchable)

      render json: { linkable_id: synchable.id,
                     sync_status: :working }, status: :ok
    end
  end
end
