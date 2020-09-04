# frozen_string_literal: true

module Homeowners
  class FaqsController < Homeowners::BaseController
    include Ahoy::AnalyticsHelper
    skip_authorization_check
    load_and_authorize_resource :faq_type
    load_and_authorize_resource :faq_category
    load_and_authorize_resource :faq, except: %i[feedback]

    before_action :authorise, only: %i[index]

    after_action only: %i[index] do
      record_event(:view_FAQs, type: @faq_type.name, category1: @faq_category.name)
    end

    before_action only: %i[feedback] do
      record_event(:view_FAQs_feedback,
                   category1: params[:question],
                   category2: params[:response] == "0" ? "No" : "Yes")
    end

    def index
      populate

      # filter FAQs by category
      @category_faqs = @faqs.where(faq_type: @faq_type, faq_category: @faq_category)

      return if @plot.expiry_date.blank?

      @category_faqs = @category_faqs.where("created_at <= ?", @plot.expiry_date)
    end

    def feedback
      # convert params to hash to pass to job
      data = {}
      params.each { |k, v| data[k.to_sym] = v }

      FaqFeedbackJob.perform_later(data)
      render json: ""
    end

    private

    # This controller can be called with defaults (faq_type 0 and or
    # faq_categtory 0).  In this case choose the first populated category
    # of the first populated type.  If nothing is populated pick the
    # first type and/or category as appropriate
    def populate
      if @faq_type.nil?
        faq_types = @plot.development.faq_types
        @faq_type = faq_types.first
        faq_types.each do |faq_type|
          if @faqs.where(faq_type: faq_type).count.positive?
            @faq_type = faq_type
            break
          end
        end
      end

      # populate the categories
      populate_categories

      # if the requested category isn't populated
      return unless @categories.exclude?(@faq_category)

      # reset the categtory to the first populated
      @faq_category = @categories.first if @categories.any?
    end

    # Get the populated FAQ categories
    def populate_categories
      @categories = []
      @faq_type.categories.each do |cat|
        faqs = @faqs.where(faq_type: @faq_type, faq_category: cat)
        faqs = faqs.where("created_at <= ?", @plot.expiry_date) if @plot.expiry_date.present?
        @categories << cat if faqs.any?
      end

      return unless @categories.empty?

      @categories << @faq_type.categories.first
    end

    def authorise
      authorize! :index, FaqType
      @faq_type = FaqType.find_by(id: params[:faq_type])
      authorize! :index, FaqCategory
      @faq_category = FaqCategory.find_by(id: params[:faq_category])
    end
  end
end
