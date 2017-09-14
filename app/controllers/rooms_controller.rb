# frozen_string_literal: true
class RoomsController < ApplicationController
  include PaginationConcern
  include SortingConcern

  load_and_authorize_resource :unit_type

  load_and_authorize_resource :room,
                              through: :unit_type,
                              except: [:remove_finish, :remove_appliance]

  load_and_authorize_resource :room,
                              only: [:remove_finish, :remove_appliance]

  before_action :set_parent

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
    @plot = Plot.find(params[:plot]) if params[:plot]

    @collection = if @active_tab == "finishes"
                    paginate(sort(@room.finishes, default: :name))
                  elsif @active_tab == "appliances"
                    paginate(sort(@room.appliances.includes(:appliance_manufacturer),
                                  default: :model_num))
                  end
  end

  def create
    if @room.save
      notice = t(
        "controller.success.create",
        name: @room.name
      )
      redirect_to [@parent, :rooms], notice: notice
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
      redirect_to [@unit_type, @room], notice: notice
    else
      @room.build_finishes

      alert = t(".not_updated")
      alert << AppliancesFinishesErrorsService.room_errors(@room)
      flash.now[:alert] = alert

      render :edit
    end
  end

  def destroy
    @room.destroy
    notice = t("controller.success.destroy", name: @room.name)
    redirect_to [@parent, :rooms], notice: notice
  end

  def remove_appliance
    @appliance = Appliance.find(params[:appliance])
    @room = Room.find(params[:room])

    new_room = PlotRoomTemplatingService.clone_room(params[:plot], @room)
    @room = new_room if new_room

    # This will delete all joins between @room and @appliance
    # if there is more than one
    if @room.appliances.delete(@appliance)
      notice = t(".success", room_name: @room.name, appliance_name: @appliance.full_name)
    end

    redirect_to [@room.parent, @room, active_tab: "appliances"], notice: notice
  end

  def remove_finish
    @finish = Finish.find(params[:finish])
    @room = Room.find(params[:room])

    new_room = PlotRoomTemplatingService.clone_room(params[:plot], @room)
    @room = new_room if new_room

    # This will delete all joins between @room and @appliance
    # if there is more than one
    if @room.finishes.delete(@finish)
      notice = t(".success", room_name: @room.name, finish_name: @finish.name)
    end

    redirect_to [@room.parent, @room, active_tab: "finishes"], notice: notice
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def room_params
    params.require(:room).permit(
      :name,
      :icon_name
    )
  end

  def set_parent
    @parent = @unit_type || @room&.parent
  end
end
