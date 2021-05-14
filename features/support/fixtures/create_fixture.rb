# frozen_string_literal: true

# rubocop:disable ModuleLength
# Method needs refactoring see HOOZ-232
module CreateFixture
  module_function

  RESOURCES ||= {
    appliance: "WAB28161GB",
    appliance_without_manual: "Appliance without manual",
    developer: "Hamble & Rice Developer",
    branded_developer: "_-+':,&%Developer",
    spanish_developer: "Madrid Inc",
    development: "R&B Development",
    branded_development: "R&B_D'V_+%{}[],",
    spanish_development: "Barc Development",
    division: "Hamble&Gamble Division",
    branded_division: "A_-&G*^+,:.Division",
    spanish_division: "Barca Division",
    division_development: "Hamble East Riverside Division Development",
    branded_division_development: ")({}*%+:,&) Development",
    spanish_division_development: "El Capitan Development",
    division_phase: "Beta (Division) Phase",
    spanish_division_phase: "Beta (Division) Phase",
    division_contact: "John",
    finish: "Fluffy carpet",
    finish_dup: "Fluffier carpet",
    phase: "Alpha Phase",
    spanish_phase: "Barca Phase",
    plot: "100",
    spanish_plot: "100",
    phase_plot: "200",
    phase_plot2: "101",
    phase_plot3: "102",
    spanish_phase_plot: "200",
    division_plot: "300",
    spanish_division_plot: "300",
    room: "Living Room",
    bedroom: "Bedroom",
    bedroom2: "Bedroom 2",
    bathroom: "Bathroom",
    lounge: "Living Room",
    kitchen: "Kitchen",
    unit_type: "8 Bedrooms",
    second_unit_type: "Banjiha",
    how_to: "How to dig yourself a hole",
    contact: "Jane",
    faq: "How do I dig holes?",
    notification: "You have dug a hole",
    choice_configuration: "Appartment Choice Config"
  }.freeze

  APPLIANCERESOURCES ||= [ "Oven" , "Fridge", "Freezer" ]

  FINISHRESOURCES ||= [
    ["Wallcovering", "Paint", "Crown", ["red", "blue", "purple", "green"]],
    ["Splashback", "Tiles", "Johnson", ["Morrocco", "Azure", "Clown", "Flowers"]],
    ["Flooring", "Rug", "Wilton", ["maize", "sunflower", "bluebell", "grass"]]
  ]

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

  # Category and type selects for appliances and finishes
  def developer_appliance_category_name
    "Vaccuum"
  end

  def appliance_manufacturer_name
    "Bosch"
  end

  def developer_appliance_manufacturer_name
    "Bish"
  end

  def finish_manufacturer_name
    "Farrow & Ball"
  end

  def seeded_finish_manufacturer_name
    "Cormar Carpets"
  end

  def finish_category_name
    "Flooring"
  end

  def finish_type_name
    "Rug"
  end

  def seed_finish_type_name
    "Carpet"
  end

  def energy_rating
    "a1"
  end

  def resident_email
    "resident@example.com"
  end

  def tenant_email
    "tenant@example.com"
  end

  def manufacturer_link
    "https://www.example.com/register"
  end

  def choice_email_contact
    "choices@developer.com"
  end

  def rejection_message
    "The selected appliance is no longer available, please select a replacement"
  end

  def spanish_developer_id
    Developer.find_by(company_name: spanish_developer_name).id
  end

  def another_unit_type_name
    "Another"
  end

  # FACTORIES

  def create_admin(admin_type = :cf, parent = nil)
    resource_name = ResourceName(admin_type, parent)
    send("create_#{resource_name}_admin")
  end

  def create_cf_admin
    FactoryGirl.create(:cf_admin)
  end

  def create_developer_admin(cas: false)
    FactoryGirl.create(:developer_admin, permission_level: CreateFixture.developer, password: admin_password, cas: cas)
  end

  def create_division_admin(cas: false)
    FactoryGirl.create(:division_admin, permission_level: CreateFixture.division, password: admin_password, cas: cas)
  end

  def create_development_admin(cas: false)
    FactoryGirl.create(:development_admin, permission_level: CreateFixture.development, password: admin_password, cas: cas)
  end

  def create_site_admin(cas: false)
    FactoryGirl.create(:site_admin, permission_level: CreateFixture.development, password: admin_password, cas: cas)
  end

  def create_division_development_admin
    FactoryGirl.create(:development_admin, permission_level: CreateFixture.division_development, password: admin_password)
  end

  def create_developer_with_division(branded: false)
    create_developer(branded: branded)
    create_division(branded: branded)
  end

  def create_spanish_developer_with_division
    create_spanish_developer
    create_spanish_division
  end

  def create_developer_with_development(cas: false)
    create_developer(cas: cas)
    create_development(cas: cas)
  end

  def create_spanish_developer_with_development
    create_spanish_developer
    create_spanish_development
  end

  def create_developer(cas: false,  branded: false, name: developer_name)
    return developer if developer
    create_countries
    dname = branded ? branded_developer_name : name
    FactoryGirl.create(:developer, company_name: dname, custom_url: dname.parameterize,
                       house_search: true, enable_referrals: true, country_id: uk.id,
                       cas: cas, enable_services: false, enable_perks: false)
  end

  def create_spanish_developer
    create_countries
    FactoryGirl.create(:developer,
                       company_name: spanish_developer_name,
                       house_search: true,
                       country_id: spain.id)
  end

  def create_division(branded: false)
    return division if division
    dname = branded ? branded_division_name : division_name
    FactoryGirl.create(:division, division_name: dname, developer: developer(branded: branded))
  end

  def create_spanish_division
    return spanish_division if spanish_division
    FactoryGirl.create(:division, division_name: spanish_division_name, developer: spanish_developer)
  end

  def create_development(cas: false, name: development_name, dev: developer, branded: false)
    return development if development
    dev = branded ? developer(branded: branded) : dev
    dname = branded ? branded_development_name : development_name
    FactoryGirl.create(:development, name: name, developer: dev, cas: cas)
  end

  def create_spanish_development
    return spanish_development if spanish_development
    FactoryGirl.create(:development, name: spanish_development_name, developer: spanish_developer)
  end

  def create_division_development(cas: false, branded: false)
    return division_development if division_development
    dname = branded ? branded_division_development_name : division_development_name
    FactoryGirl.create(:division_development, name: dname, division: division(branded: branded), enable_snagging: true, snag_duration: "7", cas: cas)
  end

  def create_spanish_division_development
    return spanish_division_development if spanish_division_development
    FactoryGirl.create(:division_development, name: spanish_division_development_name, division: spanish_division)
  end

  def create_unit_type(name=unit_type_name, dev: development, link: nil)
    FactoryGirl.create(:unit_type, name: name, development: dev, external_link: link)
  end

  def create_spanish_unit_type
    FactoryGirl.create(:unit_type, name: unit_type_name, development: spanish_development)
  end

  def create_division_development_unit_type(name=unit_type_name, restricted:false, branded: false)
    FactoryGirl.create(:unit_type, name: name, development: division_development(branded: branded), restricted: restricted)
  end

  def create_spanish_division_development_unit_type
    FactoryGirl.create(:unit_type, name: unit_type_name, development: spanish_division_development)
  end

  def create_room(name=room_name, ut=unit_type)
    last_user = cf_admin || create_cf_admin
    FactoryGirl.create(:room, name: name, unit_type: ut)
  end

  def unit_type_rooms
    [ bedroom_name, bathroom_name, lounge_name, kitchen_name ]
  end

  # create rooms for an eisting unit type
  def create_unit_type_rooms(ut_name=unit_type_name)
    ut = UnitType.find_by(name: ut_name)
    rooms = []
    unit_type_rooms.each do |roomname|
      rooms << FactoryGirl.create(:room, name: roomname, unit_type: ut)
    end
    rooms
  end

  def appliance_category(developer=nil, name=appliance_category_name)
    ApplianceCategory.find_or_create_by(name: name, developer: developer)
  end

  def developer_appliance_category
    ApplianceCategory.find_or_create_by(name: developer_appliance_category_name, developer: developer)
  end

  def create_finish_manufacturer(developer=nil)
    FactoryGirl.create(:finish_manufacturer,
                       name: finish_manufacturer_name,
                       finish_types: [create_finish_type],
                       developer: developer)
  end

  def create_appliance_manufacturer(developer=nil, name=appliance_manufacturer_name)
    return ApplianceManufacturer.find_by(name: name, developer: developer) ||
    FactoryGirl.create(:appliance_manufacturer,
                       name: name,
                       link: manufacturer_link,
                       developer: developer)
  end

  def create_countries
    return unless Country.none?

    FactoryGirl.create(:country, name: "UK", time_zone: "London")
    FactoryGirl.create(:country, name: "Spain", time_zone: "Paris")
  end

  def create_appliance(developer=nil, model_num=appliance_name)
    create_appliance_manufacturer
    FactoryGirl.create(:appliance,
                       appliance_category: appliance_category,
                       appliance_manufacturer: appliance_manufacturer,
                       e_rating: energy_rating,
                       model_num: model_num,
                       developer: developer)
  end

  def create_appliances
    create_appliance_manufacturer
    APPLIANCERESOURCES.each do |category|
      appcategory = ApplianceCategory.find_or_create_by(name: category)
      (1..4).each do |model|
        FactoryGirl.create(:appliance,
                       appliance_category: appcategory,
                       appliance_manufacturer: appliance_manufacturer,
                       e_rating: energy_rating,
                       model_num: "#{category}#{model}")
      end
    end
  end

  def create_finishes
    FINISHRESOURCES.each do |finish|
      finish_category = FinishCategory.find_or_create_by(name: finish[0])
      finish_type = FactoryGirl.create(:finish_type,
                                       name: finish[1],
                                       finish_categories: [finish_category])
      manufacturer = FactoryGirl.create(:finish_manufacturer,
                                        name: finish[2],
                                        finish_types: [finish_type])
      finish[3].each do |fname|
        FactoryGirl.create(:finish, name: fname,
                            finish_category: finish_category,
                            finish_type: finish_type,
                            finish_manufacturer: manufacturer)
      end
    end
  end

  def create_notification
    notification = FactoryGirl.create(:notification, subject: notification_name, send_to_type: "Phase", send_to_id: phase.id)
    FactoryGirl.create(:resident_notification, resident_id: resident.id, notification_id: notification.id)
  end

  def create_appliance_without_manual(developer=nil)
    FactoryGirl.create(
      :appliance,
      name: appliance_without_manual_name,
      appliance_category: appliance_category,
      appliance_manufacturer: appliance_manufacturer,
      rooms: [room],
      manual: nil,
      guide: nil,
      developer: developer
    )
  end

  def create_appliance_room
    FactoryGirl.create(:appliance_room, room: room, appliance: appliance)
  end

  def create_finish_category(developer=nil)
    FinishCategory.find_or_create_by(name: finish_category_name, developer: developer)
  end

  def create_finish_type(developer=nil)
    finish_category = create_finish_category(developer)
    finish_type = FinishType.find_by(name: finish_type_name, developer: developer)
    if finish_type.blank?
      FactoryGirl.create(:finish_type,
                         name: finish_type_name,
                         finish_categories: [finish_category],
                         developer: developer)
    end
  end

  def create_finish(developer=nil)
    FactoryGirl.create(:finish, name: finish_name,
                       finish_category: create_finish_category(developer),
                       finish_type: create_finish_type(developer),
                       developer: developer)
  end

  def create_finish_room(room = self.room, finish = create_finish)
    FactoryGirl.create(:finish_room, room: room, finish: finish)
  end

  def create_development_phase(name: phase_name, dev: development, business: 0)
    FactoryGirl.create(:phase, name: name, business: business,
                       development: dev, address: create_address)
  end

  def create_spanish_development_phase
    FactoryGirl.create(:phase, name: spanish_phase_name, development: spanish_development, address: create_spanish_address)
  end

  def create_division_development_phase(branded: false)
    FactoryGirl.create(:phase, name: division_phase_name, development: division_development(branded: branded))
  end

  def create_spanish_division_development_phase
    FactoryGirl.create(:phase, name: spanish_division_phase_name, development:spanish_division_development)
  end

  def create_phases
    create_development_phase
    create_division_development_phase
  end

  def create_spanish_phases
    create_spanish_development_phase
    create_spanish_division_development_phase
  end
  def create_development_plot_depreciated
    FactoryGirl.create(:plot, development: development, unit_type: unit_type, number: plot_name)
  end

  def create_division_development_plot
    FactoryGirl.create(:plot, development: division_development, number: division_plot_name)
  end

  def create_spanish_division_development_plot
    FactoryGirl.create(:plot, development: spanish_division_development, number: spanish_division_plot_name)
  end

  def create_address
    FactoryGirl.create(:address, building_name: "Quartz Tower", road_name: "Sapphire Road",
                                 locality: "Pearlville", postcode: "HTTP 404")
  end

  def create_spanish_address
    FactoryGirl.create(:address, building_name: "casa", road_name: "barca rd",
                                 locality: "catalonia", postcode: "12211")
  end

  def create_phase_plot(p=phase, number: phase_plot_name)
    FactoryGirl.create(:phase_plot, phase: p, number: number, unit_type: unit_type)
  end

  def create_phase_plots
    (1..10).each do |plot_number|
      FactoryGirl.create(:phase_plot, phase: phase, number: plot_number.to_s, unit_type: unit_type)
    end
  end

  def create_development_choice_config
    FactoryGirl.create(:choice_configuration, name: choice_configuration_name, development: development)
  end

  def create_room_configurations
    unit_type.rooms.each do |room|
      FactoryGirl.create(:room_configuration, name: room.name, choice_configuration: choice_configuration)
    end
  end

  # Create some choices just for the kitchen and bedroom
  def create_room_items

    bedroom = RoomConfiguration.find_by(name: bedroom_name)
    room_item = RoomItem.new(name: FINISHRESOURCES[0][0], room_configuration_id: bedroom.id)
    room_item.save
    FINISHRESOURCES[0][3].each do |f|
      finish = Finish.find_by(name: f)
      Choice.new(choiceable_type: Finish.to_s, choiceable_id: finish.id, room_item_id: room_item.id).save
    end

    kitchen = RoomConfiguration.find_by(name: kitchen_name)
    room_item = RoomItem.new(name: FINISHRESOURCES[1][0], room_configuration_id: kitchen.id)
    room_item.save
    FINISHRESOURCES[1][3].each do |f|
      finish = Finish.find_by(name: f)
      Choice.new(choiceable_type: Finish.to_s, choiceable_id: finish.id, room_item_id: room_item.id).save
    end
    room_item = RoomItem.new(name: APPLIANCERESOURCES[0], room_configuration_id: kitchen.id)
    room_item.save
    (1..4).each do |app|
      appliance = Appliance.find_by(model_num: "#{APPLIANCERESOURCES[0]}#{app.to_s}")
      Choice.new(choiceable_type: Appliance.to_s, choiceable_id: appliance.id, room_item_id: room_item.id).save
    end
  end

  def create_many_plots(phase=CreateFixture.phase, development=CreateFixture.development)
    FactoryGirl.create(:unit_type, name: CreateFixture.another_unit_type_name, development: development)
    FactoryGirl.create(:plot, phase: phase, number: 180, road_name: "Bulk Edit Road A", prefix: "Apartment", postcode: "AA 1AB")
    FactoryGirl.create(:plot, phase: phase, number: 181, road_name: "Bulk Edit Road B", prefix: "Flat")
    FactoryGirl.create(:plot, unit_type: CreateFixture.unit_type, phase: phase, number: 182, road_name: "Bulk Edit Road C", prefix: "Flat", house_number: "18A", postcode: "AA 1AB")
  end

  def create_development_with_plots_and_choices
    resident = create_resident_under_a_phase_plot
    create_phase_plots
    create_unit_type_rooms
    create_development_choice_config
    create_room_configurations
    create_appliances
    create_finishes
    create_room_items
    create_development_admin
  end

  def create_development_with_plot_and_choices_no_resident
    create_developer
    create_development
    create_development_phase
    create_unit_type
    create_unit_type_rooms
    create_phase_plot
    create_phase_plots
    create_development_choice_config
    create_room_configurations
    create_appliances
    create_finishes
    create_room_items
    create_development_admin
  end

  def create_spanish_phase_plot
    FactoryGirl.create(:phase_plot, phase: spanish_phase, number: spanish_phase_plot_name, unit_type: unit_type)
  end

  def create_division_phase_plot(plot_name = phase_plot_name, ut = unit_type)
    FactoryGirl.create(:phase_plot, phase: division_phase, number: plot_name, unit_type: ut)
  end

  def create_snag_plot
    FactoryGirl.create(:phase_plot,
                       phase: division_phase,
                       number: snag_plot_number,
                       house_number: snag_house_number,
                       unit_type: unit_type,
                       completion_date: completion_date)
  end

  def create_notification_residents
    # A resident with no plots
    attrs = { first_name: "Resident with no", last_name: "Plots", email: "resident@no.plots.com" }
    FactoryGirl.create(:resident, attrs)

    # An unactivated resident
    attrs = { first_name: "Unactivated", last_name: "Resident", plot: Plot.first, email: "unactivated@resident.com" }
    FactoryGirl.create(:resident, :with_residency, attrs)

    # A resident that will be added to multiple plots in the loop below
    attrs = { first_name: "Multiple plot", last_name: "Resident", email: "multiple_plot@residents.com" }
    multiple_resident = FactoryGirl.create(:resident, :activated, attrs)

    # A new resident for each plot, plus a resident with residency of all plots except the last one
    Plot.all.each do |plot|
      attrs = { first_name: "Resident of", last_name: "plot #{plot}", plot: plot, email: "#{plot.number}@residents.com" }
      FactoryGirl.create(:resident, :with_residency, :activated, attrs)

      unless plot == Plot.last
        FactoryGirl.create(:plot_residency, resident: multiple_resident, plot: plot, role: 'homeowner')
      end
    end
  end

  def create_resident(email = resident_email, plot: phase_plot)
    FactoryGirl.create(:resident, :with_residency, plot: plot, email: email,
                       developer_email_updates: true, invitation_accepted_at: Time.zone.now,
                       ts_and_cs_accepted_at: Time.zone.now)
  end

  def create_division_resident
    division_plot = create_division_development_plot
    FactoryGirl.create(:resident, :with_residency, plot: division_plot, email: resident_email, developer_email_updates: true)
  end

  def create_phase_contact
    FactoryGirl.create(:contact, contactable: phase, category: "management")
  end

  def create_division_contacts
    FactoryGirl.create(:contact, first_name: division_contact_name, contactable: division, category: "customer_care")
    FactoryGirl.create(:contact, contactable: developer, category: "management", email: ContactFixture.second_email, pinned: true)
    FactoryGirl.create(:contact, contactable: division_development, category: "management")
  end

  def create_how_tos
    country = Country.first || FactoryGirl.create(:country)
    FactoryGirl.create(:how_to, :with_tag, category: "diy", title: how_to_name, country_id: country.id)
    FactoryGirl.create(:how_to, :with_tag, country_id: country.id)
    FactoryGirl.create(:how_to, :with_tag, category: "diy", country_id: country.id)
    FactoryGirl.create(:how_to, :with_tag, hide: true, title: "Hidden how to", country_id: country.id)
  end

  def create_contacts
    FactoryGirl.create(:contact, first_name: contact_name, contactable: developer, category: "emergency")
    FactoryGirl.create(:contact, contactable: development, category: "services")
  end

  def create_private_document
    FactoryGirl.create(:private_document, resident: CreateFixture.resident)
  end

  def create_resident_and_phase
    create_development_phase
    create_unit_type
    create_phase_plot
    create_resident
  end

  def create_resident_under_a_phase_plot
    create_developer
    create_development
    create_resident_and_phase
  end

  def create_residents_under_a_phase_plot(emails)
    create_developer
    create_development
    create_resident_and_phase
  end

   def create_residents_and_phase(emails)
    create_development_phase
    create_unit_type
    create_phase_plot
    emails.each { |email| create_resident(email) }
  end

  def create_resident_under_a_phase_plot_with_appliances_and_rooms(developer=nil)
    create_resident_under_a_phase_plot
    create_room
    create_appliance(developer)
    create_appliance_room
    create_appliance_without_manual(developer)
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

  def development_admin
    User.find_by(role: :development_admin)
  end

  def developer(branded: false)
    dname = branded ? branded_developer_name : developer_name
    Developer.find_by(company_name: dname)
  end

  def spanish_developer
    Developer.find_by(company_name: spanish_developer_name)
  end

  def division(branded: false)
    dname = branded ? branded_division_name : division_name
    Division.find_by(division_name: dname)
  end

  def spanish_division
    Division.find_by(division_name: spanish_division_name)
  end

  def development(branded: false)
    dname = branded ? branded_development_name : development_name
    Development.find_by(name: development_name)
  end

  def choice_configuration
    ChoiceConfiguration.find_by(name: choice_configuration_name)
  end

  def spanish_development
    Development.find_by(name: spanish_development_name)
  end

  def division_development(branded: false)
    dname = branded ? branded_division_development_name : division_development_name
    Development.find_by(name: dname)
  end

  def spanish_division_development
    Development.find_by(name: spanish_division_development_name)
  end

  def snag_plot_number
    "321"
  end

  def snag_house_number
    "555"
  end

  def phase
    Phase.find_by(name: phase_name)
  end

  def spanish_phase
    Phase.find_by(name: spanish_phase_name)
  end

  def room_configurations(choice_configuration)
    RoomConfiguration.where(choice_configuration_id: choice_configuration.id)
  end

  def division_phase
    Phase.find_by(name: division_phase_name)
  end

  def unit_type(ut_name=unit_type_name)
    UnitType.find_by(name: ut_name)
  end

  def room(name = room_name, ut = unit_type)
    Room.find_by(name: name, unit_type_id: ut.id)
  end

  def finish(fname = finish_name, dev_id=nil)
    Finish.find_by(name: fname, developer_id: dev_id)
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

  def phase_plots
    phase.plots.order(:id)
  end

  def division_plot
    division_development.plots.first
  end

  def phase_plot
    plot = phase&.plots&.first
    plot = division_phase&.plots&.first if plot.nil?

    plot
  end

  def plot(plot_number)
    Plot.find_by(number: plot_number)
  end

  def resident
    Resident.find_by(email: resident_email)
  end

  def appliance_manufacturer
    ApplianceManufacturer.find_by(name: appliance_manufacturer_name)
  end

  def completion_date
    (Time.zone.now - 12.days).to_date
  end

  def add_finish_to_room(room_name, finish_name)
    create_finish_room(room(room_name), finish(finish_name))
  end

  def uk
    Country.find_by(name: "UK")
  end

  def spain
    Country.find_by(name: "Spain")
  end

end
# rubocop:enable ModuleLength
