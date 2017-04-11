# frozen_string_literal: true
module Homeowners
  class AppliancesController < Homeowners::BaseController
    skip_authorization_check

    def show
      @appliances = Appliance.accessible_by(current_ability)
                             .includes(
                               :appliance_category,
                               :manufacturer
                             )
    end
  end
end
