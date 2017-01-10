# frozen_string_literal: true
class UnitTypesController < ApplicationController
  include PaginationConcern
  include SortingConcern
  load_and_authorize_resource :development
  load_and_authorize_resource :unit_type, through: :development

  def index
    @unit_types = paginate(sort(@unit_types, default: :name))
  end

  def new
  end

  def edit
  end

  def show
  end

  def create
    if @unit_type.save
      notice = t(
        "controller.success.create",
        name: @unit_type.name
      )
      redirect_to [@development, :unit_types], notice: notice
    else
      render :new
    end
  end

  def update
    if @unit_type.update(unit_type_params)
      notice = t(
        "controller.success.update",
        name: @unit_type.name
      )
      redirect_to [@development, :unit_types], notice: notice
    else
      render :edit
    end
  end

  def destroy
    @unit_type.destroy
    notice = t("controller.success.destroy", name: @unit_type.name)
    redirect_to development_unit_types_url(@development), notice: notice
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def unit_type_params
    params.require(:unit_type).permit(:name, :picture, :build_type, phase_ids: [])
  end
end
