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
                   @tag.how_tos.active.includes(:how_to_tags).order(created_at: :desc)
                 else
                   @how_tos.active.where(category: @category)
                           .includes(:how_to_tags).order(created_at: :desc)
                 end
    end

    def show
      @others = HowTo.active.where(category: @how_to.category).where.not(id: @how_to.id)
    end

    private

    def how_to_params
      params.permit(:category, :tag)
    end
  end
end
