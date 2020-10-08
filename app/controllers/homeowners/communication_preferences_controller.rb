# frozen_string_literal: true

module Homeowners
  class CommunicationPreferencesController < Homeowners::BaseController
    skip_authorization_check

    after_action only: %i[show] do
      record_event(:homeowner_sign_in,
                   category1: I18n.t("ahoy.#{Ahoy::Event::ACCEPT_INVITATION}"))
    end

    def show; end
  end
end
