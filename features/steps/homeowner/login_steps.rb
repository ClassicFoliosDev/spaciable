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
  click_on "Login"

  fill_in :resident_email, with: homeowner.email
  fill_in :resident_password, with: homeowner.password
  click_on "Login"
end

When(/^I log out as a homeowner$/) do
  find(:css, ".sign-out").click
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
