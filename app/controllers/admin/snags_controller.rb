# frozen_string_literal: true

module Admin
  class SnagsController < ApplicationController
    skip_authorization_check

    include PaginationConcern
    include SortingConcern

    load_and_authorize_resource :developer
    load_and_authorize_resource :division
    load_and_authorize_resource :development
    load_and_authorize_resource :phase
    load_and_authorize_resource :unit_type
    load_and_authorize_resource :plot
    load_resource :snag, through:
      %i[developer division development phase unit_type plot], shallow: true

    def index
      @snags = Snag.where(plot_id: params[:id])
      @snags = paginate(sort(@snags))
    end

    def show
      @snag_comment = SnagComment.new
      @snag_comments = @snag.snag_comments
    end

    def update
      @snag.update(snag_params)
      notify_and_redirect
    end

    private

    def notify_and_redirect
      plot = @snag.plot
      update = I18n.t("resident_snag_mailer.notify.new_status")
      ResidentSnagMailer.snag_status_email(@snag, current_user).deliver
      ResidentSnagService.call(current_user, update, plot)
      redirect_to admin_snag_path(id: @snag.id), notice: t(".status_updated")
    end

    def snag_params
      params.require(:snag).permit(:status)
    end
  end
end
