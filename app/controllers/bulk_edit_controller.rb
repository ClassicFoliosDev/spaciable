# frozen_string_literal: true

class BulkEditController < ApplicationController
  load_and_authorize_resource :phase

  def index
    return redirect_to root_path unless can? :bulk_edit, @phase

    @active_tab = "bulk_edit"
  end

  def create
    update_plots
  end

  protected

  # Never trust parameters from the scary internet, only allow the white list through.
  def bulk_params
    params.require(:phase_bulk_edit).permit(
      %i[range_from range_to list prefix number unit_type_id ut_update_option house_number
         road_name building_name
         postcode reservation_release_date completion_release_date validity extended_access
         completion_order_number reservation_order_number
         completion_order_number_check reservation_order_number_check
         copy_plot_numbers prefix_check number_check unit_type_id_check house_number_check
         road_name_check building_name_check postcode_check reservation_release_date_check
         completion_release_date_check validity_check extended_access_check
         build_step_id build_step_id_check completion_date completion_date_check]
    )
  end

  def update_plots
    plot = Plot.new(number: Plot::DUMMY_PLOT_NAME, phase: @phase)
    BulkPlots::UpdateService.call(plot, self, params: bulk_params) \
      do |_service, updated_plots, errors|
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
