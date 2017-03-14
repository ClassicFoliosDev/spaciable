# frozen_string_literal: true
module Admin
  class DashboardController < ApplicationController
    skip_authorization_check

    def show; end
  end
end
