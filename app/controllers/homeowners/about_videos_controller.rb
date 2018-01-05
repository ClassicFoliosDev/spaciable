# frozen_string_literal: true

module Homeowners
  class AboutVideosController < Homeowners::BaseController
    def show
      @setting = Setting.first
    end
  end
end
