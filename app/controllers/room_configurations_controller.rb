# frozen_string_literal: true

class RoomConfigurationsController < ApplicationController
  include PaginationConcern
  include SortingConcern
  load_and_authorize_resource :choice_configuration
  load_and_authorize_resource :room_configuration, through: :choice_configuration

  def index
    @room_configurations = paginate(sort(@room_configurations, default: :name))
  end

  def show
    @collection = build_collection
  end

  def create
    if @room_configuration.save
      notice = t(".success", room_configuration_name: @room_configuration.name)
      redirect_to [@choice_configuration, :room_configurations], notice: notice
    else
      render :new
    end
  end

  def update
    if @room_configuration.update(room_configuration_params)
      notice = t(".success", room_configuration_name: @room_configuration.name)
      redirect_to [@choice_configuration, :room_configurations], notice: notice
    else
      render :edit
    end
  end

  def destroy
    @room_configuration.destroy
    notice = t(
      ".success",
      room_configuration_name: @room_configuration.name
    )
    redirect_to choice_configuration_room_configurations_url(@choice_configuration), notice: notice
  end

  private

  def build_collection
    paginate(sort(@room_configuration.room_items, default: :name))
  end

  # Never trust parameters from the internet, only allow the white list through.
  def room_configuration_params
    params.require(:room_configuration).permit(
      :name,
      :icon_name
    )
  end
end
