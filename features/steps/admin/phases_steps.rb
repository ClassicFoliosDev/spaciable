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
  within ".phases" do
    click_on PhaseFixture.updated_phase_name
  end

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
  ActionMailer::Base.deliveries.clear
  visit "/"
  goto_phase_show_page

  within ".tabs" do
    click_on t("phases.collection.progresses")
  end

  select_from_selectmenu :progress_all, with: PhaseFixture.progress

  within ".form-actions-footer" do
    check :notify
    click_on t("progresses.collection.submit")
  end
end

Then(/^I should see the phase progress has been updated$/) do
  success_message = t(
    "progresses.bulk_update.success",
    progress: PhaseFixture.progress
  )
  residents = Resident.where(developer_email_updates: true)
  success_flash = success_message + t("resident_notification_mailer.notify.update_sent", count: residents.count)

  within ".notice" do
    expect(page).to have_content(success_flash)
  end
end

Then(/^Phase residents should have been notified$/) do
  success_message = t("resident_notification_mailer.notify.update_message",
                      type: "Plot",
                      name: "information",
                      verb: "updated to #{PhaseFixture.progress} for")

  in_app_notification = Notification.all.last
  expect(in_app_notification.message).to eq success_message
  expect(in_app_notification.residents.first.email).to eq CreateFixture.resident_email

  notification = ActionMailer::Base.deliveries.first
  expect(notification.parts.first.body.raw_source).to include success_message

  ActionMailer::Base.deliveries.clear
end
