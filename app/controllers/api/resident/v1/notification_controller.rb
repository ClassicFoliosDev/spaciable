# frozen_string_literal: true

module Api
  module Resident
    module V1
      class NotificationController < Api::Resident::ResidentController

        def index
          render json: ResidentNotification.joins(:notification)
                                           .where(resident_id: current_resident.id)
                                           .order(created_at: :desc)
                                           .select("notifications.id, " +
                                                   "notifications.subject, " +
                                                   "notifications.message, " + 
                                                   "notifications.sent_at, " + 
                                                   "resident_notifications.read_at"), status: 200
        end

        def destroy
          ResidentNotification.where(resident_id: current_resident.id)
                              .where(notification_id: params[:id]).destroy_all

          render json: {}, status: Rack::Utils::SYMBOL_TO_STATUS_CODE[:ok]
        end
      end
    end
  end
end
