# frozen_string_literal: true

module Admin
  class AnalyticsController < ApplicationController
    load_and_authorize_resource :report

    def show; end
  end
end
