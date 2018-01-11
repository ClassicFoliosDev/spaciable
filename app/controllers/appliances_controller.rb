# frozen_string_literal: true

class AppliancesController < ApplicationController
  include PaginationConcern
  include SortingConcern
  load_and_authorize_resource :appliance

  def index
    @appliances = @appliances.includes(:appliance_category, :appliance_manufacturer)
    @appliances = paginate(sort(@appliances, default: :id))
    @active_tab = "appliances"
  end

  def new; end

  def edit; end

  def show; end

  def create
    if @appliance.save
      notice = t(".success", name: @appliance.full_name)
      redirect_to appliances_path, notice: notice
    else
      render :new
    end
  end

  def update
    if @appliance.update(appliance_params)
      notice = t(".success", name: @appliance.full_name)
      redirect_to appliances_path, notice: notice
    else
      render :edit
    end
  end

  def destroy
    @appliance.destroy
    notice = t(".success", name: @appliance.to_s)
    redirect_to appliances_path, notice: notice
  end

  def appliance_manufacturers_list
    appliance_manufacturers = ApplianceManufacturer.all
    render json: appliance_manufacturers
  end

  def appliance_list
    appliances = Appliance.joins(:appliance_category, :appliance_manufacturer)
                          .where(appliance_categories: { name: params[:category_name] },
                                 appliance_manufacturers: { name: params[:option_name] })
                          .order(:model_num)
                          .distinct

    render json: appliances
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def appliance_params
    params.require(:appliance).permit(
      :primary_image, :secondary_image, :manual,
      :serial, :source, :warranty_num, :description,
      :warranty_length, :model_num, :e_rating,
      :appliance_manufacturer_id, :appliance_category_id,
      :remove_primary_image, :remove_secondary_image,
      :remove_manual, :guide, :remove_guide,
      :primary_image_cache, :secondary_image_cache
    )
  end
end
