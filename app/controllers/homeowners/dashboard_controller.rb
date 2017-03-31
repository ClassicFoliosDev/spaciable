# frozen_string_literal: true
module Homeowners
  class DashboardController < Homeowners::BaseController
    skip_authorization_check

    def show
      @faqs = Faq.accessible_by(current_ability).order(updated_at: :desc).limit(6)
      @contacts = Contact.accessible_by(current_ability).order(updated_at: :desc).limit(6)
      docs = Document.accessible_by(current_ability).order(updated_at: :desc).limit(6)
      appliances = Appliance.accessible_by(current_ability).order(updated_at: :desc).limit(6)
      @documents = DocumentLibraryService.call(docs, appliances)
      @how_tos = HowTo.all.order(featured: :desc).limit(5)
    end
  end
end
