# frozen_string_literal: true

class LettingsController < ApplicationController
  include PaginationConcern
  include SortingConcern

  load_and_authorize_resource :development
  load_and_authorize_resource :phase
  load_and_authorize_resource :plot, through: %i[development phase], shallow: true

  def index
    @resident_count = @phase.plot_residencies.size
    @subscribed_resident_count = @phase.residents.where(cf_email_updates: true).size

    @letting = Letting.new
    @lettings_account = LettingsAccount.new
  end

  def show; end

  def update; end

  def create
    if current_user.cf_admin?
      update_plots
    else
      # PLANET RENT API
      # We need to send the letting to Planet Rent before saving it, and when the plot is set up
      # on Planet Rent, we then need a callback from them to tell us the plot is set up.
      # We then save the letting to the database and update the plot.let field to true
      # and flash a notice confirming the plot setup
      # The json is rendering but we need to force a page refresh
      # to show that the plot now has its letting set up
      @letting = Letting.new(letting_params)
      @letting.save!
      if @letting.save
        render json: { notice: t("lettings.success.letting_confirm") }
      end
    end
  end

  protected

  def letting_params
    params.require(:letting).permit(:bathrooms, :bedrooms, :landlord_pets_policy,
                                    :has_car_parking, :has_bike_parking, :property_type,
                                    :price, :shared_accommodation, :notes, :summary,
                                    :plot_id, :lettings_account_id, :country,
                                    :address_1, :address_2, :town, :postcode, :other_ref)
  end

  def bulk_params
    params.require(:phase_bulk_edit).permit(%i[range_from range_to letable
                                               letable_type letter_type phase_id list])
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
