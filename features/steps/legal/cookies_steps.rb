# frozen_string_literal: true

Then(/^I should see the cookie pop\-up$/) do
  within ".cookies-eu" do
    expect(page).to have_content t("cookies_eu.cookies_text")
  end
end

When(/^I visit the cookie page$/) do
  visit "/cookies_policy"
end

Then(/^I should see the cookie information for Hoozzi$/) do
   within ".policy" do
    expect(page).to have_content t("legal.cookies_policy.subtitle")
    expect(page).to have_content t("legal.cookies_policy.information_1")
    expect(page).to have_content t("legal.cookies_policy.information_2")
    expect(page).to have_content t("legal.cookies_policy.analytics")
    expect(page).to have_content t("legal.cookies_policy.necessary")
    expect(page).to have_content t("legal.cookies_policy.functional")
    expect(page).to have_content t("legal.cookies_policy.target")
    expect(page).to have_content t("legal.cookies_policy.table.hoozzi")
    expect(page).to have_content t("legal.cookies_policy.table.hoozzi_for")
    expect(page).to have_content t("legal.cookies_policy.table.google")
    expect(page).to have_content t("legal.cookies_policy.table.google_for")
    expect(page).to have_content t("legal.cookies_policy.table.fixflo")
    expect(page).to have_content t("legal.cookies_policy.table.fixflo_for")
  end
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
