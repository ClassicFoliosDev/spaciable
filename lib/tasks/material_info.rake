# frozen_string_literal: true

namespace :material_info do
  task migrate: :environment do
    create_heating_records
  end

  def create_heating_records
    HeatingFuel.create(name: "Gas")
    HeatingFuel.create(name: "Electric")
    HeatingFuel.create(name: "Oil")
    HeatingFuel.create(name: "LPG")
    HeatingFuel.create(name: "Biomass")
    HeatingFuel.create(name: "Solar")
    HeatingFuel.create(name: "Air")
    HeatingFuel.create(name: "Ground")
    HeatingFuel.create(name: "Wood")

    HeatingSource.create(name: "Boiler")
    HeatingSource.create(name: "Air source heat pump")
    HeatingSource.create(name: "Ground source heat pump")
    HeatingSource.create(name: "Solar panels")
    HeatingSource.create(name: "Communal heating system")

    HeatingOutput.create(name: "Radiators")
    HeatingOutput.create(name: "Underfloor heating")
    HeatingOutput.create(name: "Panel heaters")
    HeatingOutput.create(name: "Fireplace")    
  end
end
