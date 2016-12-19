# frozen_string_literal: true
module PhaseFixture
  module_function

  def create_developer_with_development
    FactoryGirl.create(
      :development,
      developer: create_developer,
      name: development_name
    )
  end

  def create_developer
    FactoryGirl.create(:developer, company_name: developer_name)
  end

  def developer_name
    "Development Developer Ltd"
  end

  def development_name
    "Riverside Development"
  end

  def developer_id
    Developer.find_by(company_name: developer_name).id
  end

  def development_id
    Development.find_by(name: development_name).id
  end

  def phase_name
    "Phase Alpha"
  end

  def updated_phase_name
    "Phase Beta"
  end

  def update_attrs
    {
      name: updated_phase_name,
      postal_name: "Langosh Fort",
      building_name: "Mega Building",
      road_name: "Swampy Road",
      city: "Wadeland",
      county: "Gibsonton",
      postcode: "RG13 5HY"
    }
  end
end
