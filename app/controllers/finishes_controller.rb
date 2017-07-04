# frozen_string_literal: true
class FinishesController < ApplicationController
  include PaginationConcern
  include SortingConcern
  load_and_authorize_resource :finish

  def index
    @finishes = @finishes.includes(:finish_category, :finish_type, :manufacturer)
    @finishes = paginate(sort(@finishes, default: :name))
    @active_tab = "finishes"
  end

  def new; end

  def edit; end

  def show; end

  def create
    if @finish.save
      redirect_to finishes_path, notice: t("controller.success.create", name: @finish.name)
    else
      render :new
    end
  end

  def update
    if @finish.update(finish_params)
      redirect_to finish_path, notice: t("controller.success.update", name: @finish.name)
    else
      render :edit
    end
  end

  def destroy
    @finish.destroy
    notice = t(
      "controller.success.destroy",
      name: @finish.name
    )
    redirect_to finishes_url, notice: notice
  end

  def finish_types_list
    finish_types = FinishType.joins(:finish_categories)
                             .where(finish_categories: { name: params[:option_name] })
                             .distinct
                             .order(:name)

    render json: finish_types
  end

  def manufacturers_list
    manufacturers = Manufacturer
                    .joins(:finish_types)
                    .where(finish_types: { name: params[:option_name] })
                    .order(:name)
                    .distinct

    render json: manufacturers
  end

  def finish_list
    finishes = if params[:manufacturer_name].present?
                 Finish.joins(:finish_type, :manufacturer)
                       .where(finish_types: { name: params[:type_name] },
                              manufacturers: { name: params[:manufacturer_name] })
                       .order(:name)
                       .distinct
               else
                 Finish.joins(:finish_type)
                       .where(finish_types: { name: params[:type_name] })
                       .order(:name)
                       .distinct
               end

    render json: finishes
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def finish_params
    params.require(:finish).permit(
      :name,
      :description,
      :finish_category_id,
      :finish_type_id,
      :manufacturer_id,
      :picture,
      :remove_picture,
      documents_attributes: [:id, :title, :file, :_destroy]
    )
  end
end
