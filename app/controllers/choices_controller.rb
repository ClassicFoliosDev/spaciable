# frozen_string_literal: true

class ChoicesController < ApplicationController
  include ChoiceConcern
  load_and_authorize_resource :plot, through: %i[development phase], shallow: true

  before_action :set_parent
  before_action :build_full_choices, only: [:edit]

  def edit
    set_status
    give_notice
    @active_tab = "choices"
  end

  def update
    success, error = RoomChoice.renew(params[:plot_id],
                                      JSON.parse(params[:choice_selections]),
                                      update_status)
    if success
      notice = notify
      notice = t("choices.admin.update.#{update_status}", plot_name: @plot.number) if notice.nil?
      redirect_to @plot, notice: notice
    else
      redirect_to plot_choices_path, alert: error
    end
  end

  # rubocop:disable Naming/MemoizedInstanceVariableName
  def set_parent
    @parent ||= @phase || @development || @plot&.parent
  end
  # rubocop:enable Naming/MemoizedInstanceVariableName

  def set_status
    @status = :edit
    @status = :acceptreject if @plot.committed_by_homeowner?
    @status = :approved if @plot.choices_approved?
  end

  def give_notice
    return if @plot.no_choices_made? || @plot.admin_updating?

    flash.now[:notice] = t("choices.admin.#{@plot.choice_selection_status}",
                           plot_name: @plot.number)
  end

  def update_status
    case params[:commit]
    when t("choices.save")
      :admin_updating
    when "Approve"
      :choices_approved
    when "Reject"
      :choices_rejected
    end
  end

  # create the notification of rejection
  def notification
    notification_params = {
      subject: "Home Choices Declined",
      message: params[:notification],
      sent_at: Time.zone.today.strftime("%d %B %Y"),
      send_to_role: "homeowner"
    }
    @notification = Notification.new(notification_params)
    notification_params[:phase_id] = @plot.phase_id
    notification_params[:developer_id] = @plot.developer_id
    notification_params[:list] = @plot.number
    @notification = NotificationSendService.call(@notification, notification_params)
  end

  # Notify the admins/homeowners of the change in status
  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def notify
    notice = nil
    if update_status == :choices_rejected &&
       @plot.homeowners.present?
      if notification.with_sender(current_user).valid?
        ResidentNotifierService.call(@notification) do |_residents, _missing|
          notice = t("choices.admin.homeowner_notified_of_rejection", plot_name: @plot.number)
        end

        ChoiceMailer.homeowner_choices_rejected(@plot, params[:notification]).deliver_later
      end
    end

    if update_status == :choices_approved
      ChoiceMailer.homeowner_choices_approved(@plot).deliver_later if @plot.homeowners.present?
      ChoiceMailer.admin_approved_choices(@plot, current_user.email).deliver
    end

    notice
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize
end
