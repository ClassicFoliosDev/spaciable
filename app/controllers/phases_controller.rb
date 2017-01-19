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
    @phase.build_address_with_defaults
  end

  def edit
    @phase.build_address_with_defaults
  end

  def show
    @collection = paginate(sort(@phase.plots, default: :number))
  end

  def create
    if @phase.save
      notice = t(".success", phase_name: @phase.name)
      redirect_to [@development, :phases], notice: notice
    else
      @phase.build_address_with_defaults
      render :new
    end
  end

  def update
    if @phase.update(phase_params)
      notice = t(".success", phase_name: @phase.name)
      redirect_to [@development, :phases], notice: notice
    else
      @phase.build_address_with_defaults
      render :edit
    end
  end

  def destroy
    @phase.destroy
    notice = t(
      ".success",
      phase_name: @phase.name
    )
    redirect_to development_phases_url(@development), notice: notice
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def phase_params
    params.require(:phase).permit(
      :name,
      :number,
      address_attributes: [:postal_name, :road_name, :building_name, :city, :county, :postcode]
    )
  end
end
