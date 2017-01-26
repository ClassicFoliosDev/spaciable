# frozen_string_literal: true
module Admin
  class NotificationsController < ApplicationController
    include PaginationConcern
    include SortingConcern
    load_and_authorize_resource :notification

    def index
      @notifications = @notifications.includes(:send_to)
      @notifications = paginate(sort(@notifications, default: { sent_at: :desc }))
    end

    def new
      current_user.assign_permissionable_ids
    end

    def show
    end

    def create
      if @notification.with_sender(current_user).valid?
        @notification.save
        residents = ResidentNotifierService.new(@notification).notify_residents

        notice = t(
          ".success",
          notification_name: @notification.to_s,
          recipient_count: residents.count
        )
        redirect_to [:admin, :notifications], notice: notice
      else
        render :new
      end
    end

    private

    # Never trust parameters from the scary internet, only allow the white list through.
    def notification_params
      params.require(:notification).permit(
        :subject,
        :message,
        :sent_at,
        :send_to_id,
        :send_to_type,
        :developer_id,
        :division_id,
        :development_id,
        :phase_id
      )
    end
  end
end
