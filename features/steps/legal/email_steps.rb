# frozen_string_literal: true

Then(/^I have not yet activated my account$/) do
  resident = Resident.find_by(email: HomeownerUserFixture.email)

  expect(resident.last_sign_in_at).to be_nil
  expect(resident.sign_in_count).to be_zero

  expect(resident.developer_email_updates).to be_nil
  expect(resident.hoozzi_email_updates).to be_nil
  expect(resident.telephone_updates).to be_nil
  expect(resident.post_updates).to be_nil

  ActionMailer::Base.deliveries.clear
end

When(/^I update the plot progress$/) do
  resident = Resident.find_by(email: HomeownerUserFixture.email)
  # TODO improve plot calculation
  plot = resident.plots.first

  visit "/plots/#{plot.id}/edit"

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
  # TODO improve plot calculation
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

Then(/^no emails are sent to the unactivated homeowner$/) do
  email_notifications = ActionMailer::Base.deliveries
  email_notifications.each do |email|
    expect(email.to).not_to eq HomeownerUserFixture.email
  end
end

