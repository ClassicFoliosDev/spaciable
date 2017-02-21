# frozen_string_literal: true
class RoomsController < ApplicationController
  include PaginationConcern
  include SortingConcern

  load_and_authorize_resource :unit_type
  load_and_authorize_resource :room, through: :unit_type, shallow: true

  def index
    @rooms = paginate(sort(@rooms, default: :name))
  end

  def new
    @room.build_finishes
    @room.build_appliances
  end

  def edit
    @room.build_finishes
    @room.build_appliances
  end

  def show
    @active_tab = params[:active_tab] || "finishes"

    @collection = if @active_tab == "finishes"
                    paginate(sort(@room.finishes, default: :name))
                  elsif @active_tab == "appliances"
                    paginate(sort(@room.appliances, default: :name))
                  end
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
      redirect_to room_url(@room), notice: notice
    else
      @room.build_finishes
      render :edit
    end
  end

  def destroy
    @room.destroy
    notice = t("controller.success.destroy", name: @room.name)
    redirect_to unit_type_rooms_url(@room.unit_type_id),
                notice: notice
  end

  def remove_appliance
    appliance_id = params[:appliance]
    room_id = params[:room]

    @appliance = Appliance.find(appliance_id)
    @room = Room.find(room_id)

    # This will delete all joins between @room and @appliance
    # if there is more than one
    if @room.appliances.delete(@appliance)
      notice = t(".success", room_name: @room.name, appliance_name: @appliance.name)
    end

    redirect_to room_url(@room, active_tab: "appliances"), notice: notice
  end

  def remove_finish
    finish_id = params[:finish]
    room_id = params[:room]

    @finish = Finish.find(finish_id)
    @room = Room.find(room_id)

    # This will delete all joins between @room and @appliance
    # if there is more than one
    if @room.finishes.delete(@finish)
      notice = t(".success", room_name: @room.name, finish_name: @finish.name)
    end

    redirect_to room_url(@room, active_tab: "finishes"), notice: notice
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def room_params
    params.require(:room).permit(
      :name,
      :unit_type_id,
      :icon_name
    )
  end
end
