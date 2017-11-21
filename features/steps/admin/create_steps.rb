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

Given(/^there is a unit type$/) do
  CreateFixture.create_unit_type
end

Given(/^there is a plot$/) do
  CreateFixture.create_unit_type
  CreateFixture.create_development_plot
end

Given(/^there is a plot for the division development$/) do
  CreateFixture.create_division_development_unit_type
  CreateFixture.create_division_development_plot
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
  CreateFixture.create_developer_with_development
  CreateFixture.create_development_phase
  CreateFixture.create_unit_type
  CreateFixture.create_phase_plot
end

Given(/^there are contacts$/) do
  CreateFixture.create_contacts
end

Given(/^there are division contacts$/) do
  CreateFixture.create_division_contacts
end

Given(/^there is a document$/) do
  CreateFixture.create_document
end

Given(/^there is a document for the development$/) do
  CreateFixture.create_development_document
end

Given(/^there is a document for the division$/) do
  CreateFixture.create_division_document
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

Given(/^there is an appliance$/) do
  CreateFixture.create_appliance
end

Given(/^there is an appliance category$/) do
  CreateFixture.appliance_category
end

Given(/^there is an appliance with manual$/) do
  CreateFixture.create_appliance
  CreateFixture.create_appliance_room
  ApplianceFixture.update_appliance_manual
end

Given(/^there is a finish$/) do
  CreateFixture.create_finish
end

Given(/^there is a finish category$/) do
  CreateFixture.create_finish_category
end

Given(/^there is a finish type$/) do
  CreateFixture.create_finish_type
end

Given(/^there is an appliance with a guide$/) do
  ApplianceFixture.update_appliance_guide
end

Given(/^I have seeded the database$/) do
  load Rails.root.join("db", "seeds.rb")
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
  development_admin = CreateFixture.create_developer_admin

  login_as development_admin
end

Given(/^there is an appliance manufacturer$/) do
  CreateFixture.create_appliance_manufacturer
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

Given(/^there is a phase plot resident$/) do
  CreateFixture.create_resident_and_phase
end

Given(/^there is a division resident$/) do
  CreateFixture.create_division_resident
end
