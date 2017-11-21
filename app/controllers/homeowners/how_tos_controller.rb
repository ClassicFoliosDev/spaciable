# frozen_string_literal: true

module Homeowners
  class HowTosController < Homeowners::BaseController
    skip_authorization_check
    load_and_authorize_resource :how_to

    def index
      @categories = HowTo.categories.keys
      @category = how_to_params[:category]
      tag_id = how_to_params[:tag]

      @how_tos = if tag_id
                   @category = nil
                   @tag = Tag.find(tag_id)
                   @tag.how_tos.includes(:how_to_tags)
                 else
                   @how_tos.where(category: @category).includes(:how_to_tags)
                 end
    end

    def show
      @others = HowTo.where(category: @how_to.category).where.not(id: @how_to.id)
    end

    private

    def how_to_params
      params.permit(:category, :tag)
    end
  end
end
