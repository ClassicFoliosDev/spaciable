# frozen_string_literal: true

class BulkEditController < ApplicationController
  load_and_authorize_resource :phase

  def index
    return redirect_to root_path unless current_user.cf_admin?
    @resident_count = @phase.plot_residencies.size
    @subscribed_resident_count = @phase.residents.where(cf_email_updates: true).size

    @active_plots_count = @phase.active_plots_count
    @completed_plots_count = @phase.completed_plots_count
    @expired_plots_count = @phase.expired_plots_count
    @activated_resident_count = @phase.activated_resident_count
  end

  def create
    update_plots
  end

  protected

  # Never trust parameters from the scary internet, only allow the white list through.
  def bulk_params
    params.require(:phase_bulk_edit).permit(
      %i[range_from range_to list prefix number unit_type_id house_number road_name building_name
         postcode reservation_release_date completion_release_date validity extended_access
         copy_plot_numbers prefix_check number_check unit_type_id_check house_number_check
         road_name_check building_name_check postcode_check reservation_release_date_check
         completion_release_date_check validity_check extended_access_check]
    )
  end

  def update_plots
    plot = Plot.new(number: Plot::DUMMY_PLOT_NAME, phase: @phase)
    BulkPlots::UpdateService.call(plot, params: bulk_params) do |_service, updated_plots, errors|
      if updated_plots.any?
        redirect_to development_phase_path(@phase.parent, @phase),
                    notice: success_notice(updated_plots), alert: errors
      else
        flash.now[:alert] = errors if errors

        render :index
      end
    end
  end

  def success_notice(updated_plots)
    if updated_plots.count == 1
      t(".success_one", plot_number: updated_plots.first)
    else
      t(".success", plot_numbers: updated_plots.to_sentence)
    end
  end
end
