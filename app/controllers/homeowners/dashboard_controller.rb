# frozen_string_literal: true
module Homeowners
  class DashboardController < Homeowners::BaseController
    skip_authorization_check

    def show
      @faqs = Faq.accessible_by(current_ability).order(updated_at: :desc).limit(5)
      @contacts = Contact.accessible_by(current_ability).order(updated_at: :desc).limit(4)
      docs = Document.accessible_by(current_ability).order(updated_at: :desc).first(5)
      appliances = Appliance.accessible_by(current_ability)
                            .with_manuals.order(updated_at: :desc).first(5)
      @documents = DocumentLibraryService.call(docs, appliances)
    end
  end
end
