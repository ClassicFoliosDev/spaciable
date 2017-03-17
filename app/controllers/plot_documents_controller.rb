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
    if plot_document_params[:files].nil?
      alert = t(".files_required")
      redirect_to [@parent, :plot_documents], alert: alert && return
    end

    matched, unmatched = BulkUploadPlotDocumentsService
                         .call(@parent.plots, plot_document_params)

    notice = t(".success", matched: matched.count) if matched.any?
    alert = t(".failure", unmatched: unmatched.to_sentence) if unmatched.any?

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
