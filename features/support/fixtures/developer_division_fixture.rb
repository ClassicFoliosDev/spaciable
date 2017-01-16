# frozen_string_literal: true
module DeveloperDivisionFixture
  module_function

  def updated_division_name
    "Beta Division"
  end

  def second_division_name
    "Gamma Division"
  end

  def update_attrs
    {
      email: "alpha.division@example.com",
      contact_number: "07713538572"
    }
  end

  def division_address_attrs
    {
      postal_name: "Dragon Division",
      building_name: "Mega Building",
      road_name: "Foo Road",
      city: "Wadeland",
      county: "Kent",
      postcode: "BR01 5HY"
    }
  end
end
