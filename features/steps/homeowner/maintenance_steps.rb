# frozen_string_literal: true
When(/^I visit the maintenance page$/) do
  visit "/"

  within ".navbar-menu" do
    click_on I18n.t("components.homeowner.navigation.maintenance")
  end
end

Then(/^I should see the fixflo page$/) do
  expect(page).to have_selector(".maintenance")
end
