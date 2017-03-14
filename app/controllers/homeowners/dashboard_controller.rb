# frozen_string_literal: true
module Homeowners
  class DashboardController < Homeowners::BaseController
    skip_authorization_check

    def show
      @faqs = Faq.accessible_by(current_ability).order(updated_at: :desc).limit(5)
      @contacts = Contact.accessible_by(current_ability).order(updated_at: :desc).limit(5)
      @documents = Document.accessible_by(current_ability).order(updated_at: :desc).limit(5)
    end

    def ts_and_cs; end

    def data_policy; end
  end
end
