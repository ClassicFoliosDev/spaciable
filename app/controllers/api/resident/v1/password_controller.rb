# frozen_string_literal: true

module Api
  module Resident
    module V1
      class PasswordController < Devise::PasswordsController
        before_action -> { doorkeeper_authorize! }
        before_action -> { RequestStore.store[:living_req] = true }
        skip_before_action :verify_authenticity_token
        respond_to :json

        def create
          status = Rack::Utils::SYMBOL_TO_STATUS_CODE[:ok]
          resource = ::Resident.find_by(email: params[:resident][:email])
          status = Rack::Utils::SYMBOL_TO_STATUS_CODE[:not_found] if resource.blank?
          token = resource&.reset_token
          render json: { id: resource&.id, reset_token: token }, status: status
        end

        def update
          super do |resource|
            render json: { id: resource.id,
                           first_name: resource.first_name,
                           last_name: resource.last_name,
                           phone: resource.phone_number,
                           email: resource.email,
                           residencies: resource.plot_residencies.pluck(:id) }, status: :ok
            return
          end
        end

        # authenticate user and password
        # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
        def authenticate
          status = Rack::Utils::SYMBOL_TO_STATUS_CODE[:ok]
          resource = ::Resident.find_for_authentication(email: params[:resident][:email])
          if resource.blank?
            status = Rack::Utils::SYMBOL_TO_STATUS_CODE[:not_found]
          elsif !resource&.valid_password?(params[:resident][:password])
            status = Rack::Utils::SYMBOL_TO_STATUS_CODE[:unauthorized]
          end

          case status
          when Rack::Utils::SYMBOL_TO_STATUS_CODE[:ok]
            render json: { id: resource.id,
                           first_name: resource.first_name,
                           last_name: resource.last_name,
                           phone: resource.phone_number,
                           email: resource.email,
                           residencies: resource.plot_residencies.pluck(:id) }, status: status
          else
            render json: {}, status: status
          end
        end
        # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

        # rubocop:disable Rails/SkipsModelValidations
        def register_living_resident
          status = Rack::Utils::SYMBOL_TO_STATUS_CODE[:ok]
          resident = ::Resident.find_by(id: params["resident_id"])

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
