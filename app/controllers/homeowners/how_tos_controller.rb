# frozen_string_literal: true

module Homeowners
  class HowTosController < Homeowners::BaseController
    skip_before_action :validate_ts_and_cs, :set_plot, :set_brand,
                       unless: -> { current_resident || current_user }
    load_and_authorize_resource :how_to, except: %i[list_how_tos show_how_to]

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

    def list_how_tos
      category = :home
      category = params[:category] if params[:category]

      how_tos = HowTo.where(category: category).order(created_at: :desc)

      render json: how_tos, status: 200
    end

    def show
      @others = HowTo.active.where(category: @how_to.category).where.not(id: @how_to.id)
    end

    def show_how_to
      @how_to = HowTo.find(params[:id])

      render json: @how_to, status: 200
    rescue ActiveRecord::RecordNotFound
      render json: "", status: 404
    end

    private

    def how_to_params
      params.permit(:category, :tag)
    end
  end
end
