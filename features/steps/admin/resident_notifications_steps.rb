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

  sleep 0.2
  check :notification_send_to_all
  sleep 0.2
  fill_in :notification_subject, with: attrs[:subject]
  fill_in_ckeditor(:notification_message, with: attrs[:message])

  click_on t("admin.notifications.form.submit")

  sleep 0.4
end

When(/^I send a notification to residents under (my|a) (\(\w+\) )?(\w+)$/) do |_, parent, resource_class|
  type, instance = ResidentNotificationsFixture.extract_resource(parent, resource_class)

  ActionMailer::Base.deliveries.clear

  attrs = ResidentNotificationsFixture::MESSAGES[type]

  click_on t("admin.notifications.collection.add")

  sleep 0.5 # wait for dropdown to be populated
  if instance.is_a?(Developer)
    select_from_selectmenu(:notification_developer_id, with: instance.to_s)
  else
    select_from_selectmenu(:notification_developer_id, with: instance.developer.to_s)
    sleep 0.5 # wait for dropdown to be populated
    select_from_selectmenu(:"notification_#{resource_class}_id", with: instance.to_s)
  end

  fill_in :notification_subject, with: attrs[:subject]
  fill_in_ckeditor(:notification_message, with: attrs[:message])

  click_on t("admin.notifications.form.submit")
  sleep 0.5 # wait for emails to be processed
end

When(/^I send a notification to a resident under a (\(\w+\) )?(\w+)$/) do |parent, plot_class|
  ActionMailer::Base.deliveries.clear

  type, plot = ResidentNotificationsFixture.extract_resource(parent, plot_class)
  parent_method = type[/(\w+)_/][0...-1]
  parent = plot.send(parent_method)
  attrs = ResidentNotificationsFixture::MESSAGES[type]

  click_on t("admin.notifications.collection.add")

  fill_in :notification_subject, with: attrs[:subject]
  fill_in_ckeditor(:notification_message, with: attrs[:message])

  sleep 0.3 # wait for dropdown to be populated
  select_from_selectmenu(:notification_developer_id, with: plot.developer.to_s)

  unless parent_method == :developer
    sleep 0.3 # wait for dropdown to be populated
    select_from_selectmenu(:"notification_#{parent_method}_id", with: parent.to_s)
  end

  sleep 0.3 # wait for dropdown to be populated
  fill_in :notification_list, with: plot.number

  click_on t("admin.notifications.form.submit")
  sleep 0.5 # wait for emails to be processed
end

Then(/^the resident under that (\(\w+\) )?(\w+) should receive a notification$/) do |parent, plot_class|
  type, plot = ResidentNotificationsFixture.extract_resource(parent, plot_class)
  emailed_addresses = ActionMailer::Base.deliveries.map(&:to).flatten

  expect(emailed_addresses).to match_array([plot.resident.email])

  notice = t(
    "admin.notifications.create.success",
    notification_name: ResidentNotificationsFixture::MESSAGES.dig(type, :subject),
    count: 1
  )
  expect(page).to have_content(notice)
end

Then(/^I can see the (\(\w+\) )?(\w+) notification I sent to the resident$/) do |parent, plot_class|
  type, plot = ResidentNotificationsFixture.extract_resource(parent, plot_class)
  parent_method = type[/(\w+)_/][0...-1]
  subject = ResidentNotificationsFixture::MESSAGES.dig(type, :subject)

  within ".record-list" do
    expect(page).to have_content(subject)
    sendees = "#{plot.send(parent_method)} (Plot #{plot})"
    expect(page).to have_content(sendees)
  end
end

Then(/^I can see the (\(\w+\) )?(\w+) notification I sent$/) do |parent, resource_class|
  type, instance = ResidentNotificationsFixture.extract_resource(parent, resource_class)

  subject = ResidentNotificationsFixture::MESSAGES.dig(type, :subject)

  within ".record-list" do
    expect(page).to have_content(subject)
    expect(page).to have_content(instance)
  end
end

Then(/^I can see the notification I sent to all residents$/) do
  subject = ResidentNotificationsFixture::MESSAGES.dig(:all, :subject)
  contents = ResidentNotificationsFixture::MESSAGES.dig(:all, :message)

  within ".record-list" do
    expect(page).to have_content(subject)
    expect(page).to have_content("All")
  end

  within ".actions" do
    find("[data-action='view']").click
  end

  sleep 0.2
  expect(page).to have_content(subject)
  expect(page).to have_content("All")
  expect(page).to have_content(contents)

  click_on t("admin.notifications.show.back")
end

Then(/^all residents under (my|that) (\(\w+\) )?(\w+) should receive a notification$/) do |_, parent, resource_class|
  type, instance = ResidentNotificationsFixture.extract_resource(parent, resource_class)

  resident_email_addresses = ResidentNotificationsFixture.resident_email_addresses(under: instance)
  emailed_addresses = ActionMailer::Base.deliveries.map(&:to).flatten

  expect(emailed_addresses).to match_array(resident_email_addresses)

  notice = t(
    "admin.notifications.create.success",
    notification_name: ResidentNotificationsFixture::MESSAGES.dig(type, :subject),
    count: resident_email_addresses.count
  )
  expect(page).to have_content(notice)
end

Then(/^all residents should receive a notification$/) do
  resident_email_addresses = Resident.pluck(:email)
  emailed_addresses = ActionMailer::Base.deliveries.map(&:to).flatten

  expect(emailed_addresses).to match_array(resident_email_addresses)

  notice = t(
    "admin.notifications.create.success",
    notification_name: ResidentNotificationsFixture::MESSAGES.dig(:all, :subject),
    count: resident_email_addresses.count
  )
  expect(page).to have_content(notice)
end
