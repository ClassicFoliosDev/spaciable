# frozen_string_literal: true
module DeveloperDivisionFixture
  module_function

  def create_developer
    FactoryGirl.create(:developer, company_name: developer_name)
  end

  def developer_name
    "Division Developer Ltd"
  end

  def developer_id
    Developer.find_by(company_name: developer_name).id
  end

  def division_name
    "Alpha Division"
  end

  def updated_division_name
    "Beta Division"
  end

  def update_attrs
    {
      division_name: updated_division_name,
      email: "alpha.division@example.com",
      contact_number: "07713538572"
    }
  end

  def address_attrs
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
