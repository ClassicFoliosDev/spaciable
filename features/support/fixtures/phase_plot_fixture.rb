# frozen_string_literal: true
module PhasePlotFixture
  module_function

  def create_developer_with_development_and_unit_types_and_phase
    development = FactoryGirl.create(
      :development,
      developer: create_developer,
      name: development_name
    )
    create_unit_types(development)
    create_phase(development)
  end

  def create_developer
    FactoryGirl.create(:developer, company_name: developer_name)
  end

  def create_unit_types(development)
    FactoryGirl.create(:unit_type, name: unit_type_name, development: development)
    FactoryGirl.create(:unit_type, name: updated_unit_type_name, development: development)
    FactoryGirl.create_list(:unit_type, 3, development: development)
  end

  def create_phase(development)
    FactoryGirl.create(:phase, name: phase_name, development: development)
  end

  def phase_name
    "Alpine"
  end

  def phase_id
    Phase.find_by(name: phase_name).id
  end

  def unit_type_name
    "3 Bedroom, 1 Bathroom"
  end

  def updated_unit_type_name
    "Studio"
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

  def plot_name
    "1"
  end

  def updated_plot_name
    "Plot 42"
  end

  def plot_number
    "1"
  end

  def updated_plot_number
    "42"
  end

  def update_attrs
    {
      prefix: "Plot",
      number: updated_plot_number,
      unit_type: updated_unit_type_name
    }
  end
end
