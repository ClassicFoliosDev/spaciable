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
