# frozen_string_literal: true

Then(/^I should see the cookie pop\-up$/) do
  within ".cookies-eu" do
    expect(page).to have_content t("cookies_eu.cookies_text")
  end
end

When(/^I visit the cookie page$/) do
  visit "/cookies_policy"
end

When(/^I accept the cookies$/) do
  within ".cookies-eu" do
    click_on t("cookies_eu.ok")
  end
end

Then(/^I should no longer see the cookie pop\-up$/) do
  expect(page).not_to have_content t("cookies_eu.cookies_text")
end

When(/^I log in as a CF admin$/) do
  admin = CreateFixture.cf_admin

  login_as admin
  visit "/"
end
