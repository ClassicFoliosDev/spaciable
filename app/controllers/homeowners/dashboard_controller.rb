# frozen_string_literal: true

module Homeowners
  class DashboardController < Homeowners::BaseController
    skip_authorization_check

    def show
      @faqs = Faq.accessible_by(current_ability).order(updated_at: :desc).limit(5)
      @contacts = Contact.accessible_by(current_ability).order(updated_at: :desc).limit(4)
      @referral = Referral.new
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
      how_tos_limit = 4
      if @plot.enable_services?
        @services = Service.where(category: %i[finance legal])
        how_tos_limit = 2
      end

      # Filter the HowTo records according to the country
      @how_tos = HowTo.active.order(featured: :asc)
                      .where(country_id: @country.id)
                      .limit(how_tos_limit)
    end
  end
end
