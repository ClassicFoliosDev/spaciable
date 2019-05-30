# frozen_string_literal: true

module Homeowners
  class ChoicesController < Homeowners::BaseController
    include ChoiceConcern
    skip_authorization_check

    before_action :build_short_choices, only: [:edit]

    def edit
      @status = @plot.committed_by_homeowner? ? :show : :edit
      notify
      @active_tab = "choices"
    end

    def update
      success, error = RoomChoice.renew(@plot.id,
                                        JSON.parse(params[:choice_selections]),
                                        update_status)
      if success
        if update_status == :committed_by_homeowner
          ChoiceMailer.homeowner_choices_selected(@plot, current_resident.email)
                      .deliver
        end

        notice = t("choices.homeowner.#{update_status}") if notice.nil?
        redirect_to homeowners_choices_path, notice: notice
      else
        redirect_to homeowners_choices_path, alert: error
      end
    end

    def notify
      return if @status == :edit && !@plot.choices_rejected?

      flash.now[:notice] = t("choices.homeowner.#{@plot.choice_selection_status}")
    end

    def update_status
      case params[:commit]
      when t("choices.save")
        :homeowner_updating
      when t("choices.confirm")
        :committed_by_homeowner
      end
    end
  end
end
