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

Given(/^there is a unit type$/) do
  CreateFixture.create_developer_with_development
  CreateFixture.create_unit_type
end

Given(/^there is a plot$/) do
  CreateFixture.create_developer_with_development
  CreateFixture.create_development_plot
end

Given(/^there is a phase plot$/) do
  CreateFixture.create_developer_with_development
  CreateFixture.create_development_phase
  CreateFixture.create_phase_plot
end

Given(/^I have seeded the database$/) do
  load "#{Rails.root}/db/seeds.rb"
end
