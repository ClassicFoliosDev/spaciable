# frozen_string_literal: true

module Homeowners
  class LibraryController < Homeowners::BaseController
    include TabsConcern
    skip_authorization_check
    before_action :set_categories

    after_action only: %i[index] do
      record_event(:view_library,
                   category1: t("activerecord.attributes.document.categories.#{@category}",
                                construction: @plot.my_construction_name))
    end

    after_action only: %i[appliance_manuals] do
      record_event(:view_library, category1: "Appliances")
    end

    def index
      @category = document_params[:category]

      @documents = Document.accessible_by(current_ability)
                           .where(category: @category)
                           .order(pinned: :desc, updated_at: :desc)
      @documents = remove_expired_plots if @plot.expiry_date.present?

      @appliances = []
      @homeowner = current_resident&.plot_residency_homeowner?(@plot)

      # If there are no documents of the required category, redirect to the next tab with content
      redirect_to first_populated_tab_after(@category) if @documents.none?
    end

    def update
      unless current_resident&.plot_residency_homeowner?(@plot)
        render json: {}, status: 401
        return
      end

      notice = update_plot_document(params[:id])

      render json: { notice: notice }, status: :ok
    end

    def appliance_manuals
      @category = "appliances"
      @appliances = []
      @appliances << Appliance.accessible_by(current_ability)
      @appliances << @plot.appliance_choices if @plot.choices_approved?
      @appliances.flatten!

      if @appliances.any?
        @documents = []
        render :index
      else
        redirect_to first_populated_tab_after(@category)
      end
    end

    private

    def remove_expired_plots
      @expiry_documents = []
      @documents.each do |document|
        uploader = User.find_by(id: document&.user_id)
        @expiry_documents << document && next if uploader&.cf_admin?
        @expiry_documents << document if document.created_at <= @plot.expiry_date
      end
      @expiry_documents
    end

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
