# frozen_string_literal: true

module Phases
  class ImportResidentsController < ApplicationController
    load_and_authorize_resource :phase

    def index
      @collection = @phase.plot_residents(select_plot_params[:list])
      render "phases/import/residents_index"
    end

    def create
      @collection = Crms::Root::PlotCollection.new(import_residents_params)
      if @collection.validates?
        PlotResidency.create_residents(@collection.plots) do |error|
          raise error if error

          redirect_to [@phase.development, @phase]
        end
      else
        render "phases/import/residents_index"
      end
    end

    def select_plot_params
      params.require(:select_import_plots).permit(%i[list phase_id])
    end

    def import_residents_params
      params.require(:crms_root_plot_collection)
            .permit(plots_attributes:
                    [:id, :number,
                     residents_attributes: %i[title first_name last_name email phone_number role]])
    end
  end
end
