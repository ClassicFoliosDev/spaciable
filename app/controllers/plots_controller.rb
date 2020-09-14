# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength

class PlotsController < ApplicationController
  include PaginationConcern
  include SortingConcern

  load_and_authorize_resource :development
  load_and_authorize_resource :phase
  load_and_authorize_resource :plot, through: %i[development phase], shallow: true

  before_action :set_parent
  before_action :check_access, except: %i[show update]

  def new
    @plots = BulkPlots::CreateService.call(@plot).collection
    @plot.progress = :soon
    @progress_id = Plot.progresses[@plot.progress.to_sym]
  end

  def edit
    @plots = BulkPlots::UpdateService.call(@plot, self).collection
    @progress_id = Plot.progresses[@plot.progress.to_sym]
  end

  def show
    default_tab = current_user.cf_admin? ? "documents" : "residents"
    @active_tab = params[:active_tab] || default_tab
    @collection_parent = @plot
    @collection = build_collection
    @preload = Event.find(params[:event]) if params[:event]

    session[:plot_id] = @plot.id

    # store the current path to redirect to plots page after edit or delete document
    session[:plot_doc] = request.original_url
  end

  def create
    BulkPlots::CreateService.call(@plot, params: plot_params) do |service, created_plots, errors|
      if created_plots.any?
        notice = t(".success", plots: created_plots.to_sentence, count: created_plots.count)
        redirect_to [@parent.parent, @parent, active_tab: :production],
                    notice: notice, alert: errors
      else
        flash.now[:alert] = errors if errors
        @plots = service.collection
        @plot.progress = :soon

        render :new
      end
    end
  end

  def update
    BulkPlots::UpdateService.call(@plot, self, params: plot_params) do |service, updated, errors|
      if updated.any? && @plot.valid?
        if plot_params[:letter_type].present?
          notice = t(".lettings_success", plot_name: @plot, type: plot_params[:letter_type])
          redirect_to phase_lettings_path(@parent.id), notice: notice, alert: errors
        else
          notify_and_redirect(updated, errors)
        end
      else
        flash.now[:alert] = errors if errors
        @plots = service.collection

        render :edit
      end
    end
  end

  def destroy
    ResidentResetService.reset_all_residents_for_plot(@plot)
    @plot.destroy
    notice = t(".success", plot_name: @plot.to_s)
    redirect_to [@parent.parent, @parent, active_tab: :production], notice: notice
  end

  private

  def notify_and_redirect(updated_plots, errors)
    notice = t(".success", plot_name: @plot, count: updated_plots.count)

    if plot_params[:notify].to_i.positive?
      updated_plots.each do |plot_id|
        plot = Plot.find(plot_id)
        notice << ResidentChangeNotifyService.call(plot, current_user, update_verb, plot)
      end
    end

    single_update = updated_plots.count == 1
    bulk_update = updated_plots.count > 1

    redirect_to @plot, notice: notice, alert: errors if single_update
    redirect_to [@parent, :plots], notice: notice, alert: errors if bulk_update
  end

  def update_verb
    if plot_params[:progress].present?
      new_state = t("activerecord.attributes.plot.progresses.#{plot_params[:progress]}")
      t("notify.updated_progress", state: new_state)
    else
      t("notify.generic_updated")
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def plot_params
    params.require(:plot).permit(
      %i[range_from range_to list].concat(plot_attributes)
    )
  end

  def create_params
    params.require(:plot).permit(plot_attributes)
  end

  def plot_attributes
    %i[ prefix number ut_update_option unit_type_id house_number road_name
        building_name locality city county timeline uprn
        postcode progress notify user_id completion_date reservation_release_date
        completion_release_date validity extended_access copy_plot_numbers letable let
        letter_type letable_type reservation_order_number completion_order_number ]
  end

  def set_parent
    @parent ||= @phase || @development || @plot&.parent
  end

  def check_access
    return if current_user.cf_admin? || can?(:cas_update, @plot)

    render file: "public/401.html", status: :unauthorized
  end

  def build_collection
    if @active_tab == "documents"
      paginate(sort(@plot.documents, default: :title))
    elsif @active_tab == "rooms"
      paginate(sort(@plot.rooms, default: :name))
    elsif @active_tab == "residents"
      paginate(sort(@plot.residents, default: :last_name))
    elsif @active_tab == "logs"
      paginate(sort(Log.logs(@plot), default: { created_at: :desc }))
    end
  end
end
# rubocop:enable Metrics/ClassLength
