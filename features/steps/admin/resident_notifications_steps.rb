# frozen_string_literal: true
Given(/^I am CF Admin wanting to send notifications to residents$/) do
  ResidentNotificationsFixture.create_permission_resources
  admin = CreateFixture.create_cf_admin

  login_as admin
  visit "/"

  click_on t("components.navigation.notifications")
end

Given(/^I am Developer Admin wanting to send notifications to residents$/) do
  ResidentNotificationsFixture.create_permission_resources
  admin = CreateFixture.create_developer_admin

  login_as admin
  visit "/"

  click_on t("components.navigation.notifications")
end

Given(/^I am Division Admin wanting to send notifications to residents$/) do
  ResidentNotificationsFixture.create_permission_resources
  admin = CreateFixture.create_division_admin

  login_as admin
  visit "/"

  click_on t("components.navigation.notifications")
end

Given(/^I am Development Admin wanting to send notifications to residents$/) do
  ResidentNotificationsFixture.create_permission_resources
  admin = CreateFixture.create_development_admin

  login_as admin
  visit "/"

  click_on t("components.navigation.notifications")
end

Given(/^I am \(Division\) Development Admin wanting to send notifications to residents$/) do
  ResidentNotificationsFixture.create_permission_resources
  admin = CreateFixture.create_division_development_admin

  login_as admin
  visit "/"

  click_on t("components.navigation.notifications")
end

When(/^I send a notification to all residents$/) do
  ActionMailer::Base.deliveries.clear

  attrs = ResidentNotificationsFixture::MESSAGES[:all]

  click_on t("admin.notifications.collection.add")

  check :notification_send_to_all
  fill_in :notification_subject, with: attrs[:subject]
  fill_in :notification_message, with: attrs[:message]

  click_on t("admin.notifications.form.submit")

  sleep 0.4
end

When(/^I send a notification to residents under (my|a) (\(\w+\) )?(\w+)$/) do |_, parent, resource_class|
  type, instance = ResidentNotificationsFixture.extract_resource(parent, resource_class)

  ActionMailer::Base.deliveries.clear

  attrs = ResidentNotificationsFixture::MESSAGES[type]

  click_on t("admin.notifications.collection.add")

  fill_in :notification_subject, with: attrs[:subject]
  fill_in :notification_message, with: attrs[:message]

  unless instance.is_a?(Developer)
    select_from_selectmenu(:notification_developer_id, with: instance.developer.to_s)
    sleep 0.5
  end

  select_from_selectmenu(:"notification_#{resource_class}_id", with: instance.to_s)

  click_on t("admin.notifications.form.submit")
end

Then(/^I can see the (\(\w+\) )?(\w+) notification I sent$/) do |parent, resource_class|
  type, instance = ResidentNotificationsFixture.extract_resource(parent, resource_class)

  subject = ResidentNotificationsFixture::MESSAGES.dig(type, :subject)

  within ".record-list .notifications" do
    expect(page).to have_content(subject)

    expect(page).to have_content("#{Notification.human_attribute_name(:send_to)}: #{instance}")
  end
end

Then(/^I can see the notification I sent to all residents$/) do
  subject = ResidentNotificationsFixture::MESSAGES.dig(:all, :subject)

  within ".record-list .notifications" do
    expect(page).to have_content(subject)

    expect(page).to have_content("#{Notification.human_attribute_name(:send_to)}: All")
  end
end

Then(/^all residents under (my|that) (\(\w+\) )?(\w+) should receive a notification$/) do |_, parent, resource_class|
  type, instance = ResidentNotificationsFixture.extract_resource(parent, resource_class)

  resident_email_addresses = ResidentNotificationsFixture.resident_email_addresses(under: instance)
  emailed_addresses = ActionMailer::Base.deliveries.map(&:to).flatten

  expect(emailed_addresses).to match_array(resident_email_addresses)

  notice = t(
    "admin.notifications.create.success",
    notification_name: ResidentNotificationsFixture::MESSAGES.dig(type, :subject),
    recipient_count: resident_email_addresses.count
  )
  expect(page).to have_content(notice)
end

Then(/^all residents should receive a notification$/) do
  resident_email_addresses = User.homeowner.pluck(:email)
  emailed_addresses = ActionMailer::Base.deliveries.map(&:to).flatten

  expect(emailed_addresses).to match_array(resident_email_addresses)

  notice = t(
    "admin.notifications.create.success",
    notification_name: ResidentNotificationsFixture::MESSAGES.dig(:all, :subject),
    recipient_count: resident_email_addresses.count
  )
  expect(page).to have_content(notice)
end
