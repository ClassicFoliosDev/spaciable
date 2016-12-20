# frozen_string_literal: true
module DeveloperDevelopmentFixture
  module_function

  def create_developer
    FactoryGirl.create(:developer, company_name: developer_name)
  end

  def developer_name
    "Development Developer Ltd"
  end

  def developer_id
    Developer.find_by(company_name: developer_name).id
  end

  def development_name
    "Riverside Development"
  end

  def updated_development_name
    "Harbourside Development"
  end

  def update_attrs
    {
      name: updated_development_name,
      email: "hamble.developers@example.com",
      contact_number: "07713538572"
    }
  end

  def address_update_attrs
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
