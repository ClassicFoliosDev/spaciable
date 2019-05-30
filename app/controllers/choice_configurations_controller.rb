# frozen_string_literal: true

class ChoiceConfigurationsController < ApplicationController
  include PaginationConcern
  include SortingConcern
  load_and_authorize_resource :development
  load_and_authorize_resource :choice_configuration, through: :development

  before_action :build_phase_plot_lists, only: %i[new create edit update]
  before_action :build_unit_types, only: %i[new]

  def index
    @choice_configurations = paginate(sort(@choice_configurations,
                                           default: :name))
  end

  def show
    @collection = build_collection
  end

  def edit() end

  def create
    choice_configuration_params
    if @choice_configuration.persist(params[:choice_configuration][:name],
                                     selected_plots,
                                     params[:choice_configuration][:unit_type])
      notice = t(".success",
                 choice_configuration_name: @choice_configuration.name)
      redirect_to [@development, :choice_configurations], notice: notice
    else
      render :new
    end
  end

  def update
    if @choice_configuration.update_config(params[:choice_configuration][:name],
                                           selected_plots)
      notice = t(".success",
                 choice_configuration_name: @choice_configuration.name)
      redirect_to [@development, :choice_configurations], notice: notice
    else
      render :edit
    end
  end

  def destroy
    @choice_configuration.destroy
    notice = t(".success",
               choice_configuration_name: @choice_configuration.name)
    redirect_to development_choice_configurations_url(@development),
                notice: notice
  end

  def choice_configuration_params
    params.require(:choice_configuration).permit!
  end

  private

  def build_collection
    paginate(sort(@choice_configuration.room_configurations, default: :name))
  end

  # Build lists of all available plots for all phases
  # rubocop:disable Metrics/MethodLength
  def build_phase_plot_lists
    @phase_plots = []
    @development.phases.each do |phase|
      plots = phase
              .plots
              .where(choice_configuration_id: [nil, @choice_configuration.id])
              .map do |plot|
        [
          plot.number,
          plot.id,
          selected: !@choice_configuration.id.nil? &&
            plot.choice_configuration_id == @choice_configuration.id
        ]
      end
      # A hash to build a single accordian entry for the phase on the form
      @phase_plots.push(tag: phase_ids_symbol(phase),
                        name: phase.name, id: phase.id, plots: plots)
    end
  end
  # rubocop:enable Metrics/MethodLength

  def build_unit_types
    @unit_types = UnitType.where(development_id: @development.id).pluck(:name, :id)
  end

  # get all the selected plots as a single array
  def selected_plots
    plots = @development
            .phases
            .map { |p| params[:choice_configuration][phase_ids_symbol(p)].select(&:present?) }
    plots.flatten!.map(&:to_i) if plots.present?
  end

  # define a symbol to represent the phase IDs in the form
  def phase_ids_symbol(phase)
    "phase_#{phase.id}_ids".to_sym
  end
end
