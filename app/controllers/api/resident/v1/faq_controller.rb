# frozen_string_literal: true

module Api
  module Resident
    module V1
      class FaqController < Api::Resident::ResidentController

        def index
          role = current_resident.plot_residency_role(@plot).to_s.capitalize
          faq_type = FaqType.find_by(name: role, country: @plot.developer.country)
          allfaqs = Faq.accessible_by(current_ability).where(faq_type: faq_type)

          faqs = allfaqs.where(faq_category: params[:faq_category])
          faqs = faqs.where("created_at <= ?", @plot.expiry_date) if @plot.expiry_date.present?
          faqs = faqs.where(faq_package: :standard) if @plot.free?
          faqs = faqs.where(faq_package: %i[standard enhanced]) if @plot.essentials?
          
          render json: faqs.to_json, status: 200
        end
      end
    end
  end
end
