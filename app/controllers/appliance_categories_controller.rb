# frozen_string_literal: true
class ApplianceCategoriesController < ApplicationController
  include PaginationConcern
  include SortingConcern
  load_and_authorize_resource :appliance_category

  def index
    @appliance_categories = paginate(sort(@appliance_categories, default: :name))
    @active_tab = "appliance_categories"
  end

  def show; end

  def new; end

  def edit; end

  def update
    if @appliance_category.update(appliance_category_params)
      notice = t("controller.success.update", name: @appliance_category.name)
      redirect_to appliance_categories_path, notice: notice
    else
      render :edit
    end
  end

  def create
    if @appliance_category.save
      notice = t("controller.success.create", name: @appliance_category.name)
      redirect_to appliance_categories_path, notice: notice
    else
      render :new
    end
  end

  def destroy
    @appliance_category.destroy
    notice = t("controller.success.destroy", name: @appliance_category.name)
    redirect_to appliance_categories_path, notice: notice

  rescue ActiveRecord::InvalidForeignKey
    notice = t("activerecord.errors.messages.delete_not_possible",
               name: @appliance_category.name,
               types: "appliances")
    redirect_to appliance_categories_path, alert: notice
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def appliance_category_params
    params.require(:appliance_category).permit(
      :name
    )
  end
end
