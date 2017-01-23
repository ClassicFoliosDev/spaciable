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
      if ApplianceRoom.create(appliance_id: params[:appliances], room_id: @room.id)
        notice = t("controller.success.update", name: @room.name)
      end

      redirect_to room_url(@room, active_tab: "appliances"), notice: notice
    end
  end
end
