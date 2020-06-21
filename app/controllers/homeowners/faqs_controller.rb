# frozen_string_literal: true

module Homeowners
  class FaqsController < Homeowners::BaseController
    skip_authorization_check
    load_and_authorize_resource :faq_type
    load_and_authorize_resource :faq_category
    load_and_authorize_resource :faq

    before_action :authorise, only: %[index]

    def index
      # identify all the populated categories
      populate_categories

      # filter FAQs by category
      @faqs = @faqs.where(faq_type: @faq_type, faq_category: @faq_category)
      @faqs = @faqs.where("created_at <= ?", @plot.expiry_date) if @plot.expiry_date.present?

      # Redirect if category empty and others available
      redirect_to faq_type_homeowner_faqs_path(@faq_type, @categories.first) if @faqs.none? && @categories.any?
    end

    private

    def faq_params
      params.permit(:category)
    end

    # Get the populated FAQ categories
    def populate_categories
      @categories = []
      @faq_type.categories.each do |cat|
        faqs = @faqs.where(faq_type: @faq_type, faq_category: cat)
        faqs = faqs.where("created_at <= ?", @plot.expiry_date) if @plot.expiry_date.present?
        @categories << cat if faqs.any?
      end
    end

    def authorise
      authorize! :index, FaqType
      @faq_type = FaqType.find(params[:faq_type])
      authorize! :index, FaqCategory
      @faq_category = FaqType.find(params[:faq_category])
    end
  end
end
