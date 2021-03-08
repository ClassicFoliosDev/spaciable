# frozen_string_literal: true

module Admin
  class NotificationsController < ApplicationController
    include PaginationConcern
    include SortingConcern
    load_and_authorize_resource :notification

    def index
      @notifications = @notifications.includes(:send_to, :sender)
      @notifications = subject_filter
      @notifications = paginate(sort(@notifications, default: { sent_at: :desc }))
    end

    def new
      current_user.assign_permissionable_ids
    end

    def show; end

    def create
      @notification = NotificationSendService.call(@notification, notification_params)
      if @notification.with_sender(current_user).valid?
        notify_and_redirect
      else
        render :new
      end
    end

    private

    def subject_filter
      @notifications = @notifications.where
                                     .not(subject:
                                          I18n.t("resident_snag_mailer.notify.new_notification"))
      @notifications = @notifications.where
                                     .not(subject:
                                          I18n.t("resident_notification_mailer.notify.old"))
      @notifications.where
                    .not(subject: I18n.t("resident_notification_mailer.notify.update_subject"))
    end

    def notify_and_redirect
      ResidentNotifierService.call(@notification) do |residents, missing_residents|
        notice = t(".success", notification_name: @notification.to_s, count: residents.count)

        if missing_residents.any?
          alert = t(".missing_residents",
                    plot_numbers: missing_residents.to_sentence,
                    count: missing_residents.count)
        end

        redirect_to %i[admin notifications], notice: notice, alert: alert
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def notification_params
      params.require(:notification).permit(
        :subject,
        :message,
        :sent_at,
        :send_to_id, :send_to_type,
        :send_to_all, :send_to_role, :plot_filter,
        :developer_id, :division_id, :development_id, :phase_id,
        :range_from, :range_to, :list
      )
    end
  end
end
