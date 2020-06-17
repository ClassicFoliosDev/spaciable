# frozen_string_literal: true

module Homeowners
  class CustomLinksController < Homeowners::BaseController
    def show
      redirect_to root_url unless params[:title]
    end
  end
end
