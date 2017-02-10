# frozen_string_literal: true
Given(/^I have a developer with a development$/) do
  CreateFixture.create_developer_with_development
end

Given(/^I have configured the development address$/) do
  goto_development_show_page

  sleep 0.3
  within ".section-data" do
    find("[data-action='edit']").click
  end

  PhaseFixture.development_address_attrs.each do |attr, value|
    fill_in "development_address_attributes_#{attr}", with: value
  end

  click_on t("developments.form.submit")
end

When(/^I create a phase for the development$/) do
  goto_development_show_page

  within ".tabs" do
    click_on t("developments.collection.phases")
  end

  click_on t("phases.collection.add")

  fill_in "phase_name", with: CreateFixture.phase_name
  click_on t("phases.form.submit")
end

Then(/^I should see the created phase$/) do
  click_on CreateFixture.phase_name

  # Address fields should be inherited from the development
  PhaseFixture.development_address_attrs.each do |_attr, value|
    expect(page).to have_content(value)
  end
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

  # and on the show page
  click_on PhaseFixture.updated_phase_name

  PhaseFixture.update_attrs.each do |_attr, value|
    expect(page).to have_content(value)
  end

  PhaseFixture.address_update_attrs.each do |_attr, value|
    expect(page).to have_content(value)
  end
end

When(/^I delete the phase$/) do
  goto_development_show_page

  within ".tabs" do
    click_on t("developments.collection.phases")
  end

  delete_and_confirm!
end

Then(/^I should see that the deletion completed successfully$/) do
  success_flash = t(
    "phases.destroy.success",
    phase_name: PhaseFixture.updated_phase_name
  )

  within ".notice" do
    expect(page).to have_content(success_flash)
  end

  within ".breadcrumbs" do
    expect(page).to have_content(CreateFixture.development_name)
  end

  within ".record-list" do
    expect(page).not_to have_content PhaseFixture.updated_phase_name
  end
end

Then(/^I should see the development address has not been changed$/) do
  goto_development_show_page

  within ".section-data" do
    PhaseFixture.development_address_attrs.each do |_attr, value|
      expect(page).to have_content(value)
    end
  end
end
