# frozen_string_literal: true

module PhasePlotFixture
  module_function

  def create_developer_with_development_and_unit_types_and_phase(cas: nil)
    CreateFixture.create_developer(cas: cas)
    CreateFixture.create_division
    development = CreateFixture.create_development(cas: nil)
    create_unit_types(development, updating_user: $current_user)
    create_phase(development)
    create_contact(development)

    development = CreateFixture.create_division_development(cas: cas)
    create_unit_types(development, updating_user: $current_user)
    create_phase(development, division_phase_name)
    create_contact(development)
  end

  def create_spanish_developer_with_development_and_unit_types_and_phase
    spanish_development = FactoryGirl.create(
      :development,
      developer: create_spanish_developer,
      name: spanish_development_name
    )
    create_unit_types(spanish_development)
    create_spanish_phase(spanish_development)
    create_contact(spanish_development)

  end

  def create_spanish_developer
    CreateFixture.create_countries
    FactoryGirl.create(:developer, company_name: spanish_developer_name, country_id: Country.find_by(name: "Spain").id)
  end

  def create_contact(development)
    FactoryGirl.create(:contact, contactable: development)
  end

  def create_unit_types(development, updating_user: CreateFixture.cf_admin)
    unit_one = FactoryGirl.create(:unit_type, name: unit_type_name, development: development)
    FactoryGirl.create(:unit_type, name: updated_unit_type_name, development: development)
    FactoryGirl.create_list(:unit_type, 3, development: development)

    room = FactoryGirl.create(:room, unit_type: unit_one)
    appliance = FactoryGirl.create(:appliance)
    FactoryGirl.create(:appliance_room, appliance: appliance, room: room)
  end

  def create_phase(development, name=phase_name)
    FactoryGirl.create(:phase, name: name, development: development)
  end

  def create_spanish_phase(development)
    FactoryGirl.create(:phase, name: spanish_phase_name, development: development)
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

  def division_phase_name
    "Lupine"
  end

  def spanish_phase_name
    "Ola"
  end

  def phase
    Phase.find_by(name: phase_name)
  end

  def division_phase
    Phase.find_by(name: division_phase_name)
  end

  def spanish_phase
    Phase.find_by(name: spanish_phase_name)
  end

  def unit_type_name
    "3 Bedroom, 1 Bathroom"
  end

  def updated_unit_type_name
    "Studio"
  end

  def spanish_developer_name
    "Madrid Developer Sp"
  end

  def spanish_development_name
    "Casa Development"
  end

  def developer_id
    Developer.find_by(company_name: CreateFixture.developer_name).id
  end

  def spanish_developer_id
    Developer.find_by(company_name: spanish_developer_name).id
  end

  def development_id
    Development.find_by(name: CreateFixture.development_name).id
  end

  def spanish_development_id
    Development.find_by(name: spanish_development_name).id
  end

  def unit_type_id
    UnitType.find_by(name: unit_type_name).id
  end

  def plot_name
    CreateFixture.phase_plot_name
  end

  def plot_number
    CreateFixture.phase_plot_name
  end

  def invalid_plot_range_numbers
    "AC-1~AC2"
  end

  def valid_plot_range_numbers
    ["AC-1", "AC-2", "AC-3", "AC-4"]
  end

  def invalid_plot_range
    "Invalid range #{invalid_plot_range_numbers}"
  end

  def valid_plot_range
    "#{valid_plot_range_numbers.first}~#{valid_plot_range_numbers.last}"
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

  def create_phase_plot
    phase = Phase.find_by(name: PhasePlotFixture.phase_name)
    unit_type = UnitType.find_by(name: PhasePlotFixture.unit_type_name)
    FactoryGirl.create(:plot, phase: phase, unit_type: unit_type, number: plot_number)
  end
end
