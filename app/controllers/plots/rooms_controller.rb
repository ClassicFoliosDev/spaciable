# frozen_string_literal: true

module Plots
  class RoomsController < ApplicationController
    include PaginationConcern
    include SortingConcern

    load_and_authorize_resource :plot
    before_action :find_plots, only: :index
    before_action :find_plot_room, except: :index
    load_and_authorize_resource :room

    def index
      @rooms = paginate(sort(@rooms, default: :name))
    end

    def new
      @room = PlotRoomTemplatingService.new(@plot).build_room(
        room_scope: Room.accessible_by(current_ability),
        template_room_id: params[:template_room_id]
      )

      @room.build_finishes
      @room.build_appliances
    end

    def edit
      if PlotRoomTemplatingService.template_room?(@room)
        redirect_to [:new, @plot, :room, template_room_id: @room.id]
      end

      @room.build_finishes
      @room.build_appliances
    end

    def show
      @active_tab = params[:active_tab] || "finishes"

      @collection = if @active_tab == "finishes"
                      paginate(sort(@room.finishes, default: :name))
                    elsif @active_tab == "appliances"
                      paginate(sort(@room.appliances.includes(:appliance_manufacturer),
                                    default: :model_num))
                    end
    end

    def create
      @room = @plot.plot_rooms.build(@room.attributes)

      if @room.save
        notice = t("controller.success.create", name: @room.name)
        redirect_to [@plot, :rooms], notice: notice
      else
        @room.build_finishes
        render :new
      end
    end

    def update
      if @room.update(room_params)
        notice = t("controller.success.update", name: @room.name)
        redirect_to [@plot, @room], notice: notice
      else
        @room.build_finishes
        render :edit
      end
    end

    def destroy
      PlotRoomTemplatingService.new(@plot).destroy(@room)

      notice = t("controller.success.destroy", name: @room.name)
      redirect_to [@plot, :rooms], notice: notice, alert: alert
    end

    private

    # Never trust parameters from the scary internet, only allow the white list through.
    def room_params
      params.require(:room).permit(
        :name,
        :icon_name,
        :template_room_id
      )
    end

    def find_plots
      @rooms = @plot.rooms
    end

    def find_plot_room
      @room = @plot.plot_rooms.find_by(id: params[:id])
      @room = @plot.unit_type.rooms.find_by(id: params[:id]) unless @room
    end
  end
end
