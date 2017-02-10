# frozen_string_literal: true
Given(/^I am an admin user$/) do
  CFAdminUserFixture.create
end

Given(/^I am logged in as an admin$/) do
  login_as CFAdminUserFixture.create
  visit "/"
end

When(/^I log in as an admin$/) do
  admin = CFAdminUserFixture

  visit "/admin"

  click_on "Login"

  fill_in :user_email, with: admin.email
  fill_in :user_password, with: admin.password

  click_on "Login"
end

When(/^I log out as a an admin$/) do
  click_on "Log out"
end

Then(/^I should be on the admin dashboard$/) do
  expect(page).to have_link("Dashboard")
end

Then(/^I should be on the "Admin Login" page$/) do
  expect(current_path).to eq("/admin/sign_in")
end
