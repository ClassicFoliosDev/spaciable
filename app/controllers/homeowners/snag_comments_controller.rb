# frozen_string_literal: true

module Homeowners
  class SnagCommentsController < Homeowners::BaseController
    skip_authorization_check

    def new
      @snag_comment = SnagComment.new
    end

    def create
      @snag_comment = SnagComment.new(snag_comment_params)
      if @snag_comment.save
        notify_and_redirect(@snag_comment)
      else
        render partial: "form"
      end
    end

    private

    def notify_and_redirect(snag_comment)
      snag_comment.update_attributes(commenter: current_resident)
      SnagMailer.snag_comment_to_admins(snag_comment).deliver
      redirect_to snag_path(id: snag_comment.snag_id)
    end

    def snag_comment_params
      params.require(:snag_comment).permit(:content, :image, :snag_id,
                                           :commenter)
    end
  end
end
