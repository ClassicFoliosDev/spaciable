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

  def show
  end

  def create
    if @appliance.save
      notice = t(".success", name: @appliance.name)
      if @room
        redirect_to [:appliance_rooms], notice: notice
      else
        redirect_to appliances_path, notice: notice
      end
    else
      render :new
    end
  end

  def update
    if @appliance.update(appliance_params)
      notice = t(".success", name: @appliance.name)
      redirect_to appliances_path, notice: notice
    else
      render :edit
    end
  end

  def destroy
    @appliance.destroy
    notice = t(".success", name: @appliance.name)
    redirect_to appliances_path, notice: notice
  end

  def appliance_manufacturers
    manufacturers = Manufacturer.joins(:appliance_categories)
                                .where(appliance_categories: { name: params[:option_name] })
                                .distinct
                                .order(:name)

    render json: manufacturers
  end

  def appliance_list
    appliances = Appliance.joins(:appliance_category, :manufacturer)
                          .where(appliance_categories: { name: params[:category_name] },
                                 manufacturers: { name: params[:option_name] })
                          .distinct

    render json: appliances
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def appliance_params
    params.require(:appliance).permit(
      :name, :primary_image, :secondary_image, :manual,
      :serial, :source, :warranty_num, :description,
      :warranty_length, :model_num, :e_rating,
      :manufacturer_id, :appliance_category_id,
      :remove_primary_image, :remove_secondary_image
    )
  end
end
