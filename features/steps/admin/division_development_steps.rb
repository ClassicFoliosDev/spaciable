# frozen_string_literal: true
Given(/^there is a developer with a division$/) do
  CreateFixture.create_developer_with_division
end

When(/^I create a development for the division$/) do
  visit "/"

  within ".navbar" do
    click_on t("components.navigation.developers")
  end

  click_on t("developers.collection.divisions")

  # Sleep to make sure we link to developments from the right place
  sleep(0.2)

  click_on t("divisions.collection.developments")

  click_on t("developments.index.add")

  fill_in "development_name", with: CreateFixture.development_name
  click_on t("developments.form.submit")
end

Then(/^I should see the created division development$/) do
  expect(page).to have_content(CreateFixture.development_name)
end

When(/^I update the divisions development$/) do
  find("[data-action='edit']").click

  fill_in "development_name", with: DivisionDevelopmentFixture.updated_development_name

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
