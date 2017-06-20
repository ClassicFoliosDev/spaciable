# frozen_string_literal: true
class FinishCategoriesController < ApplicationController
  include PaginationConcern
  include SortingConcern
  load_and_authorize_resource :finish_category

  def index
    @finish_categories = paginate(sort(@finish_categories, default: :name))
    @active_tab = "finish_categories"
  end

  def show; end

  def new; end

  def edit; end

  def update
    if @finish_category.update(finish_category_params)
      notice = t("controller.success.update", name: @finish_category.name)
      redirect_to finish_categories_path, notice: notice
    else
      render :edit
    end
  end

  def create
    if @finish_category.save
      notice = t("controller.success.create", name: @finish_category.name)
      redirect_to finish_categories_path, notice: notice
    else
      render :new
    end
  end

  def destroy
    @finish_category.destroy
    notice = t("controller.success.destroy", name: @finish_category.name)
    redirect_to finish_categories_path, notice: notice

  rescue ActiveRecord::InvalidForeignKey
    notice = t("activerecord.errors.messages.delete_not_possible",
               name: @finish_category.name,
               types: "finishes")
    redirect_to finish_categories_path, alert: notice
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def finish_category_params
    params.require(:finish_category).permit(
      :name
    )
  end
end
