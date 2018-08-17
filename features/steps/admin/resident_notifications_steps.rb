# frozen_string_literal: true

Given(/^I am CF Admin wanting to send notifications to residents$/) do
  ResidentNotificationsFixture.create_permission_resources
  admin = CreateFixture.create_cf_admin

  visit_notifications_page(admin)
end

Given(/^I am Developer Admin wanting to send notifications to residents$/) do
  ResidentNotificationsFixture.create_permission_resources
  admin = CreateFixture.create_developer_admin

  visit_notifications_page(admin)
end

Given(/^I am Division Admin wanting to send notifications to residents$/) do
  ResidentNotificationsFixture.create_permission_resources
  admin = CreateFixture.create_division_admin

  visit_notifications_page(admin)
end

Given(/^I am Development Admin wanting to send notifications to residents$/) do
  ResidentNotificationsFixture.create_permission_resources
  admin = CreateFixture.create_development_admin

  visit_notifications_page(admin)
end

Given(/^I am \(Division\) Development Admin wanting to send notifications to residents$/) do
  ResidentNotificationsFixture.create_permission_resources
  admin = CreateFixture.create_division_development_admin

  visit_notifications_page(admin)
end

When(/^I send a notification to all residents$/) do
  ActionMailer::Base.deliveries.clear
  attrs = ResidentNotificationsFixture::MESSAGES[:all]

  within ".section-actions" do
    click_on t("admin.notifications.collection.add")
  end

  within ".new_notification" do
    check :notification_send_to_all
    fill_in :notification_subject, with: attrs[:subject]
    fill_in_ckeditor(:notification_message, with: attrs[:message])
  end

  within ".form-actions-footer" do
    click_on t("admin.notifications.form.submit")
  end
end

When(/^I send a notification to residents under (my|a) (\(\w+\) )?(\w+)$/) do |_, parent, resource_class|
  ActionMailer::Base.deliveries.clear
  visit "/admin/notifications/new"

  type, instance = ResidentNotificationsFixture.extract_resource(parent, resource_class)
  attrs = ResidentNotificationsFixture::MESSAGES[type]

  sleep 0.3
  within ".send-targets" do
    if instance.is_a?(Developer)
      within ".developer-id" do
        select_from_selectmenu(:notification_developer_id, with: instance.to_s)
      end
    else
      within ".developer-id" do
        select_from_selectmenu(:notification_developer_id, with: instance.developer.to_s)
      end

      sleep 0.3
      within ".#{resource_class}-id" do
        select_from_selectmenu(:"notification_#{resource_class}_id", with: instance.to_s)
      end
    end
  end

  within ".send-message" do
    fill_in :notification_subject, with: attrs[:subject]
    fill_in_ckeditor(:notification_message, with: attrs[:message])
  end

  within ".form-actions-footer" do
    click_on t("admin.notifications.form.submit")
  end
end

When(/^I send a notification to a resident under a (\(\w+\) )?(\w+)$/) do |parent, plot_class|
  ActionMailer::Base.deliveries.clear

  type, plot = ResidentNotificationsFixture.extract_resource(parent, plot_class)
  parent_method = type[/(\w+)_/][0...-1]
  parent = plot.send(parent_method)
  attrs = ResidentNotificationsFixture::MESSAGES[type]

  within ".section-actions" do
    click_on t("admin.notifications.collection.add")
  end

  within ".new_notification" do
    fill_in :notification_subject, with: attrs[:subject]
    fill_in_ckeditor(:notification_message, with: attrs[:message])

    within ".developer-id" do
      select_from_selectmenu(:notification_developer_id, with: plot.developer.to_s)
    end

    unless parent_method == :developer
      sleep 0.3
      select_from_selectmenu(:"notification_#{parent_method}_id", with: parent.to_s)
    end

    fill_in :notification_list, with: plot.number
  end

  within ".form-actions-footer" do
    click_on t("admin.notifications.form.submit")
  end
end

Then(/^the resident under that (\(\w+\) )?(\w+) should receive a notification$/) do |parent, plot_class|
  type, plot = ResidentNotificationsFixture.extract_resource(parent, plot_class)
  resident_email_addresses = ResidentNotificationsFixture.resident_email_addresses(under: plot)

  within ".notice" do
    expect(page).to have_content(ResidentNotificationsFixture::MESSAGES.dig(type, :subject))
  end

  emailed_addresses = ActionMailer::Base.deliveries.map(&:to).flatten
  expect(emailed_addresses).to match_array(resident_email_addresses)
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

  within ".notification" do
    expect(page).to have_content(subject)
    expect(page).to have_content("All")
    expect(page).to have_content(contents)
  end

  within ".form-actions-footer" do
    click_on t("admin.notifications.show.back")
  end
end

Then(/^all residents under (my|that) (\(\w+\) )?(\w+) should receive a notification$/) do |_, parent, resource_class|
  type, instance = ResidentNotificationsFixture.extract_resource(parent, resource_class)
  resident_email_addresses = ResidentNotificationsFixture.resident_email_addresses(under: instance)

  notice = t(
    "admin.notifications.create.success",
    notification_name: ResidentNotificationsFixture::MESSAGES.dig(type, :subject),
    count: resident_email_addresses.count
  )
  expect(page).to have_content(notice)

  emailed_addresses = ActionMailer::Base.deliveries.map(&:to).flatten
  expect(emailed_addresses).to match_array(resident_email_addresses)
end

Then(/^all residents should receive a notification$/) do
  resident_email_addresses = Resident.where(developer_email_updates: true).pluck(:email)
  emailed_addresses = ActionMailer::Base.deliveries.map(&:to).flatten

  expect(emailed_addresses).to match_array(resident_email_addresses)

  notice = t(
    "admin.notifications.create.success",
    notification_name: ResidentNotificationsFixture::MESSAGES.dig(:all, :subject),
    count: resident_email_addresses.count
  )
  within ".notice" do
    expect(page).to have_content(notice)
  end
end

def visit_notifications_page(admin)
  login_as admin
  visit "/admin/notifications"
end

Given(/^there are homeowners$/) do
  plot_residencies = PlotResidency.all

  plot_residencies.each do |plot_residency|
    plot_residency.update_attributes(role: 'homeowner')
  end
end

Given(/^there is a tenant$/) do
  phase_plot = CreateFixture.phase_plot
  tenant = FactoryGirl.create(:resident, :with_residency, plot: phase_plot, email: "tenant@example.com", developer_email_updates: true, ts_and_cs_accepted_at: Time.zone.now)

  plot_residency = tenant.plot_residencies.first
  plot_residency.update_attributes(role: 'tenant')
end

When(/^I send a notification to homeowner residents under my Developer$/) do
  ActionMailer::Base.deliveries.clear
  visit "/admin/notifications/new"

  attrs = ResidentNotificationsFixture::MESSAGES[:developer]

  within ".send-targets" do
    within ".developer-id" do
      select_from_selectmenu(:notification_developer_id, with: CreateFixture.developer_name)
    end
  end

  within ".send-message" do
    fill_in :notification_subject, with: attrs[:subject]
    fill_in_ckeditor(:notification_message, with: attrs[:message])
  end

  within ".form-actions-footer" do
    click_on t("admin.notifications.form.submit")
  end
end

Then(/^all homeowner residents under my Developer should receive a notification$/) do
  homeowner_plot_residencies = PlotResidency.where(role: 'homeowner')

  homeowner_email_addresses = Array.new
  homeowner_plot_residencies.each do |plot_residency|
    next if homeowner_email_addresses.include? plot_residency.resident.email
    homeowner_email_addresses << plot_residency.resident.email if plot_residency.resident.developer_email_updates == 1
  end

  notice = t(
    "admin.notifications.create.success",
    notification_name: ResidentNotificationsFixture::MESSAGES.dig(:developer, :subject),
    count: homeowner_email_addresses.count
  )

  within ".flash" do
    expect(page).to have_content(notice)
  end

  emailed_addresses = ActionMailer::Base.deliveries.map(&:to).flatten
  expect(emailed_addresses).to match_array(homeowner_email_addresses)
end

Then(/^tenants should not receive a notification$/) do
  plot_residency = PlotResidency.find_by(role: 'tenant')
  tenant = plot_residency.resident

  emailed_addresses = ActionMailer::Base.deliveries.map(&:to).flatten
  expect(emailed_addresses).not_to include tenant.email
end

When(/^I send a notification to tenant residents under my Developer$/) do
  ActionMailer::Base.deliveries.clear
  visit "/admin/notifications/new"

  within ".send-to-role" do
    choose('notification_send_to_role_tenant')
  end

  attrs = ResidentNotificationsFixture::MESSAGES[:developer]

  within ".send-targets" do
    within ".developer-id" do
      select_from_selectmenu(:notification_developer_id, with: CreateFixture.developer_name)
    end
  end

  within ".send-message" do
    fill_in :notification_subject, with: attrs[:subject]
    fill_in_ckeditor(:notification_message, with: attrs[:message])
  end

  within ".form-actions-footer" do
    click_on t("admin.notifications.form.submit")
  end
end

Then(/^all tenant residents under my Developer should receive a notification$/) do
  plot_residency = PlotResidency.find_by(role: 'tenant')
  tenant = plot_residency.resident

  emailed_addresses = ActionMailer::Base.deliveries.map(&:to).flatten
  expect(emailed_addresses).to include tenant.email
end

Then(/^homeowners should not receive a notification$/) do
  homeowner_plot_residencies = PlotResidency.where(role: 'homeowner')

  homeowner_email_addresses = Array.new
  homeowner_plot_residencies.each do |plot_residency|
    next if homeowner_email_addresses.include? plot_residency.resident.email
    homeowner_email_addresses << plot_residency.resident.email if plot_residency.resident.developer_email_updates == 1
  end

  notice = t(
    "admin.notifications.create.success",
    notification_name: ResidentNotificationsFixture::MESSAGES.dig(:developer, :subject),
    count: 1
  )

  within ".flash" do
    expect(page).to have_content(notice)
  end

  emailed_addresses = ActionMailer::Base.deliveries.map(&:to).flatten

  homeowner_email_addresses.each do |address|
    expect(emailed_addresses).not_to include address
  end
end

When(/^I send a notification to homeowner and tenant residents under my Developer$/) do
  ActionMailer::Base.deliveries.clear
  visit "/admin/notifications/new"

  within ".send-to-role" do
    choose('notification_send_to_role_both')
  end

  attrs = ResidentNotificationsFixture::MESSAGES[:developer]

  within ".send-targets" do
    within ".developer-id" do
      select_from_selectmenu(:notification_developer_id, with: CreateFixture.developer_name)
    end
  end

  within ".send-message" do
    fill_in :notification_subject, with: attrs[:subject]
    fill_in_ckeditor(:notification_message, with: attrs[:message])
  end

  within ".form-actions-footer" do
    click_on t("admin.notifications.form.submit")
  end
end
