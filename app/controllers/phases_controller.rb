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

    @resident_count = @phase.plot_residencies.size
    @subscribed_resident_count = @phase.residents.where(cf_email_updates: true).size

    @collection = if @active_tab == "plots" || @active_tab == "production"
                    paginate(sort(@phase.plots, default: :number))
                  elsif @active_tab == "documents"
                    documents = @phase.documents.accessible_by(current_ability)
                    paginate(sort(documents, default: :title))
                  end
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
      address_attributes: %i[postal_number road_name building_name
                             locality city county postcode id]
    )
  end
end
