# frozen_string_literal: true
Given(/^there is a developer with a division$/) do
  DivisionDevelopmentFixture.create_developer_with_division
end

When(/^I create a development for the division$/) do
  visit "/"

  within ".navbar" do
    click_on t("components.navigation.developers")
  end

  within "[data-developer='#{DivisionDevelopmentFixture.developer_id}']" do
    click_on t(".developers.index.divisions")
  end

  within "[data-division='#{DivisionDevelopmentFixture.division_id}']" do
    click_on t(".divisions.index.developments")
  end

  click_on t(".developments.index.add")

  fill_in "development_name", with: DivisionDevelopmentFixture.development_name
  click_on t("developments.form.submit")
end

Then(/^I should see the created division development$/) do
  expect(page).to have_content(DivisionDevelopmentFixture.development_name)
end

When(/^I update the divisions development$/) do
  find("[data-action='edit']").click

  fill_in "development_name", with: DivisionDevelopmentFixture.updated_development_name

  DivisionDevelopmentFixture.update_attrs.each do |attr, value|
    fill_in "development_#{attr}", with: value
  end

  DivisionDevelopmentFixture.address_update_attrs.each do |attr, value|
    fill_in "development_address_attributes_#{attr}", with: value
  end

  click_on t("developments.form.submit")
end

Then(/^I should see the updated divisions development$/) do
  # On the index page
  within ".record-list" do
    expect(page).to have_content(DivisionDevelopmentFixture.updated_development_name)
  end

  # and on the edit page
  click_on DivisionDevelopmentFixture.updated_development_name

  DivisionDevelopmentFixture.update_attrs.each do |attr, value|
    screen_value = find("[name='development[#{attr}]']").value
    expect(screen_value).to eq(value)
  end

  DivisionDevelopmentFixture.address_update_attrs.each do |attr, value|
    screen_value = find_by_id("development_address_attributes_#{attr}").value
    expect(screen_value).to eq(value)
  end
end
When(/^I view the division development phases$/) do
  click_on t("developments.edit.back")
  click_on t("developments.developments.phases")
end

Then(/^I should be able to return to the division development$/) do
  crumb = t(
    "breadcrumbs.development_edit",
    development_name: DivisionDevelopmentFixture.updated_development_name
  )
  click_on crumb
end

When(/^I delete the divisions development$/) do
  click_on t("developments.edit.back")
  delete_and_confirm!
end

Then(/^I should see that the deletion was successful for the divisions development$/) do
  success_flash = t(
    "divisions.developments.destroy.archive.success",
    development_name: DivisionDevelopmentFixture.updated_development_name
  )
  expect(page).to have_content(success_flash)

  within ".breadcrumbs" do
    expect(page).to have_content(DivisionDevelopmentFixture.developer_name)
    expect(page).to have_content(DivisionDevelopmentFixture.division_name)
  end

  within ".record-list" do
    expect(page).to have_no_content DivisionDevelopmentFixture.updated_development_name
  end
end
