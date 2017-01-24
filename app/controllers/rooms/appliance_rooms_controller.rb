# frozen_string_literal: true
module Rooms
  class ApplianceRoomsController < ApplicationController
    load_and_authorize_resource :room
    load_and_authorize_resource :appliance_room, through: :room

    def new
      @appliance_categories = ApplianceCategory.all
    end

    def edit
    end

    def create
      appliance_id = params[:appliances]
      @appliance_room = ApplianceRoom.create(appliance_id: appliance_id, room_id: @room.id)

      if @appliance_room.errors.any?
        @appliance_categories = ApplianceCategory.all
        render :new
      else
        notice = t("controller.success.update", name: @room.name)
        redirect_to room_url(@room, active_tab: "appliances"), notice: notice
      end
    end
  end
end
