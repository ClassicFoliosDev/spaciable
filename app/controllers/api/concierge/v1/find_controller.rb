# frozen_string_literal: true

module Api
  module Concierge
    module V1
      class FindController < Api::Concierge::ConciergeController
        def find_resident
          render json: { message: "OK", result: 1 }, status: :ok
        end

        private

        def find_params
          params.require(:pre_sale).permit(
            :development, :phase, :plot_number, :email, :phone_number, :first_name, :last_name
          )
        end
      end
    end
  end
end
