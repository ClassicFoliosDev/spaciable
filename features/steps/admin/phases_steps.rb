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

  sleep 0.2
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

  expect(page).not_to have_content(".record-list")

  within ".empty" do
    expect(page).to have_content t("components.empty_list.add", type_name: Phase.model_name.human.downcase)
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

When(/^I update the progress for the phase$/) do
  visit "/"
  goto_phase_show_page

  within ".tabs" do
    click_on t("phases.collection.phase_progresses")
  end

  select_from_selectmenu :phase_progress_all, with: PhaseFixture.progress

  within ".form-actions-footer" do
    click_on t("phase_progresses.collection.submit")
  end
end

Then(/^I should see the plot progress has been updated$/) do
  success_flash = t(
    "phase_progresses.bulk_update.success",
    progress: PhaseFixture.progress
  )

  within ".notice" do
    expect(page).to have_content(success_flash)
  end

  within ".record-list" do
    expect(page).to have_content(PhaseFixture.progress)
    expect(page).not_to have_content("Building soon")
  end
end
