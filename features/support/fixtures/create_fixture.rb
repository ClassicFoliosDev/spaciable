# frozen_string_literal: true

# rubocop:disable ModuleLength
# Method needs refactoring see HOOZ-232
module CreateFixture
  module_function

  RESOURCES ||= {
    appliance: "WAB28161GB",
    appliance_without_manual: "Appliance without manual",
    developer: "Hamble View Developer",
    development: "Riverside Development",
    division: "Hamble Riverside Division",
    division_development: "Hamble East Riverside Division Development",
    division_phase: "Beta (Division) Phase",
    division_contact: "John",
    finish: "Fluffy carpet",
    phase: "Alpha Phase",
    plot: "100",
    phase_plot: "200",
    division_plot: "300",
    room: "Living Room",
    unit_type: "8 Bedrooms",
    how_to: "How to dig yourself a hole",
    contact: "Jane",
    faq: "How do I dig holes?",
    notification: "You have dug a hole"
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

  def full_appliance_name
    appliance_manufacturer_name + " " + appliance_name
  end

  def admin_password
    "fooBar12"
  end

  # Category and type selects for appliances and finishes
  def appliance_category_name
    "Washing Machine"
  end

  def appliance_manufacturer_name
    "Bosch"
  end

  def finish_manufacturer_name
    "Farrow & Ball"
  end

  def finish_category_name
    "Flooring"
  end

  def finish_type_name
    "Carpet"
  end

  def energy_rating
    "a1"
  end

  def resident_email
    "resident@example.com"
  end

  def manufacturer_link
    "https://www.example.com/register"
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
    FactoryGirl.create(:developer_admin, permission_level: CreateFixture.developer, password: admin_password)
  end

  def create_division_admin
    FactoryGirl.create(:division_admin, permission_level: CreateFixture.division, password: admin_password)
  end

  def create_development_admin
    FactoryGirl.create(:development_admin, permission_level: CreateFixture.development, password: admin_password)
  end

  def create_division_development_admin
    FactoryGirl.create(:development_admin, permission_level: CreateFixture.division_development, password: admin_password)
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
    FactoryGirl.create(:developer, company_name: developer_name, house_search: true)
  end

  def create_division
    FactoryGirl.create(:division, division_name: division_name, developer: developer)
  end

  def create_development
    FactoryGirl.create(:development, name: development_name, developer: developer, maintenance_link: "https://dummy.fixflo.com/issue/plugin/")
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

  def appliance_category
    ApplianceCategory.find_or_create_by(name: appliance_category_name)
  end

  def create_finish_manufacturer
    FactoryGirl.create(:finish_manufacturer,
                       name: finish_manufacturer_name,
                       finish_types: [create_finish_type])
  end

  def create_appliance_manufacturer
    FactoryGirl.create(:appliance_manufacturer,
                       name: appliance_manufacturer_name,
                       link: manufacturer_link)
  end

  def create_appliance
    FactoryGirl.create(:appliance,
                       appliance_category: appliance_category,
                       appliance_manufacturer: appliance_manufacturer,
                       e_rating: energy_rating,
                       model_num: appliance_name)
  end

  def create_notification
    notification = FactoryGirl.create(:notification, subject: notification_name, send_to_type: "Phase", send_to_id: phase.id)
    FactoryGirl.create(:resident_notification, resident_id: resident.id, notification_id: notification.id)
  end

  def create_faq
    FactoryGirl.create(:faq, question: faq_name, developer: developer, faqable: developer)
  end

  def create_appliance_without_manual
    FactoryGirl.create(
      :appliance,
      name: appliance_without_manual_name,
      appliance_category: appliance_category,
      appliance_manufacturer: appliance_manufacturer,
      rooms: [room],
      manual: nil,
      guide: nil
    )
  end

  def create_appliance_room
    FactoryGirl.create(:appliance_room, room: room, appliance: appliance)
  end

  def create_finish_category
    FinishCategory.find_or_create_by(name: finish_category_name)
  end

  def create_finish_type
    finish_category = create_finish_category
    FactoryGirl.create(:finish_type,
                       name: finish_type_name,
                       finish_categories: [finish_category])
  end

  def create_finish
    FactoryGirl.create(:finish, name: finish_name, finish_category: create_finish_category, finish_type: create_finish_type)
  end

  def create_finish_room
    FactoryGirl.create(:finish_room, room: room, finish: create_finish)
  end

  def create_development_phase
    FactoryGirl.create(:phase, name: phase_name, development: development, address: create_address)
  end

  def create_division_development_phase
    FactoryGirl.create(:phase, name: division_phase_name, development: division_development)
  end

  def create_phases
    create_development_phase
    create_division_development_phase
  end

  def create_development_plot
    FactoryGirl.create(:plot, development: development, unit_type: unit_type, prefix: "", number: plot_name)
  end

  def create_division_development_plot
    FactoryGirl.create(:plot, development: division_development, prefix: "", number: division_plot_name)
  end

  def create_address
    FactoryGirl.create(:address, building_name: "Quartz Tower", road_name: "Sapphire Road",
                                 locality: "Pearlville", postcode: "HTTP 404")
  end

  def create_phase_plot
    FactoryGirl.create(:phase_plot, phase: phase, number: phase_plot_name, prefix: "", unit_type: unit_type)
  end

  def create_plots
    create_unit_type
    create_development_plot
    create_division_development_plot
    create_phase_plot
  end

  def create_activated_residents
    Plot.all.each do |plot|
      attrs = { first_name: "Resident of", last_name: "plot #{plot}", plot: plot }
      FactoryGirl.create(:resident, :with_residency, :activated, attrs)
    end
  end

  def create_resident
    FactoryGirl.create(:resident, :with_residency, plot: phase_plot, email: resident_email, developer_email_updates: 1)
  end

  def create_division_contacts
    FactoryGirl.create(:contact, contactable: developer, category: "management")
    FactoryGirl.create(:contact, first_name: division_contact_name, contactable: division, category: "customer_care")
    FactoryGirl.create(:contact, contactable: division_development, category: "management")
  end

  def create_how_tos
    FactoryGirl.create(:how_to, :with_tag, category: "diy", title: how_to_name)
    FactoryGirl.create(:how_to, :with_tag)
    FactoryGirl.create(:how_to, :with_tag, category: "diy")
  end

  def create_contacts
    FactoryGirl.create(:contact, first_name: contact_name, contactable: developer, category: "emergency")
    FactoryGirl.create(:contact, contactable: development, category: "services")
  end

  def create_document
    FactoryGirl.create(:document, developer: developer, documentable: developer)
  end

  def create_development_document
    FactoryGirl.create(:document, development: CreateFixture.development, documentable: CreateFixture.development)
  end

  def create_division_document
    FactoryGirl.create(:document, division: CreateFixture.division, documentable: CreateFixture.division)
  end

  def create_private_document
    FactoryGirl.create(:private_document, resident: CreateFixture.resident)
  end

  def create_resident_under_a_phase_plot
    create_developer
    create_development
    create_development_phase
    create_unit_type
    create_phase_plot
    create_resident
  end

  def create_resident_under_a_phase_plot_with_appliances_and_rooms
    create_resident_under_a_phase_plot
    create_room
    create_appliance
    create_appliance_room
    create_appliance_without_manual
  end

  def create_sub_category
    FactoryGirl.create(:how_to_sub_category, name: HowToFixture.sub_category, parent_category: HowToFixture.category)
  end

  # INSTANCES

  def cf_admin
    User.find_by(role: :cf_admin)
  end

  def developer_admin
    User.find_by(role: :developer_admin)
  end

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

  def finish_category
    FinishCategory.find_by(name: finish_category_name)
  end

  def appliance
    Appliance.find_by(model_num: appliance_name)
  end

  def development_plot
    development.plots.first
  end

  def division_plot
    division_development.plots.first
  end

  def phase_plot
    phase.plots.first
  end

  def resident
    Resident.find_by(email: resident_email)
  end

  def appliance_manufacturer
    ApplianceManufacturer.find_by(name: appliance_manufacturer_name)
  end
end
# rubocop:enable ModuleLength
