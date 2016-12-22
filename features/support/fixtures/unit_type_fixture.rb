# frozen_string_literal: true
module UnitTypeFixture
  module_function

  def create_developer_development
    FactoryGirl.create(
      :development,
      developer: create_developer,
      name: development_name
    )
  end

  def create_developer
    FactoryGirl.create(:developer, company_name: developer_name)
  end

  def create_unit_type
    FactoryGirl.create(
      :unit_type,
      name: unit_type_name,
      development: create_developer_development
    )
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

  def unit_type_name
    "Alpha"
  end

  def updated_unit_type_name
    "Beta"
  end

  def update_attrs
    {
      name: updated_unit_type_name
    }
  end
end
