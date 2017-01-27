# frozen_string_literal: true
module Rooms
  class FinishRoomsController < ApplicationController
    load_and_authorize_resource :room
    load_and_authorize_resource :finish_room, through: :room

    def new
      @finish_categories = FinishCategory.all
    end

    def edit
    end

    def create
      finish_id = params[:finishes]
      @finish_room = FinishRoom.new(finish_id: finish_id, room_id: @room.id)

      if @finish_room.save
        notice = t("controller.success.update", name: @room.name)
        redirect_to room_url(@room, active_tab: "finishes"), notice: notice
      else
        @finish_categories = FinishCategory.all
        render :new
      end
    end
  end
end
