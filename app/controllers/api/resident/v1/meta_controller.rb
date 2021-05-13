# frozen_string_literal: true

module Api
  module Resident
    module V1
      class MetaController < Api::Resident::ResidentController
        def index
          render json: { id: current_resident.id,
                         first_name: current_resident.first_name,
                         last_name: current_resident.last_name,
                         phone: current_resident.phone_number,
                         email: current_resident.email }, status: 200
        end
      end
    end
  end
end
