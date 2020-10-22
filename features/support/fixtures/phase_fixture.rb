# frozen_string_literal: true

module PhaseFixture
  module_function

  def updated_phase_name
    "Phase Beta"
  end

  def updated_phase_number
    "10"
  end

  def update_attrs
    {
      name: updated_phase_name,
      number: updated_phase_number
    }
  end

  def address_update_attrs
    {
      postal_number: "Fort Langosh",
      building_name: "Building Mega",
      road_name: "Road Swampy",
      locality: "Ity Local",
      city: "Wade Forest",
      county: "Gibson",
      postcode: "RH14 7FY"
    }
  end

  def development_address_attrs
    {
      locality: "Local Ity",
      city: "Wadeland",
      county: "Gibsonton",
    }
  end

   def spanish_development_address_attrs
    {
      locality: "Catalan",
      city: "Barc",
    }
  end

  def progress
    "Ready for exchange"
  end
end
