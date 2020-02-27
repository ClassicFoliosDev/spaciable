# frozen_string_literal: true

module Homeowners
  class CommunicationPreferencesController < Homeowners::BaseController
    skip_authorization_check

    def show; end
  end
end
