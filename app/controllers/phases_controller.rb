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
    default_tab = current_user.cf_admin? ? "production" : "plots"
    @active_tab = params[:active_tab] || default_tab
    @collection = build_collection
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
    unless current_user.valid_password?(params[:password])
      alert = t("admin_permissable_destroy.incorrect_password", record: @phase)
      redirect_to development_phases_url(@development), alert: alert
      return
    end

    @phase.destroy
    notice = t(
      ".success",
      phase_name: @phase.name
    )
    redirect_to development_phases_url(@development), notice: notice
  end

  private

  def build_collection
    if @active_tab == "plots" || @active_tab == "production"
      paginate(sort(@phase.plots, default: :number))
    elsif @active_tab == "documents"
      documents = @phase.documents
      paginate(sort(documents, default: :title))
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def phase_params
    params.require(:phase).permit(
      :name,
      :number, :business, :conveyancing,
      address_attributes: %i[postal_number road_name building_name
                             locality city county postcode id]
    )
  end
end
