# frozen_string_literal: true

module Homeowners
  class AppliancesController < Homeowners::BaseController
    skip_authorization_check

    def show
      @appliances = []
      @appliances << Appliance.accessible_by(current_ability)
                              .includes(
                                :appliance_category,
                                :appliance_manufacturer
                              ).to_a

      @appliances << @plot.appliance_choices if @plot.choices_approved?
      @appliances.flatten!
    end
  end
end
