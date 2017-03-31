# frozen_string_literal: true
module Admin
  class HowTosController < ApplicationController
    include PaginationConcern
    include SortingConcern
    load_and_authorize_resource :how_to

    def index
      @how_tos = paginate(sort(@how_tos, default: { featured: :desc }))
    end

    def new
    end

    def create
      if @how_to.save
        redirect_to admin_how_tos_path, notice: t("controller.success.create", name: @how_to)
      else
        render :new
      end
    end

    def update
      if @how_to.update(how_to_params)
        redirect_to admin_how_tos_path, notice: t("controller.success.update", name: @how_to)
      else
        render :edit
      end
    end

    def show
    end

    def edit
    end

    def destroy
      @how_to.destroy
      notice = t("controller.success.destroy", name: @how_to)
      redirect_to admin_how_tos_path, notice: notice
    end

    private

    def how_to_params
      params.require(:how_to).permit(
        :title,
        :summary,
        :category,
        :description,
        :featured,
        :picture,
        :picture_cache
      )
    end
  end
end
