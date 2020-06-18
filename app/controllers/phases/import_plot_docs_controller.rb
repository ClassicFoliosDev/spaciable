# frozen_string_literal: true

module Phases
  class ImportPlotDocsController < ApplicationController
    load_and_authorize_resource :phase

    def index
      @collection = @phase.sync_docs(select_plot_params[:list])
      render "phases/import/docs_index"
    end

    def download
      plot = @phase.plots.find_by(number: params[:meta])
      plot&.download_doc(params)
      render json: { key: params[:document_key] }
    end

    def select_plot_params
      params.require(:select_import_plots).permit(%i[list phase_id])
    end
  end
end
