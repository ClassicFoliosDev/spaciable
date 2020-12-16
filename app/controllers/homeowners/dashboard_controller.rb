# frozen_string_literal: true

module Homeowners
  class DashboardController < Homeowners::BaseController
    skip_authorization_check

    layout "dashboard", only: %i[show]

    before_action :fetch_faqs, only: [:show]
    before_action :fetch_contacts, only: [:show]

    after_action only: %i[show] do
      record_event(session[:sign_in] ? :homeowner_sign_in : :view_main_menu,
                   category1: session[:sign_in] ? I18n.t("ahoy.#{Ahoy::Event::LOG_IN}") : nil)
      session[:sign_in] = false
    end

    def show
      # remove onboarding session (used to hide navigation)
      session[:onboarding] = nil

      @all_docs = Document.accessible_by(current_ability)
      @custom_tiles = CustomTile.active_tiles(@plot, @all_docs)

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
      @contacts = contacts.order(pinned: :desc, updated_at: :desc).limit(4)
    end

    def build_documents
      docs = @all_docs
      docs = docs.where("created_at <= ?", @plot.expiry_date) if @plot.expiry_date.present?
      docs = docs.order(pinned: :desc, updated_at: :desc).limit(6)

      appliances = Appliance.accessible_by(current_ability)
                            .includes(:appliance_manufacturer).order(updated_at: :desc).limit(6)
      @documents = DocumentLibraryService.call(docs, appliances)
    end

    def build_articles
      how_tos_limit = Plot::DASHBOARD_TILES - @custom_tiles.size

      # Filter the HowTo records according to the country
      @how_tos = HowTo.active.order(featured: :asc)
                      .where(country_id: @country.id)
                      .limit(how_tos_limit)
    end
  end
end
