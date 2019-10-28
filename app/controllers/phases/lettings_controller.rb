# frozen_string_literal: true

module Phases
  class LettingsController < ApplicationController
    include PaginationConcern
    include SortingConcern

    before_action :check_account, if: -> { current_user.branch? }

    load_and_authorize_resource :phase

    def index
      set_plots

      if current_user.account? &&
         current_user.lettings_account.authorised?
        PlanetRent.property_types current_user do |types, error|
          flash[:alert] = error if error
          @property_types = types unless error
        end
      end

      # return to this paqe if redireced for Planet Rent actions
      session[:adminlistings] = PlanetRent::State.new request.original_url
      # State will be sent with any authorization request
      @state = session[:adminlistings]
    end

    # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
    def create
      PlanetRent.let_property(current_user, letting_params) do |_, error|
        if error
          flash[:alert] = error
        else
          Listing.update?(current_user, letting_params) do |success, uerror|
            plot = Plot.find(letting_params[:plot_id].to_i).to_s
            flash[:notice] = t("admin.users.lettings.confirm", plot: plot) if success
            flash[:alert] = uerror unless success
          end
        end
      end

      respond_to do |format|
        format.html { redirect_to(session[:adminlistings]) }
        format.json { render status: 200, json: session[:adminlistings].redirect_url.to_json }
      end
    end
    # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

    # Called for branch users to check they have an account set up.  Unlike
    # homeowners, branch users automatically create accounts on first use and
    # then have to authorise them in PlanetRent
    def check_account
      return if current_user.check_account?
      flash.now[:notice] = t("admin.users.lettings.no_account", user: current_user.to_s)
    end

    def letting_params
      params.require(:letting).permit(:bathrooms, :bedrooms, :landlord_pets_policy,
                                      :has_car_parking, :has_bike_parking, :property_type,
                                      :price, :shared_accommodation, :notes, :summary,
                                      :plot_id, :country,
                                      :address_1, :address_2, :town, :postcode, :other_ref)
    end

    private

    def set_plots
      @plots = if current_user.cf_admin?
                 Plot.joins(:listing)
                     .where(plots: { phase_id: @phase.id })
               else
                 Plot.joins(:listing)
                     .where(plots: { phase_id: @phase.id },
                            listings: { owner: Listing.owners[:admin] })
               end

      @plots = paginate(sort(@plots, default: :number))
    end
  end
end
