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
      postal_name: "Fort Langosh",
      building_name: "Building Mega",
      road_name: "Road Swampy",
      city: "Wade Forest",
      county: "Gibson",
      postcode: "RH14 7FY"
    }
  end

  def development_address_attrs
    {
      postal_name: "Langosh Fort",
      building_name: "Mega Building",
      road_name: "Swampy Road",
      city: "Wadeland",
      county: "Gibsonton",
      postcode: "RG13 5HY"
    }
  end
end
