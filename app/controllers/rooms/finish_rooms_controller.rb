# frozen_string_literal: true
module Rooms
  class FinishRoomsController < ApplicationController
    load_and_authorize_resource :room
    load_and_authorize_resource :finish_room, through: :room
    include SortingConcern

    def new
      @finish_room = FinishRoom.new
      @finish_categories = FinishCategory.all.order(:name)

      new_room = PlotRoomTemplatingService.clone_room(params[:plot], @room)
      return unless new_room

      @room = new_room
      redirect_to [:new, @room, "finish_room"]
    end

    def edit; end

    def create
      finish_id = params[:finishes]
      @finish_room = FinishRoom.new(finish_id: finish_id, room_id: @room.id)

      if @finish_room.save
        notice = t("controller.success.update", name: @room.name)
        redirect_to [@room.parent, @room, active_tab: "finishes"], notice: notice
      else
        @finish_categories = FinishCategory.all
        render :new
      end
    end

    private

    # Never trust parameters from the scary internet, only allow the white list through.
    def finish_room_params
      params.require(:finish_room).permit(:search_finish_text)
    end
  end
end
