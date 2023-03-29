# frozen_string_literal: true

module Api
  module Resident
    module V1
      class PreferencesController < ActionController::Base
        before_action -> { doorkeeper_authorize! }
        before_action -> { RequestStore.store[:living_req] = true }

        # rubocop:disable LineLength
        def update
          status = Rack::Utils::SYMBOL_TO_STATUS_CODE[:ok]
          resident = ::Resident.find_by(id: params[:resident][:id],
                                        email: params[:resident][:email])
          status = Rack::Utils::SYMBOL_TO_STATUS_CODE[:not_found] if resident.blank?
          if resident.present?
            resident.developer_email_updates = params[:resident][:developer_email_updates] == "1" ? true : nil
            resident.telephone_updates = params[:resident][:telephone_updates] == "1" ? true : nil
            resident.save!
          end
          render json: {}, status: status
        end
        # rubocop:enable LineLength
      end
    end
  end
end
