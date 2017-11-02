# frozen_string_literal: true

Given(/^I am logged in as a homeowner wanting to read notifications$/) do
  HomeownerNotificationsFixture.setup

  login_as HomeownerNotificationsFixture.resident
  visit "/"
end

When(/^I read the notifications$/) do
  within(".session-inner") do
    notification_link = page.find(:css, 'a[href="/homeowners/notifications"]')
    notification_link.click
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

  within ".user" do
    sup = page.find(".unread")
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
  within(".notification-list") do
    card = page.find_by(id: "notification-#{HomeownerNotificationsFixture.notification_id}")
    card.click
  end
end

Then(/^I should see the expanded notification$/) do
  within ".notification-expanded" do
    expect(page).to have_content("Sent from admin to all development")
    expect(page).to have_content("Mauris pretium euismod arcu, at placerat magna aliquet condimentum.")
  end
end

Then(/^the notification status in my header should change$/) do
  within ".user" do
    sup = page.find(".unread")
    expect(sup).to have_content("2")
  end
end
