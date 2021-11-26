# frozen_string_literal: true

class FinishManufacturersController < ApplicationController
  include PaginationConcern
  include SortingConcern
  load_and_authorize_resource :finish_manufacturer

  def index
    @finish_manufacturers = paginate(sort(@finish_manufacturers, default: :name))
    @active_tab = "finish_manufacturers"
  end

  def show; end

  def new
    @finish_categories = sort(FinishCategory.all, default: :name)
  end

  def edit
    @finish_categories = sort(FinishCategory.all, default: :name)
  end

  def update
    if @finish_manufacturer.update(finish_manufacturer_params)
      notice = t("controller.success.update", name: @finish_manufacturer.name)
      redirect_to finish_manufacturers_path, notice: notice
    else
      @finish_categories = sort(FinishCategory.all, default: :name)
      render :edit
    end
  end

  def create
    if @finish_manufacturer.save
      notice = t("controller.success.create", name: @finish_manufacturer.name)
      redirect_to finish_manufacturers_path, notice: notice
    else
      @finish_categories = sort(FinishCategory.all, default: :name)
      render :new
    end
  end

  def destroy
    @finish_manufacturer.destroy
    notice = t("controller.success.destroy", name: @finish_manufacturer.name)
    redirect_to finish_manufacturers_path, notice: notice
  rescue ActiveRecord::InvalidForeignKey
    notice = t("activerecord.errors.messages.delete_not_possible",
               name: @finish_manufacturer.name,
               types: "finishes")
    redirect_to finishes_path, alert: notice, active_tab: "finish_manufacturers"
  end

  def clone
    @source_finish_manufacturer = @finish_manufacturer
    @finish_manufacturer = @finish_manufacturer.dup
    render :new
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def finish_manufacturer_params
    params.require(:finish_manufacturer).permit(
      :name,
      finish_type_ids: []
    )
  end
end
