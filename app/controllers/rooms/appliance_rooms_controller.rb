# frozen_string_literal: true

module Rooms
  class ApplianceRoomsController < ApplicationController
    load_and_authorize_resource :room
    load_and_authorize_resource :appliance_room, through: :room
    include SortingConcern

    def new
      @appliance_categories = appliance_categories
      @appliance_manufacturers = appliance_manufacturers

      new_room = PlotRoomTemplatingService.clone_room(params[:plot], @room)
      return unless new_room

      @room = new_room
      redirect_to [:new, @room, "appliance_room"]
    end

    def edit; end

    def create
      @appliance_room = ApplianceRoom.new(appliance_id: params[:appliances],
                                          room_id: @room.id)

      if @appliance_room.save
        Room.last_edited_by(@appliance_room.room_id, current_user)
        notice = t("controller.success.update", name: @room.name)
        redirect_to [@room.parent, @room, active_tab: "appliances"], notice: notice
      else
        @appliance_categories = appliance_categories
        @appliance_manufacturers = appliance_manufacturers
        render :new
      end
    end

    private

    # Never trust parameters from the scary internet, only allow the white list through.
    def appliance_room_params
      params.require(:appliance_room).permit(:search_appliance_text)
    end

    def appliance_categories
      sort(ApplianceCategory.visible_to(current_user), default: :name)
    end

    def appliance_manufacturers
      sort(ApplianceManufacturer.visible_to(current_user), default: :name)
    end
  end
end
