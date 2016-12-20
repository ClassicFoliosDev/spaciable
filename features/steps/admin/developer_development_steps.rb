# frozen_string_literal: true
Given(/^there is a developer$/) do
  DeveloperDevelopmentFixture.create_developer
end

When(/^I create a development for the developer$/) do
  visit "/"

  within ".navbar" do
    click_on t("components.navigation.developers")
  end

  within "[data-developer='#{DeveloperDevelopmentFixture.developer_id}']" do
    click_on t(".developers.index.developments")
  end

  click_on t("developments.index.add")

  fill_in "development_name", with: DeveloperDevelopmentFixture.development_name
  click_on t("developments.form.submit")
end

Then(/^I should see the created developer development$/) do
  expect(page).to have_content(DeveloperDevelopmentFixture.developer_name)
end

When(/^I update the developers development$/) do
  find("[data-action='edit']").click

  fill_in "development_name", with: DeveloperDevelopmentFixture.updated_development_name

  DeveloperDevelopmentFixture.update_attrs.each do |attr, value|
    fill_in "development_#{attr}", with: value
  end

  DeveloperDevelopmentFixture.address_update_attrs.each do |attr, value|
    fill_in "development_address_attributes_#{attr}", with: value
  end

  click_on t("developers.form.submit")
end

Then(/^I should see the updated developer development$/) do
  # On the index page
  within ".record-list" do
    expect(page).to have_content(DeveloperDevelopmentFixture.updated_development_name)
  end

  # and on the edit page
  click_on DeveloperDevelopmentFixture.updated_development_name

  DeveloperDevelopmentFixture.update_attrs.each do |attr, value|
    screen_value = find("[name='development[#{attr}]']").value
    expect(screen_value).to eq(value)
  end

  DeveloperDevelopmentFixture.address_update_attrs.each do |attr, value|
    screen_value = find_by_id("development_address_attributes_#{attr}").value
    expect(screen_value).to eq(value)
  end
end

When(/^I delete the developers development$/) do
  click_on t("developments.edit.back")

  delete_and_confirm!
end

Then(/^I should see that the deletion was successful for the developer development$/) do
  success_flash = t(
    "developers.developments.destroy.archive.success",
    development_name: DeveloperDevelopmentFixture.updated_development_name
  )
  expect(page).to have_content(success_flash)

  within ".breadcrumbs" do
    expect(page).to have_content(DeveloperDevelopmentFixture.developer_name)
  end

  within ".record-list" do
    expect(page).to have_no_content DeveloperDevelopmentFixture.updated_development_name
  end
end
