# frozen_string_literal: true
class PlotDocumentsController < ApplicationController
  include PaginationConcern
  include SortingConcern

  load_and_authorize_resource :development
  load_and_authorize_resource :phase

  before_action :set_parent

  def index
    @new_plot_document = @parent.plots.build.documents.build
    authorize! :index, @new_plot_document

    @plot_documents = @parent.plot_documents.accessible_by(current_ability)
    @plot_documents = sort(@plot_documents, default: { updated_at: :desc })
    @plot_documents = paginate(@plot_documents)
  end

  def bulk_upload
    if plot_document_params[:files].nil?
      alert = t(".files_required")
      redirect_to [@parent, :plot_documents], alert: alert
      return
    end

    notice, alert = process_documents
    notice = process_notification(notice) if plot_document_params[:notify].to_i.positive?

    redirect_to [@parent, :plot_documents], alert: alert, notice: notice
  end

  private

  def process_notification(notice)
    # If notice is nil, this means no matching plots were found for the documents
    # so there will be no residents to notify
    return unless notice

    resident_count = ResidentChangeNotifyService.call(@parent,
                                                      current_user,
                                                      Document.model_name.human.pluralize)
    notice << t("resident_notification_mailer.notify.update_sent", count: resident_count)
    notice
  end

  def process_documents
    matched, unmatched, error = BulkUploadPlotDocumentsService
                                .call(@parent.plots, plot_document_params, params)

    notice = t(".success", matched: matched.count) if matched.any?
    alert = t(".failure", unmatched: unmatched.to_sentence) if unmatched.any?
    alert = error if error&.length&.positive?

    [notice, alert]
  end

  def set_parent
    @parent ||= @phase || @development
  end

  def plot_document_params
    params.require(:document).permit(:category, :notify, files: [])
  end
end
