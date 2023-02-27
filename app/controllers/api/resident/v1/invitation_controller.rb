# frozen_string_literal: true

module Api
  module Resident
    module V1
      class InvitationController <  Devise::InvitationsController
        before_action -> { doorkeeper_authorize! }
        skip_before_action :verify_authenticity_token
        respond_to :json

        def update
          super do | resource |
            if params[:resident][:ts_and_cs_accepted] == "1"
              resource.update_column(:ts_and_cs_accepted_at, Time.zone.now)
            end
            render json: { id: resource.id,
                         first_name: resource.first_name,
                         last_name: resource.last_name,
                         phone: resource.phone_number,
                         email: resource.email,
                         residencies: resource.plot_residencies.pluck(:id) }, status: 200
            return
          end 
        end
      end
    end
  end
end
