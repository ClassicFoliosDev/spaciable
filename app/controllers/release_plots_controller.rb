# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength
class ReleasePlotsController < ApplicationController
  load_and_authorize_resource :phase

  # just show the base form
  def index
    return redirect_to root_path unless current_user.cf_admin?

    @resident_count = @phase.plot_residencies.size
    @subscribed_resident_count = @phase.residents.where(cf_email_updates: true).size

    @active_plots_count = @phase.active_plots_count
    @completed_plots_count = @phase.completed_plots_count
    @expired_plots_count = @phase.expired_plots_count
    @activated_resident_count = @phase.activated_resident_count
    @active_tab = "release_plots"
  end

  # JSON javascript handler to service the requests from the browser
  def callback
    render json: params[:req] == "validate" ? validate : all_plots
  end

  # Bulk update request to the specified plots
  def create
    map_params
    plot = Plot.new(number: Plot::DUMMY_PLOT_NAME, phase: @phase)
    BulkPlots::UpdateService.call(plot, self, params: @bu_params) \
      do |_service, updated_plots, errors|
      send_email(updated_plots)

      redirect_to development_phase_path(@phase.parent, @phase),
                  notice: success_notice(updated_plots), alert: errors
    end
  end

  protected

  # Never trust parameters from the scary internet, only allow the white list through.
  def r_params
    params.permit(
      %i[phase_id list release_type release_date order_number
         validity extended plot_numbers send_to_admins req]
    )
  end

  # Validate the request
  def validate
    # check Validity is valid if populated
    if r_params[:validity].present? && r_params[:validity].to_i < 2
      { valid: false, message: "Validity must be > 1" }
    elsif Date.parse(r_params[:release_date]) > Time.zone.today
      { valid: false, message: "Date must be before or equal to today" }
    elsif r_params[:order_number].blank?
      { valid: false, message: "Order number is required" }
    else
      pre_submit_check
    end
  end

  # Retrieve all the plots for the phase
  def all_plots
    { plots: Plot.where(phase_id: @phase.id).pluck(:number).natural_sort * "," }
  end

  # Get a success notice detailing the updated plot numbers
  def success_notice(updated_plots)
    if updated_plots.count == 1
      t(".success_one", plot_number: updated_plots.first)
    else
      t(".success", plot_numbers: updated_plots.to_sentence)
    end
  end

  # We are going to use the BulkPlots::UpdateService to do the actual update.  The requires us to
  # map our params into an alternative set that will trigger the required functionality in
  # bulk_update.  Why do I include unit_type_id_check?  There is a nasty hack in bulk update
  # that relies on it's presence
  def map_params
    @bu_params = { list: r_params[:plot_numbers], unit_type_id_check: "0" }
    map_validity
    map_extended
    return if r_params[:release_date].empty?

    map_date
    return if r_params[:order_number].blank?

    map_order_number
    @bu_prams
  end

  def map_validity
    return if r_params[:validity].blank? || r_params[:validity].empty?

    @bu_params[:validity] = r_params[:validity]
    @bu_params[:validity_check] = "1"
  end

  def map_order_number
    if r_params[:release_type] == "completion_release_date"
      @bu_params[:completion_order_number] = r_params[:order_number]
      @bu_params[:completion_order_number_check] = "1"
    else
      @bu_params[:reservation_order_number] = r_params[:order_number]
      @bu_params[:reservation_order_number_check] = "1"
    end
  end

  def map_extended
    return if r_params[:extended].blank? || r_params[:extended].empty?

    @bu_params[:extended_access] = r_params[:extended]
    @bu_params[:extended_access_check] = "1"
  end

  def map_date
    if r_params[:release_type] == "completion_release_date"
      @bu_params[:completion_release_date] = r_params[:release_date]
      @bu_params[:completion_release_date_check] = "1"
    else
      @bu_params[:reservation_release_date] = r_params[:release_date]
      @bu_params[:reservation_release_date_check] = "1"
    end
  end

  # Use the ReleaseService to check the data and report any errors, including plots that
  # already have completion/reservation dates set where appropriate
  def pre_submit_check
    # Go and service the request.
    BulkPlots::ReleaseService.call(params: r_params) do |_service, plots, error|
      if error
        @result = { valid: false, message: error }
      else
        sorted_plots = plots.natural_sort * ","
        @result = { valid: true, num_plots: plots.length,
                    plot_numbers: sorted_plots,
                    release_date: Date.parse(r_params[:release_date])
                                      .strftime("%d/%m/%y") }
      end
    end
    @result
  end

  # Use the ReleaseMailer to the email to concerned parties if necessary
  def send_email(updated_plots)
    return if r_params[:release_date].empty? # no mail sent for validity/extended updates

    if r_params[:release_type] == "completion_release_date"
      ReleaseMailer.completion_release_email(@phase, updated_plots, r_params).deliver
    else
      ReleaseMailer.reservation_release_email(@phase, updated_plots, r_params).deliver
    end
  end
end
# rubocop:enable Metrics/ClassLength
