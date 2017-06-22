# frozen_string_literal: true
module Homeowners
  class NotificationsController < Homeowners::BaseController
    include SortingConcern
    skip_authorization_check

    def index
      @notifications = []
      return unless current_resident

      @notifications = current_resident.notifications.order(sent_at: :desc).includes(:sender)
      @notifications.each do |notification|
        resident_notification = ResidentNotification.find_by(notification_id: notification.id,
                                                             resident_id: current_resident.id)
        notification.read_at = resident_notification.read_at
      end
      @unread_count = current_resident.resident_notifications.where(read_at: nil).count
    end

    def show
      @resident_notification = ResidentNotification
                               .find_by(notification_id: params[:notification_id],
                                        resident_id: current_resident.id)

      unless @resident_notification.read_at?
        @resident_notification.read_at = Time.current
        @resident_notification.save
        @unread_count = current_resident.resident_notifications.where(read_at: nil).count
      end

      render json: @unread_count
    end
  end
end
