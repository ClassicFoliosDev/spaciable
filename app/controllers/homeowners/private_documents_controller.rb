# frozen_string_literal: true

module Homeowners
  class PrivateDocumentsController < Homeowners::BaseController
    load_and_authorize_resource :private_document

    def index
      @categories = Document.categories.keys
      @category = "my_documents"
      @my_documents = current_resident&.private_documents || []
      @private_document ||= PrivateDocument.new
    end

    def create
      file_title = @private_document&.file&.filename&.split(".")
      @private_document.title = file_title[0].humanize if file_title
      if @private_document.save
        notice = t("controller.success.create", name: @private_document.title)
        redirect_to private_documents_path, notice: notice
      else
        alert = @private_document&.errors&.full_messages&.first
        redirect_to private_documents_path, alert: alert
      end
    end

    def update
      if @private_document.update(private_document_params)
        notice = t("controller.success.update", name: "Document")
      end

      redirect_to private_documents_path, notice: notice
    end

    def destroy
      @private_document.destroy

      notice = t("controller.success.destroy", name: @private_document.title)
      redirect_to private_documents_path, notice: notice
    end

    private

    def private_document_params
      params.require(:private_document).permit(:file, :title)
    end
  end
end
