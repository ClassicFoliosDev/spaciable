# frozen_string_literal: true
module Homeowners
  class DashboardController < Homeowners::BaseController
    skip_authorization_check

    def show
      @faqs = Faq.accessible_by(current_ability).order(created_at: :desc).limit(5)
      @contacts = Contact.accessible_by(current_ability)
    end

    def ts_and_cs
    end

    def data_policy
    end
  end
end
