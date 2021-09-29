# frozen_string_literal: true

Then(/^I have not yet activated my account$/) do
  resident = Resident.find_by(email: HomeownerUserFixture.email)
  resident.update(invitation_accepted_at: nil)

  expect(resident.last_sign_in_at).to be_nil
  expect(resident.sign_in_count).to be_zero
  expect(resident.invitation_accepted?).to eq false

  expect(resident.developer_email_updates).to be_nil
  expect(resident.cf_email_updates).to be_nil
  expect(resident.telephone_updates).to be_nil

  ActionMailer::Base.deliveries.clear
end

When(/^I update the plot progress$/) do
  resident = Resident.find_by(email: HomeownerUserFixture.email)
  plot = resident.plots.first

  visit "/plots/#{plot.id}?active_tab=progress"

  within ".edit_plot" do
    select_from_selectmenu :plot_progress, with: PlotFixture.progress
    check :plot_notify
    click_on t("plots.form.submit")
  end
end

When(/^I update the resident plot progress$/) do
  resident = Resident.find_by(email: PlotResidencyFixture.original_email)
  plot = resident.plots.first

  visit "/plots/#{plot.id}?active_tab=progress"

  within ".edit_plot" do
    select_from_selectmenu :plot_progress, with: PlotFixture.progress
    check :plot_notify
    click_on t("plots.form.submit")
  end
end

When(/^I send a notification to the development$/) do
  visit "/admin/notifications"

  within ".section-actions" do
    click_on t("admin.notifications.collection.add")
  end

  resident = Resident.find_by(email: HomeownerUserFixture.email)
  plot = resident.plots.first

  within ".new_notification" do
    select_from_selectmenu(:notification_developer_id, with: plot.developer)
    select_from_selectmenu(:notification_development_id, with: plot.development)
    fill_in :notification_subject, with: "Notification should not be sent to unactivated user"
    fill_in_ckeditor(:notification_message, with: "Notification contents should not be sent to unactivated user")
  end

  within ".form-actions-footer" do
    click_on t("admin.notifications.form.submit")
  end
end

When(/^I send a notification to the resident's development$/) do
  visit "/admin/notifications"

  within ".section-actions" do
    click_on t("admin.notifications.collection.add")
  end

  resident = Resident.find_by(email: PlotResidencyFixture.original_email)
  plot = resident.plots.first

  within ".new_notification" do
    select_from_selectmenu(:notification_development_id, with: plot.development)
    fill_in :notification_subject, with: "Notification should not be sent to unactivated user"
    fill_in_ckeditor(:notification_message, with: "Notification contents should not be sent to unactivated user")
  end

  within ".form-actions-footer" do
    click_on t("admin.notifications.form.submit")
  end
end

Then(/^no emails are sent to the unactivated homeowner$/) do
  email_notifications = ActionMailer::Base.deliveries

  # The updates are sent to other recipients, but should not go to the
  # unactivated homeowner
  email_notifications.each do |notification|
    expect(notification.to).not_to include(HomeownerUserFixture.email)
  end
end

Then(/^I should not receive email notifications$/) do
  resident = Resident.find_by(email: PlotResidencyFixture.original_email)

  expect(resident.cf_email_updates).to be_zero
  expect(resident.developer_email_updates).to be_zero
  expect(resident.telephone_updates).to be_zero
end

Then(/^I should receive email notifications$/) do
  resident = Resident.find_by(email: PlotResidencyFixture.original_email)

  expect(resident.cf_email_updates).to eq 1
  expect(resident.developer_email_updates).to eq 1
  expect(resident.telephone_updates).to be_nil
end

Then(/^no emails are sent to the activated homeowner$/) do
  email_notifications = ActionMailer::Base.deliveries

  expect(email_notifications.count).to eq 0
end

Then(/^when I unselect the communication options$/) do
  within ".cf-email-updates" do
    find(".fa-check").click
  end
  within ".developer-email-updates" do
    find(".fa-check").click
  end
end
