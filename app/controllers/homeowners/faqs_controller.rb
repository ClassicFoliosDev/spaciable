# frozen_string_literal: true
module Homeowners
  class FaqsController < Homeowners::BaseController
    skip_authorization_check
    load_and_authorize_resource :faq

    def index
      @category = faq_params[:category]
      @faqs = @faqs.where(category: @category)

      @categories = Faq.categories.keys
    end

    private

    def faq_params
      params.permit(:category)
    end
  end
end
