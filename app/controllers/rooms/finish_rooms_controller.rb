# frozen_string_literal: true

module Rooms
  class FinishRoomsController < ApplicationController
    load_and_authorize_resource :room
    load_and_authorize_resource :finish_room, through: :room
    include SortingConcern

    def new
      @finish_room = FinishRoom.new
      @finish_categories = finish_categories

      new_room = PlotRoomTemplatingService.clone_room(params[:plot], @room)
      return unless new_room

      @room = new_room
      redirect_to [:new, @room, :finish_room]
    end

    def edit; end

    def create
      @finish_room = FinishRoom.new(finish_id: params[:finishes],
                                    room_id: @room.id)

      if @finish_room.save
        Room.last_edited_by(@finish_room.room_id, current_user)
        notice = t("controller.success.update", name: @room.name)
        redirect_to [@room.parent, @room, active_tab: "finishes"], notice: notice
      else
        @finish_categories = finish_categories
        render :new
      end
    end

    private

    # Never trust parameters from the scary internet, only allow the white list through.
    def finish_room_params
      params.require(:finish_room).permit(:search_finish_text)
    end

    def finish_categories
      FinishCategory.accessible_by(current_ability).order(:name)
    end
  end
end
