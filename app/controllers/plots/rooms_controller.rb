# frozen_string_literal: true

module Plots
  # rubocop:disable Metrics/ClassLength
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
      if @active_tab == "finishes"
        build_finishes
      elsif @active_tab == "appliances"
        build_appliances
      end
    end

    # The list display and sorting is all built around database records.  The requirement
    # here is that the list of finishes shows the finishes associated with the room, PLUS any
    # approved choices made by the homeowner/admin.  These choices are NOT to be in the
    # FinishesRooms table from which the list is generated.  So in order for this to work, the
    # a database transaction is used.  A transaction is started, and any homeowner/admin choices
    # are 'temporarily' added to the database (through the finishes << choices statement), the
    # sort is performed via the database and the data is saved to an array.  At the end the
    # transaction is rolled back so the inserted choice records are never commited to the
    # database.  In addition, the requirement is for the choice records to NOT to be editable
    # or deleteable in the list.  To enable this .. a new attribute is dynamically added to each
    # Finish class (the class << finish ... bit) so as the view can identify which entries are
    # choices and should be disabled from deletion and editing
    def build_finishes
      Finish.transaction do
        finishes = @room.finishes # get the finishes from FinishesRooms
        choices = RoomChoice.approved_choices(@room, @plot, Finish.to_s) # get choices
        build_collection(finishes, choices, :name)
        raise ActiveRecord::Rollback # rollback the transaction and remove the choices
      end
    end

    # See above
    def build_appliances
      Appliance.transaction do
        appliances = @room.appliances # get the appliances
        choices = RoomChoice.approved_choices(@room, @plot, Appliance.to_s) # get choices
        build_collection(appliances, choices, :model_num)
        raise ActiveRecord::Rollback # rollback the transaction and remove the choices
      end
    end

    # See above
    # rubocop:disable all
    def build_collection(items, choices, default_sort)
      # identify duplictes.  These aren't allwed in the database so we have to mark
      # finishes as duplicated
      matching_items = []
      if choices.present?
        items.each do |item|
          matching_item = choices.select { |c| c.id == item.id }
          if matching_item
            matching_items << matching_item
            choices -= matching_item
          end
        end
      end
      matching_items.flatten!

      items << choices if choices.present? # add the unique choices to the database

      @collection = paginate(sort(items, default: default_sort)).to_a # sort

      # Add some dynamic attribtes to each item.  These are just
      # available to the view to allow them to be rendered appropriately
      @collection.each do |item|
        class << item
          attr_accessor :choice
          attr_accessor :duplicate
        end
        item.choice = choices.present? && !choices.select { |c| c.id == item.id }.empty?
        item.duplicate = !matching_items.select { |c| c.id == item.id }.empty?
      end
    end
    # rubocop:enable all

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
      @room ||= @plot.unit_type.rooms.find_by(id: params[:id])
    end
  end
  # rubocop:enable Metrics/ClassLength
end
