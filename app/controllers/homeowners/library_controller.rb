# frozen_string_literal: true
module Homeowners
  class LibraryController < Homeowners::BaseController
    authorize_resource :document, :appliance

    before_action :set_categories

    def index
      @category = document_params[:category]

      @documents = Document.accessible_by(current_ability).where(category: @category)
      @appliances = []
    end

    def appliance_manuals
      @category = t(".appliances_category")

      @appliances = Appliance.accessible_by(current_ability).with_manuals
      @documents = []

      render :index
    end

    private

    def document_params
      params.permit(:category)
    end

    def set_categories
      @categories = Document.categories.keys
    end
  end
end
