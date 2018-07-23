# frozen_string_literal: true

When(/^I visit the maintenance page$/) do
  within ".navbar-menu" do
    click_on I18n.t("components.homeowner.navigation.maintenance")
  end
end

Then(/^I should see the fixflo page$/) do
  expect(page).to have_selector(".maintenance")
end

Then(/^I should see the bafm link$/) do
  visit "/"
  expect(page).to have_content(I18n.t("components.homeowner.navigation.house_search"))
end

When(/^the expiry date is past$/) do
  plot = CreateFixture.development_plot
  plot.update_attributes(completion_release_date: Time.zone.now.ago(2.years))
end

Then(/^I should not see the maintenance link$/) do
  visit "/"

  within ".branded-header" do
    expect(page).not_to have_content(I18n.t("components.homeowner.navigation.maintenance"))
  end
end
