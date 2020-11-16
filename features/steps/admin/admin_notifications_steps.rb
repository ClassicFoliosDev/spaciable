# frozen_string_literal: true

Given(/^I am a CF Admin wanting to send a notification to Admins$/) do
  AdminNotificationsFixture.create_admin_resources

  admin = CreateFixture.create_cf_admin
  login_as admin
  visit "/admin/admin_notifications"
end

When(/^I send a notification to all admins$/) do
  ActionMailer::Base.deliveries.clear

  within ".section-actions" do
    click_on t("admin.notifications.collection.add")
  end

  within ".admin_notification_send_to_all" do
    check_box = find("#admin_notification_send_to_all")
    check_box.trigger(:click)
  end

  within ".new_admin_notification" do
    fill_in :admin_notification_subject, with: AdminNotificationsFixture.notification_subject
    fill_in_ckeditor(:admin_notification_message, with: AdminNotificationsFixture.notification_message)
  end

  within ".form-actions-footer" do
    click_on t("admin.admin_notifications.form.submit")
  end
end

Then(/^I can see the notification I sent to all admins$/) do
  within ".record-list" do
    expect(page).to have_content(AdminNotificationsFixture.notification_subject)
    expect(page).to have_content(AdminNotificationsFixture.notification_message)
    expect(page).to have_content("All")
  end
end

Then(/^an email is sent to all admins$/) do
  emails = ActionMailer::Base.deliveries.last(5).map(&:to).flatten
  [NamedCreateFixture.developer_email,
   NamedCreateFixture.second_developer_email,
   NamedCreateFixture.division_email,
   NamedCreateFixture.development_email,
   NamedCreateFixture.second_division_development_email].each { |email| expect(emails.include?(email)).to be true }
end

When(/^I send a notification to a particular developer$/) do
  ActionMailer::Base.deliveries.clear

  within ".section-actions" do
    click_on t("admin.notifications.collection.add")
  end

  sleep 1
  select_from_selectmenu :developer_id, with: NamedCreateFixture.developer_name

  within ".new_admin_notification" do
    fill_in :admin_notification_subject, with: AdminNotificationsFixture.notification_subject
    fill_in_ckeditor(:admin_notification_message, with: AdminNotificationsFixture.notification_message)
  end

  within ".form-actions-footer" do
    click_on t("admin.admin_notifications.form.submit")
  end
end

Then(/^I can see the notification I sent to the developer$/) do
 within ".record-list" do
    expect(page).to have_content(AdminNotificationsFixture.notification_subject)
    expect(page).to have_content(AdminNotificationsFixture.notification_message)
    expect(page).to have_content(NamedCreateFixture.developer_name)
  end
end

Then(/^an email is sent to the developer admins$/) do
  emails = ActionMailer::Base.deliveries.last(3).map(&:to).flatten
  [NamedCreateFixture.developer_email,
   NamedCreateFixture.division_email,
   NamedCreateFixture.development_email].each { |email| expect(emails.include?(email)).to be true }
end
