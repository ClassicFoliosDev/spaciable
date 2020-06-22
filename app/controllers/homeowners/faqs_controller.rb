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
      @faqs = @faqs.where("created_at <= ?", @plot.expiry_date) if @plot.expiry_date.present?

      # Redirect if category empty and others available
      redirect_to homeowner_faqs_path(@categories[0]) if @faqs.none? && @categories.any?
    end

    def feedback
      puts "#############################"
      byebug
      FaqFeedbackJob.perform_later(params[:question])
      render json: ""
    end

    private

    def faq_params
      params.permit(:category)
    end

    # Get the populated FAQ categories for the country
    def populate_categories
      @categories = []
      Faq.country_categories(@country).each do |cat|
        faqs = @faqs.where(category: cat)
        faqs = faqs.where("created_at <= ?", @plot.expiry_date) if @plot.expiry_date.present?
        @categories << cat if faqs.any?
      end
    end
  end
end
