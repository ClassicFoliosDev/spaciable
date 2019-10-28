# frozen_string_literal: true

module Homeowners
  class LettingsController < Homeowners::BaseController
    skip_authorization_check

    # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
    def show
      return unless current_resident

      @plots_listing_by_homeowner = current_resident.homeowner_listing_plots
      @plots_listing_by_others = current_resident.plots_listing_by_others

      redirect_to root_url unless @plots_listing_by_homeowner

      if current_resident.lettings_account &&
         current_resident.lettings_account.authorised?
        PlanetRent.property_types current_resident do |types, error|
          flash[:alert] = error if error
          @property_types = types unless error
        end
      end

      # return to this paqe if redireced for Planet Rent actions
      unless session[:landlordlistings]
        session[:landlordlistings] = PlanetRent::State.new request.original_url
      end

      # State will be sent with any authorization request
      @state = session[:landlordlistings]
    end

    def create
      PlanetRent.let_property(current_resident, letting_params) do |_, error|
        if error
          flash[:alert] = error
        else
          Listing.update?(current_resident, letting_params) do |success, uerror|
            plot = Plot.find(letting_params[:plot_id].to_i).to_s
            if success
              flash[:notice] = t("homeowners.lettings.confirm", plot: plot)
            else
              flash[:alert] = uerror
            end
          end
        end
      end

      respond_to do |format|
        format.html { redirect_to(session[:landlordlistings]) }
        format.json { render status: 200, json: session[:landlordlistings].redirect_url.to_json }
      end
    end

    private

    def letting_params
      params.require(:letting).permit(:bathrooms, :bedrooms, :landlord_pets_policy,
                                      :has_car_parking, :has_bike_parking, :property_type,
                                      :price, :shared_accommodation, :notes, :summary,
                                      :plot_id, :country,
                                      :address_1, :address_2, :town, :postcode, :other_ref)
    end
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize
end
