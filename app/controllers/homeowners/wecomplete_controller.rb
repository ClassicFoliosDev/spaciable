# frozen_string_literal: true

module Homeowners
  class WecompleteController < Homeowners::BaseController
    skip_authorization_check

    after_action only: %i[show] do
      record_event(:view_conveyancing)
    end

    def show; end
  end
end
