# frozen_string_literal: true

module Homeowners
  class SnagAttachmentsController < Homeowners::BaseController
    skip_authorization_check
    before_action :set_snag_attachment, only: %i[show edit update destroy]

    def index
      @snag_attachments = SnagAttachment.all
    end

    def show; end

    def new
      @snag_attachment = SnagAttachment.new
    end

    def edit; end

    def create
      @snag_attachment = SnagAttachment.new(snag_attachment_params)
      if @snag_attachment.save
        redirect_to snags_path
      else
        render :new
      end
    end

    def update
      redirect_to @snag_attachment.snag, notice: t(".update_success") if
        @snag_attachment.update(snag_attachment_params)
    end

    def destroy
      @snag_attachment.destroy
      redirect_to @snag_attachment.snag, notice: t(".delete_success")
    end

    private

    def set_snag_attachment
      @snag_attachment = SnagAttachment.find(params[:id])
    end

    def snag_attachment_params
      params.require(:snag_attachment).permit(:snag_id, :image)
    end
  end
end
