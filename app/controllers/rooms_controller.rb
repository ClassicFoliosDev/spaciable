# frozen_string_literal: true
class RoomsController < ApplicationController
  include PaginationConcern
  include SortingConcern

  load_and_authorize_resource :unit_type
  load_and_authorize_resource :room, through: :unit_type, shallow: true

  before_action :set_development, only: [:index, :new, :create]

  def index
    @rooms = paginate(sort(@rooms, default: :name))
  end

  def new
    @room.build_finishes
  end

  def edit
    @room.build_finishes
  end

  def show
  end

  def create
    if @room.save
      notice = t(
        "controller.success.create",
        name: @room.name
      )
      redirect_to unit_type_rooms_url(@unit_type), notice: notice
    else
      @room.build_finishes
      render :new
    end
  end

  def update
    if @room.update(room_params)
      notice = t(
        "controller.success.update",
        name: @room.name
      )
      redirect_to unit_type_rooms_url(@room.unit_type_id),
                  notice: notice
    else
      @room.build_finishes
      render :edit
    end
  end

  def finish_types
    collection = FinishType
                 .joins(:finish_categories)
                 .where(finish_categories: { name: params[:option_name] })
                 .distinct

    render json: collection
  end

  def manufacturers
    collection = Manufacturer
                 .joins(:finish_types)
                 .where(finish_types: { name: params[:option_name] })
                 .distinct

    render json: collection
  end

  def destroy
    @room.destroy
    notice = t("controller.success.destroy", name: @room.name)
    redirect_to unit_type_rooms_url(@room.unit_type_id),
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

  def set_development
    @development = @unit_type.development
  end
end
