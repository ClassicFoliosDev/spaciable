# frozen_string_literal: true
# rubocop:disable ModuleLength
# Method needs refactoring see HOOZ-232
module CreateFixture
  module_function

  RESOURCES ||= {
    appliance: "Bosch WAB28161GB Washing Machine",
    developer: "Hamble View Developer",
    development: "Riverside Development",
    division: "Hamble Riverside",
    division_development: "Hamble East Riverside (Division) Development",
    division_phase: "Beta (Division) Phase",
    finish: "Fluffy carpet",
    phase: "Alpha Phase",
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

  # FACTORIES

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
    FactoryGirl.create(:unit_type, name: unit_type_name, development: create_developer_with_development)
  end

  def create_room
    FactoryGirl.create(:room, name: room_name, unit_type: create_unit_type)
  end

  def create_appliance
    appliance_category = ApplianceCategory.find_by_name(appliance_category_name)
    manufacturer = Manufacturer.find_by_name(appliance_manufacturer_name)
    FactoryGirl.create(:appliance, name: appliance_name, appliance_category: appliance_category, manufacturer: manufacturer)
  end

  def create_finish
    finish_category = FinishCategory.find_by_name(finish_category_name)
    finish_type = FinishType.find_by_name(finish_type_name)
    FactoryGirl.create(:finish, name: finish_name, finish_category: finish_category, finish_type: finish_type)
  end

  def create_phases
    FactoryGirl.create(:phase, name: phase_name, development: development)
    FactoryGirl.create(:phase, name: division_phase_name, development: division_development)
  end

  def create_plots
    FactoryGirl.create(:plot, development: development)
    FactoryGirl.create(:plot, development: division_development)
    FactoryGirl.create(:phase_plot, phase: phase)
  end

  def create_residents
    Plot.all.each do |plot|
      attrs = { first_name: "Resident of", last_name: "plot #{plot}" }
      resident = FactoryGirl.create(:homeowner, attrs)
      resident.plots << plot
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
end
# rubocop:enable ModuleLength
