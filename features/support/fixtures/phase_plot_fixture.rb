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
    create_contact(development)

  end

  def create_developer
    FactoryGirl.create(:developer, company_name: developer_name)
  end

  def create_contact(development)
    FactoryGirl.create(:contact, contactable: development)
  end

  def create_unit_types(development)
    unit_one= FactoryGirl.create(:unit_type, name: unit_type_name, development: development)
    FactoryGirl.create(:unit_type, name: updated_unit_type_name, development: development)
    FactoryGirl.create_list(:unit_type, 3, development: development)

    room = FactoryGirl.create(:room, unit_type: unit_one)
    appliance = FactoryGirl.create(:appliance)
    FactoryGirl.create(:appliance_room, appliance: appliance, room: room)
  end

  def create_phase(development)
    FactoryGirl.create(:phase, name: phase_name, development: development)
  end

  def create_another_phase_plot
    FactoryGirl.create(:phase_plot,
                       phase: CreateFixture.phase,
                       number: another_plot_number,
                       unit_type: CreateFixture.unit_type)
  end

  def phase_name
    "Alpine"
  end

  def phase
    Phase.find_by(name: phase_name)
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
    CreateFixture.phase_plot_name
  end

  def plot_number
    CreateFixture.phase_plot_name
  end

  def another_plot_number
    "50 B"
  end

  def prefix_plot_number
    "18"
  end

  def prefix_postal_number
    "7c"
  end

  def updated_plot_name
    update_attrs[:number]
  end

  def updated_house_number
    "42"
  end

  def plot_house_number
    "124"
  end

  def plot_building_name
    "Armada building"
  end

  def plot_road_name
    "Phase plot road"
  end

  def plot_postcode
    "SO33 4FG"
  end

  def plot
    phase.plots.find_by(number: updated_plot_name)
  end

  def updated_plot
    phase.plots.find_by(number: update_attrs[:number])
  end

  def update_attrs
    {
      number: CreateFixture.phase_plot_name.to_i + 1,
      house_number: updated_house_number,
      building_name: plot_building_name,
      road_name: plot_road_name,
      postcode: plot_postcode
    }
  end
end
