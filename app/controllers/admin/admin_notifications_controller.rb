# frozen_string_literal: true

module Admin
  class AdminNotificationsController < ApplicationController
    include PaginationConcern
    include SortingConcern
    load_and_authorize_resource :admin_notification

    def index
      return redirect_to root_path unless current_user.cf_admin?
      @admin_notifications = @admin_notifications.includes(:send_to, :sender)
      @admin_notifications = paginate(sort(@admin_notifications, default: { sent_at: :desc }))
    end

    def new
      return redirect_to root_path unless current_user.cf_admin?
    end

    def show; end

    def create
      if @admin_notification.with_sender(current_user).valid?
        notify_and_redirect
      else
        render :new
      end
    end

    def sender
      @admin_notification = AdminNotification.find(params[:sender_id])
      @user_email = @admin_notification.user.email
    end

    private

    def notify_and_redirect
      send_email
      @admin_notification.save
      redirect_to %i[admin admin_notifications], notice: success_notice
    end

    def success_notice
      @admin_count = User.where.not(role: "cf_admin").count
      t(".success", admins_count: @admin_count)
    end

    # Use the AdminNotificationMailer to send the email
    def send_email
      AdminNotificationMailer.admin_notifications(@admin_notification,
                                                  admin_notification_params).deliver
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def admin_notification_params
      params.require(:admin_notification).permit(
        :subject,
        :message,
        :sent_at,
        :sender_id
      )
    end
  end
end
