# frozen_string_literal: true
Given(/^I have a developer with a development$/) do
  PhaseFixture.create_developer_with_development
end

When(/^I create a phase for the development$/) do
  visit "/"

  within ".navbar" do
    click_on t("components.navigation.developers")
  end

  within "[data-developer='#{PhaseFixture.developer_id}']" do
    click_on t(".developers.index.developments")
  end

  within "[data-development='#{PhaseFixture.development_id}']" do
    click_on t(".developments.developments.phases")
  end

  click_on t("phases.index.add")

  fill_in "phase_name", with: PhaseFixture.phase_name
  click_on t("phases.form.submit")
end

Then(/^I should see the created phase$/) do
  expect(page).to have_content(PhaseFixture.developer_name)

  click_on PhaseFixture.phase_name

  PhaseFixture.development_address_attrs.each do |attr, value|
    screen_value = find_by_id("phase_address_attributes_#{attr}").value
    expect(screen_value).to eq(value)
  end

  click_on t("phases.edit.back")
end

When(/^I update the phase$/) do
  find("[data-action='edit']").click

  sleep 0.3 # these fields do not get filled in without the sleep :(
  fill_in "phase[number]", with: PhaseFixture.updated_phase_number
  fill_in "phase[name]", with: PhaseFixture.updated_phase_name

  PhaseFixture.address_update_attrs.each do |attr, value|
    fill_in "phase_address_attributes_#{attr}", with: value
  end

  click_on t("phases.form.submit")
end

Then(/^I should see the updated phase$/) do
  # On the index page
  within ".record-list" do
    expect(page).to have_content(PhaseFixture.updated_phase_name)
  end

  # and on the edit page
  click_on PhaseFixture.updated_phase_name

  PhaseFixture.update_attrs.each do |attr, value|
    screen_value = find("[name='phase[#{attr}]']").value
    expect(screen_value).to eq(value)
  end

  PhaseFixture.address_update_attrs.each do |attr, value|
    screen_value = find_by_id("phase_address_attributes_#{attr}").value
    expect(screen_value).to eq(value)
  end
end

When(/^I delete the phase$/) do
  click_on t("phases.edit.back")

  delete_and_confirm!
end

Then(/^I should see that the deletion completed successfully$/) do
  success_flash = t(
    "phases.destroy.archive.success",
    phase_name: PhaseFixture.updated_phase_name
  )
  expect(page).to have_content(success_flash)

  within ".breadcrumbs" do
    expect(page).to have_content(PhaseFixture.development_name)
  end

  within ".record-list" do
    expect(page).to have_no_content PhaseFixture.updated_phase_name
  end
end
