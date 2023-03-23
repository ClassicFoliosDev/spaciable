# frozen_string_literal: true

module Api
  module Resident
    module V1
      class FaqCategoryController < Api::Resident::ResidentController

        def index
          role = current_resident.plot_residency_role(@plot).to_s.capitalize
          faq_type = FaqType.find_by(name: role, country: @plot.developer.country)
          allfaqs = Faq.accessible_by(current_ability)
                    .where(faq_type: faq_type)

          categories = []
          faq_type.categories.each do |cat|
            faqs = allfaqs.where(faq_type: faq_type, faq_category: cat)
            faqs = faqs.where("created_at <= ?", @plot.expiry_date) if @plot.expiry_date.present?
            faqs = faqs.where(faq_package: :standard) if @plot.free?
            faqs = faqs.where(faq_package: %i[standard enhanced]) if @plot.essentials?
            categories << cat if faqs.any?
          end

          render json: categories.to_json, status: 200
        end
      end
    end
  end
end
