# frozen_string_literal: true

module ElectricitySupplyEnum
  extend ActiveSupport::Concern

  included do
    enum electricity_supply: 
    %i[
      mains_electricity
      pv_supplemented
      private_supply
      wind_turbines 
      electricty_other
    ]
  end
end
