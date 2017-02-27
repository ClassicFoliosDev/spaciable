# frozen_string_literal: true
# rubocop:disable ModuleLength
# Method needs refactoring see HOOZ-232
module CreateFixture
  module_function

  RESOURCES ||= {
    appliance: "Bosch WAB28161GB Washing Machine",
    developer: "Hamble View Developer",
    development: "Riverside Development",
    division: "Hamble Riverside Division",
    division_development: "Hamble East Riverside (Division) Development",
    division_phase: "Beta (Division) Phase",
    finish: "Fluffy carpet",
    phase: "Alpha Phase",
    plot: "1",
    phase_plot: "2",
    division_plot: "3",
    room: "Living Room",
    unit_type: "8 Bedrooms"
  }.freeze

  # Generate methods for each resource, e.g. for 'phase: "Alpha Phase"':
  # ```
  # def phase_name
  #  "Alpha Phase"
  # end
  #
  # delegate :id, to: :phase, prefix: true
  # module_function :phase_id
  # ```
  RESOURCES.each_pair do |resource, name|
    define_method "#{resource}_name" do
      name
    end

    delegate :id, to: resource, prefix: true
    module_function :"#{resource}_id"
  end

  def get(resource, parent = nil)
    send ResourceName(resource, parent)
  end

  def ResourceName(resource, parent = nil)
    parent&.gsub!(/\W/, "") if parent

    [parent, resource].compact.map(&:to_s).map(&:downcase).join("_")
  end

  # Category and type selects for appliances and finishes
  def appliance_category_name
    "Washing Machine"
  end

  def appliance_manufacturer_name
    "Bosch"
  end

  def finish_category_name
    "Flooring"
  end

  def finish_type_name
    "Stone"
  end

  def energy_rating
    "a1"
  end

  # FACTORIES

  def create_admin(admin_type = :cf, parent = nil)
    resource_name = ResourceName(admin_type, parent)
    send("create_#{resource_name}_admin")
  end

  def create_cf_admin
    FactoryGirl.create(:cf_admin)
  end

  def create_developer_admin
    FactoryGirl.create(:developer_admin, permission_level: CreateFixture.developer)
  end

  def create_division_admin
    FactoryGirl.create(:division_admin, permission_level: CreateFixture.division)
  end

  def create_development_admin
    FactoryGirl.create(:development_admin, permission_level: CreateFixture.development)
  end

  def create_division_development_admin
    FactoryGirl.create(:development_admin, permission_level: CreateFixture.division_development)
  end

  def create_developer_with_division
    create_developer
    create_division
  end

  def create_developer_with_development
    create_developer
    create_development
  end

  def create_developer
    FactoryGirl.create(:developer, company_name: developer_name)
  end

  def create_division
    FactoryGirl.create(:division, division_name: division_name, developer: developer)
  end

  def create_development
    FactoryGirl.create(:development, name: development_name, developer: developer)
  end

  def create_division_development
    FactoryGirl.create(:division_development, name: division_development_name, division: division)
  end

  def create_unit_type
    FactoryGirl.create(:unit_type, name: unit_type_name, development: development)
  end

  def create_division_development_unit_type
    FactoryGirl.create(:unit_type, name: unit_type_name, development: division_development)
  end

  def create_room
    FactoryGirl.create(:room, name: room_name, unit_type: unit_type)
  end

  def create_appliance
    appliance_category = ApplianceCategory.find_by_name(appliance_category_name)
    manufacturer = Manufacturer.find_by_name(appliance_manufacturer_name)
    FactoryGirl.create(:appliance, name: appliance_name, appliance_category: appliance_category, manufacturer: manufacturer, e_rating: energy_rating)
  end

  def create_appliance_room
    FactoryGirl.create(:appliance_room, room: room, appliance: appliance)
  end

  def create_finish
    finish_category = FinishCategory.find_by_name(finish_category_name)
    finish_type = FinishType.find_by_name(finish_type_name)
    FactoryGirl.create(:finish, name: finish_name, finish_category: finish_category, finish_type: finish_type)
  end

  def create_development_phase
    FactoryGirl.create(:phase, name: phase_name, development: development)
  end

  def create_division_development_phase
    FactoryGirl.create(:phase, name: division_phase_name, development: division_development)
  end

  def create_phases
    create_development_phase
    create_division_development_phase
  end

  def create_development_plot
    FactoryGirl.create(:plot, development: development, unit_type: unit_type, number: plot_name)
  end

  def create_division_development_plot
    FactoryGirl.create(:plot, development: division_development, number: division_plot_name)
  end

  def create_phase_plot
    FactoryGirl.create(:phase_plot, phase: phase, number: phase_plot_name)
  end

  def create_plots
    create_development_plot
    create_division_development_plot
    create_phase_plot
  end

  def create_residents
    Plot.all.each do |plot|
      attrs = { first_name: "Resident of", last_name: "plot #{plot}", plot: plot }
      FactoryGirl.create(:resident, :with_residency, attrs)
    end
  end

  # INSTANCES

  def developer
    Developer.find_by(company_name: developer_name)
  end

  def division
    Division.find_by(division_name: division_name)
  end

  def development
    Development.find_by(name: development_name)
  end

  def division_development
    Development.find_by(name: division_development_name)
  end

  def phase
    Phase.find_by(name: phase_name)
  end

  def division_phase
    Phase.find_by(name: division_phase_name)
  end

  def unit_type
    UnitType.find_by(name: unit_type_name)
  end

  def room
    Room.find_by(name: room_name)
  end

  def appliance
    Appliance.find_by(name: appliance_name)
  end

  def plot
    development.plots.first
  end

  def division_plot
    division_development.plots.first
  end

  def phase_plot
    phase.plots.first
  end
end
# rubocop:enable ModuleLength
