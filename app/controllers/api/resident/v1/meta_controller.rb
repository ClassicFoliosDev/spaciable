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
                         email: current_resident.email,
                         residencies: current_resident.plot_residencies.pluck(:id) }, status: :ok
        end

        # rubocop:disable Rails/SkipsModelValidations
        def register_living_resident
          status = Rack::Utils::SYMBOL_TO_STATUS_CODE[:ok]
          resident = ::Resident.find(params["resident_id"])

          status = Rack::Utils::SYMBOL_TO_STATUS_CODE[:not_found] unless
                   resident&.has_living_plot?

          if status == Rack::Utils::SYMBOL_TO_STATUS_CODE[:ok]
            resident.update_column(:living, true)
          end

          render json: {}, status: status
        end
        # rubocop:enable Rails/SkipsModelValidations
      end
    end
  end
end
