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

  def update_attrs
    {
      prefix: "Plot",
      number: updated_plot_number,
      unit_type: updated_unit_type_name
    }
  end
end
