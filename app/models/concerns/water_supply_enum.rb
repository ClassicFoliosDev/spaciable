# frozen_string_literal: true

module WaterSupplyEnum
  extend ActiveSupport::Concern

  included do
    enum water_supply:
    %i[
      mains_water, 
      private_water_supply
    ]
  end
end
