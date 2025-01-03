# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength

class PlotsController < ApplicationController
  include PaginationConcern
  include SortingConcern

  load_and_authorize_resource :phase
  load_and_authorize_resource :plot, through: %i[phase], shallow: true

  before_action :set_parent
  before_action :check_access, except: %i[show update complete]

  def new
    @plots = BulkPlots::CreateService.call(@plot).collection
    @plot.build_step = @parent.build_steps.first
  end

  def edit
    @plots = BulkPlots::UpdateService.call(@plot, self).collection
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
        @plot.build_step = @parent.build_steps.first

        render :new
      end
    end
  end

  def complete
    @complete = true
    @active_tab = "completion"
    update
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
        render(@complete.nil? ? :edit : :show)
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
        notice << ResidentChangeNotifyService.call(plot, current_user,
                                                   update_verb, plot,
                                                   update_subject)
      end
    end

    single_update = updated_plots.count == 1
    bulk_update = updated_plots.count > 1

    redirect_to @plot, notice: notice, alert: errors if single_update
    redirect_to [@parent, :plots], notice: notice, alert: errors if bulk_update
  end

  def update_verb
    if plot_params[:build_step_id].present?
      BuildStep.find(plot_params[:build_step_id]).description
    else
      t("notify.generic_updated")
    end
  end

  def update_subject
    if plot_params[:build_step_id].present?
      t("notify.updated_build", stage: BuildStep.find(plot_params[:build_step_id]).title)
    else
      t("resident_notification_mailer.notify.update_subject")
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def plot_params
    params.require(:plot).permit(
      %i[range_from range_to list].concat(plot_attributes),
      material_info_attributes: material_info_attributes
    )
  end

  def create_params
    params.require(:plot).permit(plot_attributes)
  end

  def plot_attributes
    %i[ prefix number ut_update_option unit_type_id house_number road_name
        building_name locality city county uprn
        postcode build_step_id notify user_id completion_date reservation_release_date
        completion_release_date validity extended_access copy_plot_numbers letable let
        letter_type letable_type reservation_order_number completion_order_number ]
  end

  # rubocop:disable Metrics/MethodLength
  def material_info_attributes
    [
      :id,
      :selling_price,
      :reservation_fee,
      :tenure,
      :lease_length,
      :service_charges,
      :council_tax_band,
      :property_type,
      :floor,
      :floorspace,
      :estimated_legal_completion_date,
      :epc_rating,
      :property_construction,
      :property_construction_other,
      :electricity_supply,
      :electricity_supply_other,
      :water_supply,
      :sewerage,
      :sewerage_other,
      :broadband,
      :mobile_signal,
      :mobile_signal_restrictions,
      :parking,
      :building_safety,
      :restrictions,
      :rights_and_easements,
      :flood_risk,
      :planning_permission_or_proposals,
      :accessibility,
      :coalfield_or_mining_areas,
      :other_considerations,
      :warranty_num,
      :mprn,
      :mpan,
      heating_fuel_ids: [],
      heating_source_ids: [],
      heating_output_ids: []
    ]
  end
  # rubocop:enable Metrics/MethodLength

  # rubocop:disable Naming/MemoizedInstanceVariableName
  def set_parent
    @parent ||= @phase || @development || @plot&.parent
  end
  # rubocop:enable Naming/MemoizedInstanceVariableName

  def check_access
    return if current_user.cf_admin? || can?(:update, @plot)

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
