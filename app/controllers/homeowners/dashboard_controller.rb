# frozen_string_literal: true

module Homeowners
  class DashboardController < Homeowners::BaseController
    skip_authorization_check

    before_action :fetch_faqs, only: [:show]
    before_action :fetch_contacts, only: [:show]

    def show
      @referral = Referral.new

      @services_params = build_services_params if current_resident

      build_documents
      build_articles
    end

    private

    def fetch_faqs
      faqs = Faq.accessible_by(current_ability)
      faqs = faqs.where("created_at <= ?", @plot.expiry_date) if @plot.expiry_date.present?
      @faqs = faqs.order(updated_at: :desc).limit(5)
    end

    def fetch_contacts
      contacts = Contact.accessible_by(current_ability)
      contacts = contacts.where("created_at <= ?", @plot.expiry_date) if @plot.expiry_date.present?
      @contacts = contacts.order(updated_at: :desc).limit(4)
    end

    def build_services_params
      # params for referral link
      name = [current_resident.first_name, current_resident.last_name].compact.join(" ")
      email = current_resident.email
      phone = current_resident&.phone_number
      developer = @plot.developer
      "?sf_name=#{name}&sf_email=#{email}&sf_telephone=#{phone}&sf_developer=#{developer}"
    end

    def build_documents
      docs = Document.accessible_by(current_ability)
      docs = docs.where("created_at <= ?", @plot.expiry_date) if @plot.expiry_date.present?
      docs = docs.order(updated_at: :desc).limit(6)

      appliances = Appliance.accessible_by(current_ability)
                            .includes(:appliance_manufacturer).order(updated_at: :desc).limit(6)
      @documents = DocumentLibraryService.call(docs, appliances)
    end

    def build_articles
      how_tos_limit = if @plot.enable_services?
                        @plot.enable_referrals? ? 3 : 4
                      else
                        @plot.enable_referrals? ? 4 : 5
                      end

      # Filter the HowTo records according to the country
      @how_tos = HowTo.active.order(featured: :asc)
                      .where(country_id: @country.id)
                      .limit(how_tos_limit)
    end
  end
end
