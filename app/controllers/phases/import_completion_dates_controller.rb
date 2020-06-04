# frozen_string_literal: true

module Phases
  class ImportCompletionDatesController < ApplicationController
    load_and_authorize_resource :phase

    def index
      @collection = @phase.completion_dates(select_plot_params[:list])
      render "phases/import/completions_index"
    end

    def create
      @collection = Crms::Root::PlotCollection.new(import_completion_dates_params)
      Plot.update_cds(@collection.plots) do |updates, error|
        notice = t(".updated", plots: updates) unless error

        redirect_to [@phase.development, @phase], notice: notice, alert: error
      end
    end

    def select_plot_params
      params.require(:select_import_plots).permit(%i[list phase_id])
    end

    def import_completion_dates_params
      params.require(:crms_root_plot_collection)
            .permit(plots_attributes: %i[id completion_date])
    end
  end
end
