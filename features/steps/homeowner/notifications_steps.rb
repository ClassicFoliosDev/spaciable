# frozen_string_literal: true

Given(/^I am logged in as a homeowner wanting to read notifications$/) do
  HomeownerNotificationsFixture.create_homeowner_notifications

  login_as HomeownerNotificationsFixture.resident
end

When(/^I read the notifications$/) do
  page.find("#dropdownMenu").click
  within ".links-list" do
    click_on t("components.homeowner.header.messages")
  end
end

Then(/^I should see the notifications list$/) do
  within(".notification-list") do
    cards = page.all(".card")
    expect(cards.length).to eq(3)

    expect(page).to have_content("Sent from admin to all developer")
    expect(page).to have_content("Sent from admin to all development")
    expect(page).to have_content("Sent from developer to resident")
  end
end

Then(/^All my notifications should be unread$/) do
  within "#acctNav" do
    sup = page.first(".unread")
    expect(sup).to have_content("3")
  end

  within ".notification-expanded" do
    expect(page).not_to have_content("Sent")
  end
end

Then(/^I should not see notifications for other residents in my development$/) do
  within(".notification-list") do
    expect(page).not_to have_content("Sent to another resident")
  end
end

When(/^I click on a notification summary$/) do
  notification_scope = "[data-id='#{HomeownerNotificationsFixture.notification_id}']"
  within(".notification-list") do
    card = page.find(notification_scope)
    card.click
  end
end

Then(/^I should see the expanded notification$/) do
  within ".notification-expanded" do
    expect(page).to have_content %r{#{"Sent from admin to all development"}}i
    expect(page).to have_content "Mauris pretium euismod arcu, at placerat magna aliquet condimentum."
  end
end

Then(/^the notification status in my header should be updated$/) do
  within "#acctNav" do
    sup = page.first(".unread")
    expect(sup).to have_content("2")
  end
end

And(/^there is a second notification plot$/) do
  HomeownerNotificationsFixture.create_second_plot
end

When(/^I update the notification plot progress$/) do
  resident = HomeownerNotificationsFixture.resident
  plot = resident.plots.first

  visit "/plots/#{plot.id}/edit"

  within ".edit_plot" do
    select_from_selectmenu :plot_build_step_id, with: PlotFixture.progress
    check :plot_notify
    click_on t("plots.form.submit")
  end
end

Then(/^I should see a notification for the updated plot progress$/) do
  visit "/homeowners/notifications"

  within ".notification-list" do
    card = page.find(".details", text: t("notify.updated_build"))
    card.trigger(:click)
  end

  within ".notification-expanded" do
    expect(page).to have_content("The Build Progress status has been updated to:")
    expect(page).to have_content("In progress")
  end
end

When(/^I log in as a notification homeowner$/) do
  login_as HomeownerNotificationsFixture.resident
  visit "/"
end
