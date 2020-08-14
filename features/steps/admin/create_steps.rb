# frozen_string_literal: true

Given(/^there is a division with a development$/) do
  CreateFixture.create_developer
  CreateFixture.create_division
  CreateFixture.create_division_development
end

Given(/^there is a phase$/) do
  CreateFixture.create_developer_with_development
  CreateFixture.create_development_phase
end

Given(/^there is a division phase$/) do
  CreateFixture.create_developer_with_division
  CreateFixture.create_division_development
  CreateFixture.create_division_development_phase
end

Given(/^there is a development$/) do
  CreateFixture.create_development
end

Given(/^there is a division development$/) do
  CreateFixture.create_division_development
end

Given(/^there is a (.*)unit type$/) do |role|
  role.downcase.include?("division") ? CreateFixture.create_division_development_unit_type :  CreateFixture.create_unit_type
end

Given(/^there is a plot$/) do
  CreateFixture.create_unit_type unless CreateFixture.unit_type
  CreateFixture.create_development_plot_depreciated
end

Given(/^there is a plot for the division development$/) do
  CreateFixture.create_division_development_unit_type
  CreateFixture.create_division_development_plot
end

Given(/^there is a phase plot for the division development$/) do
  CreateFixture.create_division_development_unit_type
  CreateFixture.create_division_development_phase
  CreateFixture.create_phase_plot
end

Given(/^there is a division$/) do
  CreateFixture.create_division
end

Given(/^there is a division plot$/) do
  CreateFixture.create_developer
  CreateFixture.create_division
  CreateFixture.create_division_development
  CreateFixture.create_division_development_unit_type
  CreateFixture.create_division_development_plot
end

Given(/^there is a phase plot$/) do
  CreateFixture.create_developer_with_development unless CreateFixture.development
  CreateFixture.create_development_phase
  CreateFixture.create_unit_type
  CreateFixture.create_phase_plot
end

Given(/^there are phase plots$/) do
  CreateFixture.create_developer_with_development unless CreateFixture.development
  CreateFixture.create_development_phase
  CreateFixture.create_unit_type
  CreateFixture.create_phase_plots
end

Given(/^there are admin lettable phase plots$/) do
  CreateFixture.create_developer_with_development unless CreateFixture.development
  CreateFixture.create_development_phase
  CreateFixture.create_unit_type
  CreateFixture.create_phase_plots
  LettingsFixture.create_plot_listings
end

Given(/^there are homeowner lettable phase plots$/) do
  CreateFixture.create_developer_with_development unless CreateFixture.development
  CreateFixture.create_development_phase
  CreateFixture.create_unit_type
  CreateFixture.create_phase_plots
  LettingsFixture.create_plot_listings(Listing::owners.key(Listing::owners[:homeowner]))
end

Given(/^there is a division phase plot$/) do
  CreateFixture.create_division_development_phase
  CreateFixture.create_unit_type
  CreateFixture.create_division_phase_plot
end

Given(/^there are contacts$/) do
  CreateFixture.create_contacts
end

Given(/^there are division contacts$/) do
  CreateFixture.create_division_contacts
end

Given(/^there is a phase contact$/) do
  CreateFixture.create_phase_contact
end

Given(/^there are faqs$/) do
  CreateFixture.create_faq
end

Given(/^there are notifications$/) do
  CreateFixture.create_notification
end

Given(/^there are how\-tos$/) do
  CreateFixture.create_how_tos
end

Given(/^there is a room$/) do
  CreateFixture.create_room
end

Given(/^there is a ([^ ]*) appliance for developer ([^ ]*)$/) do |model_num, developer|
  CreateFixture.create_appliance(eval(developer), eval(model_num))
end

Given(/^there is an appliance$/) do
  CreateFixture.create_appliance
end

Given(/^there is an appliance category$/) do
  CreateFixture.appliance_category
end

Given(/^there is a ([^ ]*) appliance category for developer ([^ ]*)$/) do |name, developer|
  CreateFixture.appliance_category(eval(developer), eval(name))
end

Given(/^there is a developer appliance category$/) do
  CreateFixture.developer_appliance_category
end

Given(/^there is an appliance with manual$/) do
  CreateFixture.create_appliance
  CreateFixture.create_appliance_room
  ApplianceFixture.update_appliance_manual
end

Given(/^there is a finish$/) do
  CreateFixture.create_finish
end

Given(/^there is a (.*) finish$/) do |role|
  CreateFixture.create_finish(CreateFixture.developer)
end

Given(/^there is a finish for developer (.*)$/) do |developer|
  CreateFixture.create_finish(developer.empty? ? nil : eval(developer))
end

Given(/^there is a finish category$/) do
  CreateFixture.create_finish_category
end

Given(/^there is a (.*) finish category$/) do |role|
  CreateFixture.create_finish_category(CreateFixture.developer)
end

Given(/^there is a finish type$/) do
  CreateFixture.create_finish_type
end

Given(/^there is a (.*) finish type$/) do |role|
  CreateFixture.create_finish_type(CreateFixture.developer)
end

Given(/^there is an appliance with a guide$/) do
  ApplianceFixture.update_appliance_guide
end

Given(/^I have seeded the database$/) do
  CreateFixture.create_countries
  load Rails.root.join("db", "seeds.rb")
end

Given(/^I have seeded the database as a developer$/) do
  CreateFixture.create_countries
  load Rails.root.join("db", "seeds.rb")
  # Update relevant tables with developer id
  FinishCategory.update_all developer_id: CreateFixture.developer.id
  FinishType.update_all developer_id: CreateFixture.developer.id
  FinishManufacturer.update_all developer_id: CreateFixture.developer.id
end

Given(/^I have seeded the database with appliances$/) do
  load Rails.root.join("db", "seeds", "manufacturers_and_appliance_seeds.rb")
end

Given(/^I have seeded the database with finishes$/) do
  load Rails.root.join("db", "seeds", "finishes_seeds.rb")
end

Given(/^I am a Developer Admin$/) do
  CreateFixture.create_developer
  developer_admin = CreateFixture.create_developer_admin
  login_as developer_admin
end

Given(/^I am a Division Admin$/) do
  CreateFixture.create_developer
  CreateFixture.create_division
  division_admin = CreateFixture.create_division_admin

  login_as division_admin
end

Given(/^I am a Development Admin$/) do
  CreateFixture.create_developer
  CreateFixture.create_development
  development_admin = CreateFixture.create_development_admin

  login_as development_admin
end

Given(/^there is an appliance manufacturer$/) do
  CreateFixture.create_appliance_manufacturer
end

Given(/^there is a ([^ ]*) appliance manufacturer for developer ([^ ]*)$/) do |manufacturer, developer|
  CreateFixture.create_appliance_manufacturer(eval(developer), eval(manufacturer))
end

Given(/^there is a developer appliance manufacturer$/) do
  CreateFixture.create_appliance_manufacturer(CreateFixture.developer)
end

Given(/^there is a finish manufacturer$/) do
  CreateFixture.create_finish_manufacturer
end

Given(/^there are private plot documents$/) do
  CreateFixture.create_resident
  CreateFixture.create_private_document
  CreateFixture.create_private_document
end

Given(/^there is a phase plot with a resident$/) do
  CreateFixture.create_resident_under_a_phase_plot
end

Given(/^there is a phase plot with residents$/) do
  CreateFixture.create_residents_under_a_phase_plot([CreateFixture.resident_email,
                                                     CreateFixture.tenant_email])
end

Given(/^there is a phase plot resident$/) do
  CreateFixture.create_resident_and_phase
end

Given(/^there is a division resident$/) do
  CreateFixture.create_division_resident
end

Given(/^There is a plot with many residents$/) do
  resident = Resident.find_by(email: HomeownerUserFixture.email)
  # Should be safe, we only created one plot
  plot = resident.plots.first

  FactoryGirl.create(:resident, :with_residency, plot: plot, email: "test1@example.com")
  FactoryGirl.create(:resident, :with_residency, plot: plot, email: "test2@example.com")
  FactoryGirl.create(:resident, :with_residency, plot: plot, email: "test3@example.com")

  other_plot = FactoryGirl.create(:plot, development: plot.development, number: PlotFixture.another_plot_number)
  FactoryGirl.create(:plot_residency, plot_id: other_plot.id, resident_id: resident.id)
end

Given(/^there is another unit type$/) do
  unit_type = CreateFixture.create_unit_type(CreateFixture.second_unit_type_name)
  CreateFixture.create_room(CreateFixture.lounge_name, unit_type)
end

Given(/^all the plots are release completed$/) do
  Plot.update_all completion_release_date: Date.yesterday
end

Given(/^the unit types are restricted$/) do
  UnitType.update_all restricted: true
end

Given(/^the phase plot is release completed$/) do
  Plot.find_by(number: CreateFixture.phase_plot_name).update_attribute :completion_release_date, Date.yesterday
end
