# frozen_string_literal: true
Given(/^I am a homeowner$/) do
  HomeownerUserFixture.create
end

Given(/^I am logged in as a homeowner$/) do
  login_as HomeownerUserFixture.create
  visit "/"
end

When(/^I log in as a homeowner$/) do
  homeowner = HomeownerUserFixture

  visit "/"

  fill_in :resident_email, with: homeowner.email
  fill_in :resident_password, with: homeowner.password
  click_on "Login"
end

When(/^I log out as a homeowner$/) do
  first(:css, "[data-test='homeowner-sign-out']").click
end

Then(/^I should be on the "My Home" dashboard$/) do
  homeowner = HomeownerUserFixture

  expect(page).to have_link "My home"
  expect(page).to have_content "Hi #{homeowner.first_name}"
end

Then(/^I should be on the "Hoozzi Home" page$/) do
  expect(current_path).to eq("/")
end

Then(/^I should be on the "Homeowner Login" page$/) do
  expect(current_path).to eq("/homeowners/sign_in")
end

Given(/^I am a homeowner with no plot$/) do
  HomeownerUserFixture.create_without_residency
end

Then(/^I should be on the "Homeowner Login" page with errors$/) do
  expect(page).to have_content(t("residents.sessions.create.no_plot"))
  expect(page).to have_content(t("activerecord.attributes.resident.email"))
  expect(page).to have_content(t("activerecord.attributes.resident.password"))
end

When(/^I visit the data policy page$/) do
  visit "/data_policy"
end

Then(/^I should see the data policy contents$/) do
  within ".policy" do
    expect(page).to have_content(t("homeowners.dashboard.data_policy.title"))
    expect(page).to have_content(t("homeowners.dashboard.data_policy.para1"))
    expect(page).to have_content(t("homeowners.dashboard.data_policy.para2"))
    expect(page).to have_content(t("homeowners.dashboard.data_policy.para3"))
  end
end

When(/^I visit the ts_and_cs page$/) do
  visit "/ts_and_cs"
end

Then(/^I should see the terms and conditions for using Hoozzi$/) do
  within ".policy" do
    expect(page).to have_content(t("homeowners.dashboard.ts_and_cs.title"))
    expect(page).to have_content(t("homeowners.dashboard.ts_and_cs.para1"))
    expect(page).to have_content(t("homeowners.dashboard.ts_and_cs.para2"))
    expect(page).to have_content(t("homeowners.dashboard.ts_and_cs.para3"))
  end
end

Then(/^I can request a password reset$/) do
  visit "/"
  click_on t("devise.forgot_password")

  fill_in :resident_email, with: HomeownerUserFixture.email
  click_on t("residents.passwords.new.submit")
end
