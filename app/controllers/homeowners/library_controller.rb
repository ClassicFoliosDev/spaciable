# frozen_string_literal: true

module Homeowners
  class LibraryController < Homeowners::BaseController
    skip_authorization_check
    before_action :set_categories

    def index
      @category = document_params[:category]
      @documents = Document.accessible_by(current_ability).where(category: @category)
      @appliances = []
      @homeowner = current_resident&.plot_residency_homeowner?(@plot)
    end

    def update
      unless current_resident.plot_residency_homeowner?(@plot)
        render json: {}, status: 401
        return
      end

      notice = update_plot_document(params[:id])

      render json: { notice: notice }, status: :ok
    end

    def appliance_manuals
      @category = "appliances"

      @appliances = Appliance.accessible_by(current_ability)
      @documents = []

      render :index
    end

    private

    def update_plot_document(document_id)
      document = Document.find(document_id)
      plot_document = PlotDocument.find_or_create_by!(plot_id: @plot.id, document_id: document_id)

      if plot_document.enable_tenant_read.blank?
        plot_document.update_attributes(enable_tenant_read: true)
        t(".shared", title: document.title, address: @plot.to_homeowner_s)
      else
        plot_document.update_attributes(enable_tenant_read: false)
        t(".not_shared", title: document.title, address: @plot.to_homeowner_s)
      end
    end

    def document_params
      params.permit(:category)
    end

    def set_categories
      @categories = Document.categories.keys
    end
  end
end
