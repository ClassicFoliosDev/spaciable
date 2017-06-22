# frozen_string_literal: true
module Rooms
  class ApplianceRoomsController < ApplicationController
    load_and_authorize_resource :room
    load_and_authorize_resource :appliance_room, through: :room

    def new
      @appliance_categories = ApplianceCategory.all
    end

    def edit; end

    def create
      appliance_id = params[:appliances]
      @appliance_room = ApplianceRoom.new(appliance_id: appliance_id, room_id: @room.id)

      if @appliance_room.save
        notice = t("controller.success.update", name: @room.name)
        redirect_to [@room.parent, @room, active_tab: "appliances"], notice: notice
      else
        @appliance_categories = ApplianceCategory.all
        render :new
      end
    end

    private

    # Never trust parameters from the scary internet, only allow the white list through.
    def appliance_room_params
      params.require(:appliance_room).permit(:search_appliance_text)
    end
  end
end
