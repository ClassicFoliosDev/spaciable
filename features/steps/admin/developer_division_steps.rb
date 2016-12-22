# frozen_string_literal: true
Given(/^there is a developer with divisions$/) do
  CreateFixture.create_developer
end

When(/^I create a division for the developer$/) do
  visit "/"

  within ".navbar" do
    click_on t("components.navigation.developers")
  end

  within "[data-developer='#{CreateFixture.developer_id}']" do
    click_on t("developers.index.divisions")
  end

  click_on t("divisions.index.add")

  fill_in "division_division_name", with: CreateFixture.division_name
  click_on t("divisions.form.submit")
end

Then(/^I should see the created developer division$/) do
  expect(page).to have_content(CreateFixture.developer_name)
end

When(/^I update the developer's division$/) do
  find("[data-action='edit']").click

  fill_in "division_division_name", with: DeveloperDivisionFixture.updated_division_name

  DeveloperDivisionFixture.update_attrs.each do |attr, value|
    fill_in "division_#{attr}", with: value
  end

  DeveloperDivisionFixture.division_address_attrs.each do |attr, value|
    fill_in "division_address_attributes_#{attr}", with: value
  end

  click_on t("developers.form.submit")
end

Then(/^I should see the updated developer division$/) do
  # On the index page
  within ".record-list" do
    expect(page).to have_content(DeveloperDivisionFixture.updated_division_name)
  end

  # and on the edit page
  click_on DeveloperDivisionFixture.updated_division_name

  DeveloperDivisionFixture.update_attrs.each do |attr, value|
    screen_value = find("[name='division[#{attr}]']").value
    expect(screen_value).to eq(value)
  end

  DeveloperDivisionFixture.division_address_attrs.each do |attr, value|
    screen_value = find_by_id("division_address_attributes_#{attr}").value
    expect(screen_value).to eq(value)
  end
end

When(/^I delete the division$/) do
  visit "/developers/1/divisions"

  delete_and_confirm!
end

Then(/^I should see that the deletion was successful for the division$/) do
  success_flash = t(
    "divisions.archive.success",
    division_name: DeveloperDivisionFixture.updated_division_name
  )
  expect(page).to have_content(success_flash)

  within ".breadcrumbs" do
    expect(page).to have_content(CreateFixture.developer_name)
  end

  within ".record-list" do
    expect(page).to have_no_content DeveloperDivisionFixture.updated_division_name
  end
end
