# frozen_string_literal: true

module Homeowners
  class DashboardController < Homeowners::BaseController
    skip_authorization_check

    def show
      faqs = Faq.accessible_by(current_ability)
      faqs = faqs.where("created_at <= ?", @plot.expiry_date) if @plot.expiry_date.present?
      @faqs = faqs.order(updated_at: :desc).limit(5)

      contacts = Contact.accessible_by(current_ability)
      contacts = contacts.where("created_at <= ?", @plot.expiry_date) if @plot.expiry_date.present?
      @contacts = contacts.order(updated_at: :desc).limit(4)

      @referral = Referral.new
      build_documents
      build_articles
    end

    private

    def build_documents
      docs = Document.accessible_by(current_ability)
      docs = docs.where("created_at <= ?", @plot.expiry_date) if @plot.expiry_date.present?
      docs = docs.order(updated_at: :desc).limit(6)

      appliances = Appliance.accessible_by(current_ability)
                            .includes(:appliance_manufacturer).order(updated_at: :desc).limit(6)
      @documents = DocumentLibraryService.call(docs, appliances)
    end

    def build_articles
      if @plot.enable_services?
        @services = Service.where(category: %i[finance legal])
        how_tos_limit = @plot.enable_referrals? ? 2 : 3
      else
        how_tos_limit = @plot.enable_referrals? ? 4 : 5
      end

      # Filter the HowTo records according to the country
      @how_tos = HowTo.active.order(featured: :asc)
                      .where(country_id: @country.id)
                      .limit(how_tos_limit)
    end
  end
end
