# frozen_string_literal: true

module Unlatch
  class SyncController < ApplicationController
 
    def sync_with_unlatch
      linkable = params[:linkable_class].constantize.find(params[:linkable_id])
      authorize! :update, linkable
      linkable.sync_with_unlatch
      linkable.reload
      
      render json: { linkable_id: linkable.id,
                     sync_status: (linkable.paired_with_unlatch? ? :linked : :unlinked) }, status: 200
    end
  end

end
