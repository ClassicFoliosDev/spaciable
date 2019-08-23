# frozen_string_literal: true

module Homeowners
  class LettingsController < Homeowners::BaseController
    skip_authorization_check

    def show
      return unless current_resident

      current_resident.plots.each do |plot|
        @letable = true if plot.letable && current_resident&.plot_residency_homeowner?(plot)
      end
      redirect_to root_url unless @letable == true

      @plots = current_resident.plots
      @plots = @plots.order(number: :asc)

      @letting = Letting.new
      @lettings_account = LettingsAccount.new
    end

    def create
      # PLANET RENT API
      # We need to send the letting to Planet Rent before saving it, and when the plot is set up
      # on Planet Rent, we then need a callback from them to tell us the plot is set up.
      # We then save the letting to the database and update the plot.let field to true
      # and flash a notice confirming the plot setup
      # The json is rendering but we need to force a page refresh
      # to show that the plot now has its letting set up
      @letting = Letting.new(letting_params)
      render json: { notice: t("homeowners.lettings.confirm") } if @letting.save
    end

    private

    def letting_params
      params.require(:letting).permit(:bathrooms, :bedrooms, :landlord_pets_policy,
                                      :has_car_parking, :has_bike_parking, :property_type,
                                      :price, :shared_accommodation, :notes, :summary,
                                      :plot_id, :lettings_account_id, :country,
                                      :address_1, :address_2, :town, :postcode, :other_ref)
    end
  end
end
