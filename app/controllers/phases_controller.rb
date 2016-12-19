# frozen_string_literal: true
class PhasesController < ApplicationController
  include PaginationConcern
  include SortingConcern
  load_and_authorize_resource :development
  load_and_authorize_resource :phase, through: :development

  def index
    @phases = paginate(sort(@phases, default: :number))
  end

  def new
  end

  def edit
  end

  def show
  end

  def create
    if @phase.save
      notice = t("controller.success.create", name: @phase.name)
      redirect_to [@development, :phases], notice: notice
    else
      render :new
    end
  end

  def update
    if @phase.update(phase_params)
      notice = t("controller.success.update", name: @phase.name)
      redirect_to [@development, :phases], notice: notice
    else
      render :edit
    end
  end

  def destroy
    @phase.destroy
    notice = t(
      ".archive.success",
      phase_name: @phase.name
    )
    redirect_to development_phases_url(@development), notice: notice
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def phase_params
    params.require(:phase).permit(
      :name,
      :development_id,
      :postal_name,
      :building_name,
      :road_name,
      :city,
      :county,
      :postcode
    )
  end
end
