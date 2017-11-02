# frozen_string_literal: true

module DivisionDevelopmentFixture
  module_function

  def updated_development_name
    "Harbourside Development"
  end

  def second_development_name
    "Forest View"
  end

  def update_attrs
    {
      email: "hamble.developers@example.com",
      contact_number: "07713538572",
      maintenance_link: "https://brillianthomes.fixflo.com/issue/plugin"
    }
  end

  def development_address_update_attrs
    {
      postal_number: "Langosh Fort",
      building_name: "Mega Building",
      road_name: "Swampy Road",
      city: "Wadeland",
      county: "Gibsonton",
      postcode: "RG13 5HY"
    }
  end
end
