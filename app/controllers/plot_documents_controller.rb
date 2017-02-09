# frozen_string_literal: true
class PlotDocumentsController < ApplicationController
  include PaginationConcern
  include SortingConcern

  load_and_authorize_resource :development

  before_action :set_parent

  def index
    @new_plot_document = @development.plots.build.documents.build
    authorize! :index, @new_plot_document

    @plot_documents = @parent.plot_documents.accessible_by(current_ability)
    @plot_documents = sort(@plot_documents, default: { updated_at: :desc })
    @plot_documents = paginate(@plot_documents)
  end

  def bulk_upload
    plots = @parent.plots.map { |plot| [plot.to_s.downcase.strip, plot] }
    files = plot_document_params[:files].map do |file|
      [file.original_filename.downcase.strip, file]
    end

    matched, unmatched = BulkUploadPlotDocumentsService
                         .call(files, plots, plot_document_params[:category])

    notice = "Uploaded #{matched.count} Plot Documents Successfully." if matched.any?
    alert = "Failed to find plots for: #{unmatched.to_sentence}." if unmatched.any?

    redirect_to [@parent, :plot_documents], alert: alert, notice: notice
  end

  private

  def set_parent
    @parent = @development
  end

  def plot_document_params
    params.require(:document).permit(:category, files: [])
  end
end
