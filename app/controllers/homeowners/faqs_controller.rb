# frozen_string_literal: true
module Homeowners
  class FaqsController < Homeowners::BaseController
    load_and_authorize_resource :faq

    def index
      @category = faq_params[:category]
      @faqs = @faqs.where(category: @category)

      @brand = current_resident.brand
      @plot = current_resident.plot
      @categories = Faq.categories.keys
    end

    private

    def faq_params
      params.permit(:category)
    end
  end
end
