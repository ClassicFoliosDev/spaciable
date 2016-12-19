# frozen_string_literal: true
module DeveloperFixture
  module_function

  def update_attrs
    {
      company_name: updated_company_name,
      postal_name: "Langosh Fort",
      building_name: "Mega Building",
      road_name: "Swampy Road",
      city: "Wadeland",
      county: "Gibsonton",
      postcode: "RG13 5HY",
      email: "hamble.developers@example.com",
      contact_number: "07713538572",
      about: about
    }
  end

  def company_name
    "Hamble Developments LTD"
  end

  def about
    <<~ABOUT
      Established in 1977. Hamble Developments have been serving the local area
      with exceptional housing that combines the maritime location with comfortable living.
    ABOUT
  end

  def updated_company_name
    "Hamble View LTD"
  end
end
