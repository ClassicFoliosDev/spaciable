# frozen_string_literal: true
module Homeowners
  class AppliancesController < Homeowners::BaseController
    skip_authorization_check

    def show
      @appliances = Appliance.accessible_by(Ability.new(current_resident))
      @plot = current_resident.plot
      @brand = current_resident.brand
    end
  end
end
