# frozen_string_literal: true

Given(/^I am CF Admin wanting to send notifications to Admins$/) do
  AdminNotificationsFixture.create_admin_resources

  admin = CreateFixture.create_cf_admin
  visit_admin_notifications_page(admin)
end

When(/^I send a notification to all admins$/) do
  ActionMailer::Base.deliveries.clear
  attrs = AdminNotificationsFixture::MESSAGES[:all]

  within ".section-actions" do
    click_on t("admin.notifications.collection.add")
  end

  within ".new_admin_notification" do
    fill_in :admin_notification_subject, with: attrs[:subject]
    fill_in_ckeditor(:admin_notification_message, with: attrs[:message])
  end

  within ".form-actions-footer" do
    click_on t("admin.admin_notifications.form.submit")
  end
end

Then(/^I can see the notification I sent to all admins$/) do
  within ".record-list" do
    notification = AdminNotificationsFixture::MESSAGES[:all]
    expect(page).to have_content(notification[:subject])
  end
end

def visit_admin_notifications_page(admin)
  login_as admin
  visit "/admin/admin_notifications"
end
