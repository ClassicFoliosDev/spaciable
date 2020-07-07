# frozen_string_literal: true

module Homeowners
  class CalendarController < Homeowners::BaseController
    skip_authorization_check

    def index; end
  end
end
