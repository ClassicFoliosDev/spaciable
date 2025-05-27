# frozen_string_literal: true

module Admin
  class SnagCommentsController < ApplicationController
    skip_authorization_check

    def new
      @snag_comment = SnagComment.new
    end

    def create
      @snag_comment = SnagComment.new(snag_comment_params)
      if @snag_comment.save
        notify_and_redirect(@snag_comment)
      else
        @snag = Snag.find(params[:id])
        render template: "admin/snags/show",
               locals: { snag: @snag, snag_comment: @snag_comment }
      end
    end

    private

    def notify_and_redirect(snag_comment)
      snag_comment.update(commenter: current_user)
      ResidentSnagMailer.snag_comment_email(snag_comment).deliver
      resident_notification(snag_comment)
      redirect_to admin_snag_path(id: snag_comment.snag_id)
    end

    def resident_notification(snag_comment)
      plot = snag_comment.plot
      update = I18n.t("resident_snag_mailer.notify.new_comment")
      ResidentSnagService.call(current_user, update, plot)
    end

    def snag_comment_params
      params.require(:snag_comment).permit(:content, :image, :snag_id,
                                           :commenter)
    end
  end
end
