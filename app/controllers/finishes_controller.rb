# frozen_string_literal: true
class FinishesController < ApplicationController
  load_and_authorize_resource :room
  load_and_authorize_resource :finish, through: :room
  before_action :set_development

  def index
  end

  def new
  end

  def edit
  end

  def show
  end

  def create
    if @finish.save
      redirect_to [@room, @finish], notice: t("controller.success.create", name: @finish.name)
    else
      render :new
    end
  end

  def update
    if @finish.update(finish_params)
      redirect_to [@room, @finish], notice: t("controller.success.update", name: @finish.name)
    else
      render :edit
    end
  end

  def destroy
    @finish.destroy
    notice = t(
      "controller.success.destroy",
      name: @finish.name
    )
    redirect_to room_finishes_url(@room), notice: notice
  end

  private

  def set_development
    @development = @room.development
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def finish_params
    params.require(:finish).permit(
      :room_id,
      :name,
      :description,
      :category,
      :type,
      :manufacturer,
      :picture,
      documents_attributes: [:id, :title, :file, :_destroy]
    )
  end
end
