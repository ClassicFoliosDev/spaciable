# frozen_string_literal: true

module Api
  module Resident
    module V1
      class PasswordController <  Devise::PasswordsController
        before_action -> { doorkeeper_authorize! }
        before_action -> { RequestStore.store[:living_req] = true }
        skip_before_action :verify_authenticity_token
        respond_to :json

        def update
          super do | resource |
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
