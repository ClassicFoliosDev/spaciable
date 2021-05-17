# frozen_string_literal: true

Given(/^I am an admin user$/) do
  CFAdminUserFixture.create
end

Given(/^I am logged in as an admin$/) do
  login_as CFAdminUserFixture.create
  visit "/"
end

When(/^I log in as an admin$/) do
  admin_log_in
end

When(/^I log in as cf_admin$/) do
  admin_log_in
end

def admin_log_in
  admin = CFAdminUserFixture

  visit "/admin/sign_in"

  within ".admin-login-form" do
    fill_in :user_email, with: admin.email
    fill_in :user_password, with: admin.password

    click_on "Login"
  end

  find("#invited")
  find("#activated")
  find("#overview")
end

When(/^I log out as (.*)admin$/) do |_|
  log_out
end

Then(/^I should be on the admin dashboard$/) do
  expect(page).to have_link("Dashboard")
end

Then(/^I should be on the "Admin Login" page$/) do
  expect(current_path).to eq("/admin/sign_in")
end

Then(/^I can request an admin password reset$/) do
  click_on t("devise.forgot_password")

  fill_in :user_email, with: CreateFixture.cf_admin.email
  click_on t("residents.passwords.new.submit")
end

def log_out
  within ".navbar-menu" do
    click_on "Log Out"
  end
end
