# frozen_string_literal: true

Given(/^there is a developer$/) do
  CreateFixture.create_developer
end

When(/^I create a development for the developer$/) do
  visit "/"

  within ".navbar" do
    click_on t("components.navigation.developers")
  end

  within "[data-developer='#{CreateFixture.developer_id}']" do
    click_on t("developers.index.developments")
  end

  click_on t("developments.index.add")

  fill_in "development_name", with: CreateFixture.development_name
  click_on t("developments.form.submit")
end

Then(/^I should see the created developer development$/) do
  expect(page).to have_content(CreateFixture.development_name)
end

When(/^I update the developers development$/) do
  find("[data-action='edit']").click

  fill_in "development_name", with: DeveloperDevelopmentFixture.updated_development_name

  DeveloperDevelopmentFixture.update_attrs.each do |attr, value|
    fill_in "development_#{attr}", with: value
  end

  DeveloperDevelopmentFixture.development_address_update_attrs.each do |attr, value|
    fill_in "development_address_attributes_#{attr}", with: value
  end

  click_on t("developments.form.submit")
end

Then(/^I should see the updated developer development$/) do
  success_flash = t(
    "developers.developments.update.success",
    development_name: DeveloperDevelopmentFixture.updated_development_name
  )
  expect(page).to have_content(success_flash)

  DeveloperDevelopmentFixture.development_address_update_attrs.each do |_attr, value|
    expect(page).to have_content(value)
  end
end

When(/^I create another development$/) do
  visit "/developers"
  click_on CreateFixture.developer_name
  click_on t("developers.collection.developments")
  click_on t("developments.collection.add")

  fill_in "development_name", with: DeveloperDevelopmentFixture.second_development_name

  click_on t("developments.form.submit")
end

Then(/^I should see the developments list$/) do
  within ".record-list" do
    expect(page).to have_content DeveloperDevelopmentFixture.updated_development_name
    expect(page).to have_content DeveloperDevelopmentFixture.second_development_name
  end
end

When(/^I delete the developers development$/) do
  delete_and_confirm!(finder_options: { match: :first })
end

Then(/^I should see that the deletion was successful for the developer development$/) do
  success_flash = t(
    "developers.developments.destroy.success",
    development_name: DeveloperDevelopmentFixture.updated_development_name
  )

  expect(page).to have_content(success_flash)

  within ".breadcrumbs" do
    expect(page).to have_content(CreateFixture.developer_name)
  end

  # One should be deleted, but the other should be present
  within ".record-list" do
    expect(page).not_to have_content DeveloperDevelopmentFixture.updated_development_name
    expect(page).to have_content DeveloperDevelopmentFixture.second_development_name
  end
end

Given(/^there is a developer with a development$/) do
  CreateFixture.create_developer_with_development
end

Given(/^there is Spanish developer$/) do
  CreateFixture.create_spanish_developer
end

When(/^I create a development for the spanish developer$/) do
  visit "/"

  within ".navbar" do
    click_on t("components.navigation.developers")
  end

  within "[data-developer='#{CreateFixture.spanish_developer_id}']" do
    click_on t("developers.index.developments")
  end

  click_on t("developments.index.add")

  fill_in "development_name", with: CreateFixture.spanish_development_name

end

Then(/^I see a Spanish format address$/) do

  ignore = Capybara.ignore_hidden_elements
  Capybara.ignore_hidden_elements = false
  
  expect(page).not_to have_selector('#developer_address_attributes_postal_number')
  expect(page).not_to have_selector('#developer_address_attributes_road_name')
  expect(page).not_to have_selector('#developer_address_attributes_building_name')
  find_field(:development_address_attributes_locality).should be_visible
  find_field(:development_address_attributes_city).should be_visible
  expect(page).not_to have_selector('#developer_address_attributes_county')
  find_field(:development_address_attributes_postcode).should be_visible

  Capybara.ignore_hidden_elements = ignore
end
