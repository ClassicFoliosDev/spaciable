# frozen_string_literal: true
class AppliancesController < ApplicationController
  include PaginationConcern
  include SortingConcern
  load_and_authorize_resource :appliance

  def index
    @appliances = paginate(sort(@appliances, default: :name))
  end

  def new
  end

  def edit
  end

  def create
    if @appliance.save
      notice = t(".success", name: @appliance.name)
      redirect_to [:appliances], notice: notice
    else
      render :new
    end
  end

  def update
    if @appliance.update(appliance_params)
      notice = t(".success", name: @appliance.name)
      redirect_to [:appliances], notice: notice
    else
      render :edit
    end
  end

  def destroy
    @appliance.destroy
    notice = t(
      ".success",
      name: @appliance.name
    )
    redirect_to appliances_url, notice: notice
  end

  def app_manufacturers
    manufacturers = Manufacturer.joins(:appliance_categories)
                                .where(appliance_categories: { name: params[:option_name] })
                                .distinct

    render json: manufacturers
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def appliance_params
    params.require(:appliance).permit(
      :name, :primary_image, :secondary_image, :manual,
      :serial, :source, :warranty_num, :description,
      :warranty_length, :model_num, :e_rating,
      :manufacturer_id, :appliance_category_id
    )
  end
end
