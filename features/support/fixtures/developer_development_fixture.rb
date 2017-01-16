# frozen_string_literal: true
module DeveloperDevelopmentFixture
  module_function

  def updated_development_name
    "Harbourside Development"
  end

  def second_development_name
    "Meadow View"
  end

  def update_attrs
    {
      email: "hamble.developers@example.com",
      contact_number: "07713538572"
    }
  end

  def development_address_update_attrs
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
