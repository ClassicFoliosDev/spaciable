# frozen_string_literal: true

Given(/^there is a developer with a division$/) do
  CreateFixture.create_developer_with_division
end

When(/^I create a development for the division$/) do
  division = CreateFixture.division
  visit "/developers/#{division.developer.id}/divisions/#{division.id}"

  within ".division" do
    click_on t("developments.index.add")
  end

  within ".new_development" do
    fill_in "development_name", with: CreateFixture.development_name
    click_on t("developments.form.submit")
  end
end

Then(/^I should see the created division development$/) do
  expect(page).to have_content(CreateFixture.development_name)
end

When(/^I update the divisions development$/) do
  find("[data-action='edit']").click

  fill_in "development_name", with: DivisionDevelopmentFixture.updated_development_name

  check "development_enable_snagging"

  DivisionDevelopmentFixture.update_snagging.each do |attr, value|
    fill_in "development_#{attr}", with: value
  end

  DivisionDevelopmentFixture.update_attrs.each do |attr, value|
    fill_in "development_#{attr}", with: value
  end

  DivisionDevelopmentFixture.development_address_update_attrs.each do |attr, value|
    fill_in "development_address_attributes_#{attr}", with: value
  end

  click_on t("developments.form.submit")
end

Then(/^I should see the updated divisions development$/) do
  success_flash = t(
    "divisions.developments.update.success",
    development_name: DivisionDevelopmentFixture.updated_development_name
  )
  expect(page).to have_content(success_flash)

  # On the show page
  DivisionDevelopmentFixture.update_attrs.each do |_attr, value|
    expect(page).to have_content(value)
  end

  DivisionDevelopmentFixture.development_address_update_attrs.each do |_attr, value|
    expect(page).to have_content(value)
  end

  expect(page).to have_content("Snagging Enabled: true")
end

And(/^I should be able to return to the division$/) do
  click_on CreateFixture.division_name
end

When(/^I create a second division development$/) do
  click_on t("developments.collection.add")

  fill_in "development_name", with: DeveloperDevelopmentFixture.second_development_name

  click_on t("developments.form.submit")
end

Then(/^I should see the division developments list$/) do
  within ".record-list" do
    expect(page).to have_content DeveloperDevelopmentFixture.updated_development_name
    expect(page).to have_content DeveloperDevelopmentFixture.second_development_name
  end
end

When(/^I delete the divisions development$/) do
  delete_and_confirm!(finder_options: { match: :first })
end

Then(/^I should see that the deletion was successful for the divisions development$/) do
  success_flash = t(
    "divisions.developments.destroy.success",
    development_name: DivisionDevelopmentFixture.updated_development_name
  )
  expect(page).to have_content(success_flash)

  within ".breadcrumbs" do
    expect(page).to have_content CreateFixture.developer_name
    expect(page).to have_content CreateFixture.division_name
  end

  within ".record-list" do
    expect(page).not_to have_content DivisionDevelopmentFixture.updated_development_name
  end
end

Given(/^there is a Spanish developer with a division$/) do
  CreateFixture.create_spanish_developer_with_division
end

Then(/^I see a Spanish format divison address$/) do

  ignore = Capybara.ignore_hidden_elements
  Capybara.ignore_hidden_elements = false
  
  expect(page).not_to have_selector('#division__address_attributes_postal_number')
  expect(page).not_to have_selector('#division__address_attributes_road_name')
  expect(page).not_to have_selector('#division__address_attributes_building_name')
  find_field(:division_address_attributes_locality).should be_visible
  find_field(:division_address_attributes_city).should be_visible
  expect(page).not_to have_selector('#developer_address_attributes_county')
  find_field(:division_address_attributes_postcode).should be_visible

  Capybara.ignore_hidden_elements = ignore
end
