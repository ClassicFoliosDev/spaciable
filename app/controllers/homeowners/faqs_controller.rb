# frozen_string_literal: true

module Homeowners
  class FaqsController < Homeowners::BaseController
    skip_authorization_check
    load_and_authorize_resource :faq

    def index
      @category = faq_params[:category]

      # Populate the categories before FAQs get filgtered below
      populate_categories

      @faqs = @faqs.where(category: @category)

      # Redirect if category empty and others available
      redirect_to homeowner_faqs_path(@categories[0]) if @faqs.none? && @categories.any?
    end

    private

    def faq_params
      params.permit(:category)
    end

    # Get the populated FAQ categories for the country
    def populate_categories
      @categories = []
      Faq.country_categories(@country).each do |cat|
        @categories << cat if @faqs.where(category: cat).any?
      end
    end
  end
end
