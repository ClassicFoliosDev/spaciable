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
        @snag = Snag.find(params[:id])
        render template: "homeowners/snags/show",
               locals: { snag: @snag, snag_comment: @snag_comment }
      end
    end

    private

    def notify_and_redirect(snag_comment)
      snag_comment.update(commenter: current_resident)
      SnagMailer.snag_comment_to_admins(snag_comment).deliver
      redirect_to snag_path(id: snag_comment.snag_id)
    end

    def snag_comment_params
      params.require(:snag_comment).permit(:content, :image, :snag_id,
                                           :commenter)
    end
  end
end
