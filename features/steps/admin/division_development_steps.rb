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
  within find('tr', text: DeveloperDevelopmentFixture.updated_development_name) do
    find(".destroy-permissable").click
  end

  fill_in "password", with: CreateFixture.admin_password
  click_on(t("admin_permissable_destroy.confirm"))
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
