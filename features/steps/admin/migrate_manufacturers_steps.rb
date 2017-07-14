# frozen_string_literal: true
Given(/^I have seeded the database with old manufacturers$/) do
  load Rails.root.join("db", "seeds", "old_seeds.rb")
end

Given(/^I have created appliances and finishes with old manufacturers$/) do
  MigrateManufacturersFixture.setup
end

Given(/^there are duplicate finish categories types relationships$/) do
  FinishCategoriesType.create(finish_category_id: 1, finish_type_id: 1)
  FinishCategoriesType.create(finish_category_id: 1, finish_type_id: 1)
end

When(/^I migrate the old manufacturers$/) do
  require "rake"
  rake = Rake::Application.new
  Rake.application = rake
  Rake::Task.define_task(:environment)
  load "#{Rails.root}/lib/tasks/migrate_manufacturers.rake"
  rake["manufacturers:migrate"].invoke
end

Then(/^I should find new appliance manufacturers$/) do
  appliance_manufacturers = ApplianceManufacturer.all.pluck(:name)

  expect(appliance_manufacturers.length).to eq(7)
  expect(appliance_manufacturers).to include("ATAG")
  expect(appliance_manufacturers).to include("AEG")
  expect(appliance_manufacturers).to include("Baumatic")
  expect(appliance_manufacturers).to include("Beko")
  expect(appliance_manufacturers).to include("Manufacturer for appliance and finish")

  appliance_manufacturer_links = ApplianceManufacturer.all.pluck(:link)

  expect(appliance_manufacturer_links.length).to eq(7)
  expect(appliance_manufacturer_links).to include("http://atagheating.co.uk/warranty-register/")
  expect(appliance_manufacturer_links).to include("http://www.aeg.co.uk/mypages/register-a-product/")
  expect(appliance_manufacturer_links).to include("https://olr.domesticandgeneral.com/app/pages/ApplicationPage.aspx?country=gb&lang=en&brand=BAUM~")
  expect(appliance_manufacturer_links).to include("http://example.com/register")
end

Then(/^I should find new finish manufacturers$/) do
  finish_manufacturers = FinishManufacturer.all.pluck(:name)

  expect(finish_manufacturers.length).to eq(8)
  expect(finish_manufacturers).to include("Crown")
  expect(finish_manufacturers).to include("Dulux")
  expect(finish_manufacturers).to include("Farrow & Ball")
  expect(finish_manufacturers).to include("HR Johnson")
  expect(finish_manufacturers).to include("Porcelanosa")
  expect(finish_manufacturers).to include("Saloni")
  expect(finish_manufacturers).to include("Different manufacturer with same finish type")
  expect(finish_manufacturers).to include("Manufacturer for appliance and finish")
end

Then(/^I should find the old appliance relationships have been updated$/) do
  appliance_manufacturer = ApplianceManufacturer.find_by_name(MigrateManufacturersFixture.appliance_manufacturer_name)
  appliance = Appliance.find_by(model_num: MigrateManufacturersFixture.model_num)

  expect(appliance.appliance_manufacturer_id).to eq(appliance_manufacturer.id)
  expect(appliance.appliance_category_id).to eq(MigrateManufacturersFixture.appliance_category.id)

  second_appliance_manufacturer = ApplianceManufacturer.find_by_name(MigrateManufacturersFixture.appliance_and_finish_manufacturer_name)
  second_appliance = Appliance.find_by_model_num(MigrateManufacturersFixture.second_model_num)

  expect(second_appliance.appliance_manufacturer_id).to eq(second_appliance_manufacturer.id)
  expect(second_appliance.appliance_category_id).to eq(MigrateManufacturersFixture.appliance_category.id)
end

Then(/^I should find the old finish relationships have been updated$/) do
  finish_manufacturer = FinishManufacturer.find_by_name(MigrateManufacturersFixture.finish_manufacturer_name)
  finish = Finish.find_by_name(MigrateManufacturersFixture.finish_name_one)

  expect(finish.finish_manufacturer_id).to eq(finish_manufacturer.id)
  expect(finish.finish_category_id).to eq(MigrateManufacturersFixture.finish_category.id)
  expect(finish.finish_type_id).to eq(MigrateManufacturersFixture.finish_type.id)

  second_finish_manufacturer = FinishManufacturer.find_by_name(MigrateManufacturersFixture.finish_multiple_category_manufacturer_name)
  second_finish = Finish.find_by_name(MigrateManufacturersFixture.finish_name_two)

  expect(second_finish.finish_manufacturer_id).to eq(second_finish_manufacturer.id)
  expect(second_finish.finish_category_id).to eq(MigrateManufacturersFixture.second_finish_category.id)
  expect(second_finish.finish_type_id).to eq(MigrateManufacturersFixture.finish_type.id)

  third_finish_manufacturer = FinishManufacturer.find_by_name(MigrateManufacturersFixture.appliance_and_finish_manufacturer_name)
  third_finish = Finish.find_by_name(MigrateManufacturersFixture.finish_name_three)

  expect(third_finish.finish_manufacturer_id).to eq(third_finish_manufacturer.id)
  expect(third_finish.finish_category_id).to eq(MigrateManufacturersFixture.second_finish_category.id)
  expect(third_finish.finish_type_id).to eq(MigrateManufacturersFixture.second_finish_type.id)

  finish_type_one = MigrateManufacturersFixture.finish_type
  related_manufacturer_names = finish_type_one.finish_manufacturers.pluck(:name)

  expect(related_manufacturer_names.length).to eq(4)
  expect(related_manufacturer_names).to have_content("Crown")
  expect(related_manufacturer_names).to have_content("Dulux")
  expect(related_manufacturer_names).to have_content("Farrow & Ball")
  expect(related_manufacturer_names).to have_content("Different manufacturer with same finish type")

  finish_type_two = MigrateManufacturersFixture.second_finish_type
  related_manufacturer_names = finish_type_two.finish_manufacturers.pluck(:name)

  expect(related_manufacturer_names.length).to eq(4)
  expect(related_manufacturer_names).to have_content("Crown")
  expect(related_manufacturer_names).to have_content("Dulux")
  expect(related_manufacturer_names).to have_content("Farrow & Ball")
  expect(related_manufacturer_names).to have_content("Manufacturer for appliance and finish")
end

Then(/^I should find no extra appliance or finish manufacturers$/) do
  appliance_manufacturers = ApplianceManufacturer.all
  expect(appliance_manufacturers.length).to eq(7)

  finish_manufacturers = FinishManufacturer.all
  expect(finish_manufacturers.length).to eq(8)
end

Then(/^I should find no extra relationships$/) do
  finish_types_manufacturers = FinishTypesManufacturer.all
  expect(finish_types_manufacturers.length).to eq(22)

  finish_categories_types = FinishCategoriesType.all
  expect(finish_categories_types.length).to eq(6)
end
