# frozen_string_literal: true
class RoomsController < ApplicationController
  include PaginationConcern
  include SortingConcern

  load_and_authorize_resource :development
  load_and_authorize_resource :unit_type, through: :development
  load_and_authorize_resource :room, through: :unit_type, shallow: true

  def index
    @rooms = paginate(sort(@rooms, default: :name))
  end

  def new
    @room.finishes.build
  end

  def edit
    @room.finishes.build if @room.finishes.none?
  end

  def show
  end

  def create
    if @room.save
      notice = t(
        "controller.success.create",
        name: @room.name
      )
      redirect_to development_unit_type_rooms_url(@development, @unit_type), notice: notice
    else
      render :new
    end
  end

  def update
    if @room.update(room_params)
      notice = t(
        "controller.success.update",
        name: @room.name
      )
      redirect_to development_unit_type_rooms_url(@room.development_id, @room.unit_type_id),
                  notice: notice
    else
      render :edit
    end
  end

  def update_finish_types
    @category = FinishCategory.find_by_name(params[:option_name])

    render json: @category.finish_types
  end

  def update_manufacturers
    @finish_type = FinishType.find_by_name(params[:option_name])

    render json: @finish_type.manufacturers
  end

  def destroy
    @room.destroy
    notice = t("controller.success.destroy", name: @room.name)
    redirect_to development_unit_type_rooms_url(@room.development_id, @room.unit_type_id),
                notice: notice
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def room_params
    params.require(:room).permit(
      :name,
      :unit_type_id,
      finishes_attributes: [
        :id, :room_id, :name, :description,
        :finish_category_id, :finish_type_id,
        :manufacturer_id, :picture, :_destroy
      ]
    )
  end
end
