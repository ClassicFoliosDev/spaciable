# frozen_string_literal: true
module Homeowners
  class HowTosController < Homeowners::BaseController
    load_and_authorize_resource :how_to

    def index
      @category = how_to_params[:category]
      @how_tos = @how_tos.where(category: @category)

      @categories = HowTo.categories.keys
    end

    private

    def how_to_params
      params.permit(:category)
    end
  end
end
