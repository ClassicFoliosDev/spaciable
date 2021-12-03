# frozen_string_literal: true

class ApplianceManufacturersController < ApplicationController
  include PaginationConcern
  include SortingConcern
  load_and_authorize_resource :appliance_manufacturer

  def index
    @appliance_manufacturers = paginate(sort(@appliance_manufacturers, default: :name))
    @active_tab = "appliance_manufacturers"
  end

  def show; end

  def new; end

  def edit; end

  def update
    if @appliance_manufacturer.update(appliance_manufacturer_params)
      notice = t("controller.success.update", name: @appliance_manufacturer.name)
      redirect_to appliance_manufacturers_path, notice: notice
    else
      render :edit
    end
  end

  def create
    if @appliance_manufacturer.save
      notice = t("controller.success.create", name: @appliance_manufacturer.name)
      redirect_to appliance_manufacturers_path, notice: notice
    else
      render :new
    end
  end

  def destroy
    @appliance_manufacturer.destroy
    notice = t("controller.success.destroy", name: @appliance_manufacturer.name)
    redirect_to appliance_manufacturers_path, notice: notice
  rescue ActiveRecord::InvalidForeignKey
    notice = t("activerecord.errors.messages.delete_not_possible",
               name: @appliance_manufacturer.name,
               types: "appliances")
    redirect_to appliance_manufacturers_path, alert: notice
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def appliance_manufacturer_params
    params.require(:appliance_manufacturer).permit(
      :name,
      :link,
      :assign_to_appliances
    )
  end
end
