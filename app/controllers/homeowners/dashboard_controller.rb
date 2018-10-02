# frozen_string_literal: true

module Homeowners
  class DashboardController < Homeowners::BaseController
    skip_authorization_check

    def show
      @faqs = Faq.accessible_by(current_ability).order(updated_at: :desc).limit(5)
      @contacts = Contact.accessible_by(current_ability).order(updated_at: :desc).limit(4)
      build_documents
      build_articles
    end

    private

    def build_documents
      docs = Document.accessible_by(current_ability).order(updated_at: :desc).limit(6)
      appliances = Appliance.accessible_by(current_ability)
                            .includes(:appliance_manufacturer).order(updated_at: :desc).limit(6)
      @documents = DocumentLibraryService.call(docs, appliances)
    end

    def build_articles
      how_tos_limit = 5
      if @plot.enable_services?
        @services = Service.where.not(category: nil).order("RANDOM()").limit(2)
        how_tos_limit = 3
      end

      @how_tos = HowTo.active.order(featured: :asc).limit(how_tos_limit)
    end
  end
end
