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
    @resident_count = @parent.plot_residencies.size
    @subscribed_resident_count = @parent.residents.where(isyt_email_updates: true).size
  end

  def bulk_upload
    if plot_document_params[:files].nil?
      alert = t(".files_required")
      redirect_to [@parent, :plot_documents], alert: alert
      return
    end

    notice, alert = process_documents

    redirect_to [@parent, :plot_documents], alert: alert, notice: notice
  end

  private

  def process_documents
    Rails.logger.debug("> Process documents start #{Time.zone.now}")
    matched, unmatched, error = BulkUploadPlotDocumentsService
                                .call(@parent.plots, plot_document_params, params)

    notice = notify_and_notice(matched) if matched.any?

    alert = t(".failure", unmatched: unmatched.to_sentence) if unmatched.any?
    alert = error if error&.length&.positive?

    Rails.logger.debug("< Process documents end #{Time.zone.now}")
    [notice, alert]
  end

  def notify_and_notice(matched)
    notice = t(".success", matched: matched.count)

    if plot_document_params[:notify].to_i.positive?
      notify_count = 0
      matched.each do |match|
        response = ResidentChangeNotifyService.call(match, current_user,
                                                    t("notify.added"), match.parent)
        notify_count += 1 if response.start_with?(" and 1")
      end

      notice << I18n.t("resident_notification_mailer.notify.update_sent", count: notify_count)
    end

    notice
  end

  def set_parent
    @parent ||= @phase || @development
  end

  def plot_document_params
    params.require(:document).permit(:category, :notify, files: [])
  end
end
