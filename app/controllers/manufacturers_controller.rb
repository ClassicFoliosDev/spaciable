# frozen_string_literal: true
class ManufacturersController < ApplicationController
  include PaginationConcern
  include SortingConcern
  load_and_authorize_resource :manufacturer

  def index
    @manufacturers = paginate(sort(@manufacturers, default: :name))
    @active_tab = "manufacturers"
  end

  def show
  end

  def new
    @finish_categories = FinishCategory.all
  end

  def edit
    @finish_categories = FinishCategory.all
  end

  def update
    update_relationships([:assign_to_appliances] == true)

    if @manufacturer.update(manufacturer_params)
      notice = t("controller.success.update", name: @manufacturer.name)
      redirect_to manufacturers_path, notice: notice
    else
      @finish_categories = FinishCategory.all
      render :edit
    end
  end

  def create
    if @manufacturer.save
      create_relationships(manufacturer_params[:assign_to_appliances] == "true")
      notice = t("controller.success.create", name: @manufacturer.name)
      redirect_to manufacturers_path, notice: notice
    else
      @finish_categories = FinishCategory.all
      render :new
    end
  end

  def destroy
    @manufacturer.destroy
    notice = t("controller.success.destroy", name: @manufacturer.name)
    redirect_to manufacturers_path, notice: notice

  rescue ActiveRecord::InvalidForeignKey
    notice = t("activerecord.errors.messages.delete_not_possible",
               name: @manufacturer.name,
               types: "appliances or finishes")
    redirect_to manufacturers_path, alert: notice
  end

  private

  def create_relationships(assign_to_appliances)
    if assign_to_appliances
      ManufacturerRelationshipsService.appliance_category_manufacturers(@manufacturer.id)
    else
      ManufacturerRelationshipsService
        .finish_type_manufacturers(@manufacturer.id,
                                   manufacturer_params[:finish_category_id])
    end
  end

  def update_relationships(assign_to_appliances)
    if assign_to_appliances
      ManufacturerRelationshipsService.appliance_category_manufacturers(@manufacturer.id)
      ManufacturerRelationshipsService.remove_finish_type_manufacturers(@manufacturer)
    else
      ManufacturerRelationshipsService
        .finish_type_manufacturers(@manufacturer.id,
                                   manufacturer_params[:finish_category_id])
      ManufacturerRelationshipsService.remove_appliance_category_manufacturers(@manufacturer)
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def manufacturer_params
    params.require(:manufacturer).permit(
      :name,
      :link,
      :assign_to_appliances,
      :finish_category_id
    )
  end
end
