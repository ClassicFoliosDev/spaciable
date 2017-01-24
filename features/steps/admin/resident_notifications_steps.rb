# frozen_string_literal: true
Given(/^I am Developer Admin wanting to send notifications to residents$/) do
  login_as ResidentNotificationsFixture.create_developer_admin
  visit "/"

  click_on t("components.navigation.notifications")
end

Given(/^I am Division Admin wanting to send notifications to residents$/) do
  login_as ResidentNotificationsFixture.create_division_admin
  visit "/"

  click_on t("components.navigation.notifications")
end

Given(/^I am Development Admin wanting to send notifications to residents$/) do
  login_as ResidentNotificationsFixture.create_development_admin
  visit "/"

  click_on t("components.navigation.notifications")
end

Given(/^I am \(Division\) Development Admin wanting to send notifications to residents$/) do
  login_as ResidentNotificationsFixture.create_division_development_admin
  visit "/"

  click_on t("components.navigation.notifications")
end

When(/^I send a notification to all residents$/) do
  attrs = ResidentNotificationsFixture.developer_admin_messages[:to_all]

  click_on t("admin.notifications.collection.add")
  select_from_selectmenu(:notification_developer_id, with: attrs[:developer])
  fill_in :notification_subject, with: attrs[:subject]
  fill_in :notification_message, with: attrs[:message]

  click_on t("admin.notifications.form.submit")
end

Then(/^all residents under my Developer should receive a notification$/) do
  fixture = ResidentNotificationsFixture
  attrs = fixture.developer_admin_messages[:to_all]

  notice = t(
    "admin.notifications.create.success",
    notification_name: attrs[:subject],
    recipient_count: fixture.developer_resident_emails.count
  )

  expect(fixture.recipient_emails).to match_array(fixture.developer_resident_emails)
  expect(page).to have_content(notice)
end

Then(/^I can see the Developer notification I sent$/) do
  pending "re-writing these tests to work with fixed developer drop down"
  attrs = ResidentNotificationsFixture.developer_admin_messages[:to_all]

  within ".notification-subject" do
    expect(page).to have_content(attrs[:subject])
  end

  within ".notification-recipient-level" do
    expect(page).to have_content(attrs[:recipient_level])
  end
end

When(/^I send a notification to residents under a Division$/) do
  attrs = ResidentNotificationsFixture.division_admin_messages[:to_all]

  click_on t("admin.notifications.collection.add")
  select_from_selectmenu(:notification_division, with: attrs[:division])
  fill_in :notification_subject, with: attrs[:subject]
  fill_in :notification_message, with: attrs[:message]

  click_on t("admin.notifications.form.submit")
end

Then(/^all residents under that Division should receive a notification$/) do
  pending # Write code here that turns the phrase above into concrete actions
end

Then(/^I can see the Division notification I sent$/) do
  pending # Write code here that turns the phrase above into concrete actions
end

When(/^I send a notification to residents under a Development$/) do
  pending # Write code here that turns the phrase above into concrete actions
end

Then(/^all residents under that Development should receive a notification$/) do
  pending # Write code here that turns the phrase above into concrete actions
end

Then(/^I can see the Development notification I sent$/) do
  pending # Write code here that turns the phrase above into concrete actions
end

When(/^I send a notification to residents under a Phase$/) do
  pending # Write code here that turns the phrase above into concrete actions
end

Then(/^all residents under that Phase should receive a notification$/) do
  pending # Write code here that turns the phrase above into concrete actions
end

Then(/^I can see the Phase notification I sent$/) do
  pending # Write code here that turns the phrase above into concrete actions
end

Then(/^all residents under my Division should receive a notification$/) do
  pending # Write code here that turns the phrase above into concrete actions
end

When(/^I send a notification to residents under a \(Division\) Development$/) do
  pending # Write code here that turns the phrase above into concrete actions
end

Then(/^all residents under that \(Division\) Development should receive a notification$/) do
  pending # Write code here that turns the phrase above into concrete actions
end

Then(/^all residents under my Development should receive a notification$/) do
  pending # Write code here that turns the phrase above into concrete actions
end

Then(/^all residents under my \(Division\) Development should receive a notification$/) do
  pending # Write code here that turns the phrase above into concrete actions
end

Then(/^I can see the \(Division\) Development notification I sent$/) do
  pending # Write code here that turns the phrase above into concrete actions
end

Then(/^I can see the Division Phase notification I sent$/) do
  pending # Write code here that turns the phrase above into concrete actions
end
