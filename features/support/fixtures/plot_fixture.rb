# frozen_string_literal: true
module PlotFixture
  extend ModuleImporter
  import_module CreateFixture

  module_function

  def create_developer_with_development_and_unit_types
    development = FactoryGirl.create(
      :development,
      developer: create_developer,
      name: development_name
    )
    create_unit_types(development)
  end

  def development_postal_name
    "Langosh Fort"
  end

  def create_unit_types(development)
    FactoryGirl.create(:unit_type, name: unit_type_name, development: development)
    FactoryGirl.create(:unit_type, name: updated_unit_type_name, development: development)
    FactoryGirl.create_list(:unit_type, 3, development: development)
  end

  def unit_type_name
    "3 Bedroom, 1 Bathroom"
  end

  def updated_unit_type_name
    "Studio"
  end

  def plot_id
    development.plots.find_by(prefix: "Plot", number: 42).id
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

  def plot_house_number
    "6B"
  end

  def plot_building_name
    "Marina building"
  end

  def plot_road_name
    "Plot road"
  end

  def plot_postcode
    "SO33 4FE"
  end

  def update_attrs
    {
      prefix: "Plot",
      number: updated_plot_number,
      house_number: plot_house_number,
      address_attributes_building_name: plot_building_name,
      address_attributes_road_name: plot_road_name,
      address_attributes_postcode: plot_postcode
    }
  end
end
