# frozen_string_literal: true

module Homeowners
  class PrivateDocumentsController < Homeowners::BaseController
    load_and_authorize_resource :private_document

    def index
      @categories = Document.categories.keys
      @category = "my_documents"
      @private_document ||= PrivateDocument.new
      @homeowner = current_resident&.plot_residency_homeowner?(@plot)
    end

    def create
      file_title = @private_document&.file&.filename&.split(".")
      @private_document.title = file_title[0].humanize if file_title
      if @private_document.save
        @private_document.update_attributes(plot_id: @plot.id)
        notice = t("controller.success.create", name: @private_document.title)
        redirect_to private_documents_path, notice: notice
      else
        alert = @private_document&.errors&.full_messages&.first
        redirect_to private_documents_path, alert: alert
      end
    end

    def update
      plot_private_document = find_plot_private_document

      notice = if private_document_params[:enable_tenant_read] == "toggle"
                 toggle_shared(plot_private_document)
               elsif @private_document.update(private_document_params)
                 t("controller.success.update", name: @private_document.title)
               end

      if plot_private_document.nil? || notice.nil?
        render json: {}, status: 401
        return
      end

      render json: { notice: notice }, status: :ok
    end

    def destroy
      @private_document.destroy

      notice = t("controller.success.destroy", name: @private_document.title)
      redirect_to private_documents_path, notice: notice
    end

    private

    def toggle_shared(plot_private_document)
      return nil if current_resident.plot_residency_tenant?(@plot)

      if plot_private_document.enable_tenant_read.blank?
        plot_private_document.update_attributes(enable_tenant_read: true)
        t("homeowners.private_documents.update.shared", title: @private_document.title,
                                                        address: @plot.to_homeowner_s)
      else
        plot_private_document.update_attributes(enable_tenant_read: false)
        t("homeowners.private_documents.update.not_shared", title: @private_document.title,
                                                            address: @plot.to_homeowner_s)
      end
    end

    def find_plot_private_document
      return nil if @private_document.resident_id != current_resident.id

      PlotPrivateDocument.find_or_create_by!(plot_id: @plot.id,
                                             private_document_id: @private_document.id)
    end

    def private_document_params
      params.require(:private_document).permit(:file, :title, :enable_tenant_read)
    end
  end
end
