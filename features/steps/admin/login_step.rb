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

  visit "/admin/sign_in"

  within ".admin-login-form" do
    fill_in :user_email, with: admin.email
    fill_in :user_password, with: admin.password

    click_on "Login"
  end

  within ".notifications" do
    expect(page).to have_content(t("dashboard.title"))
  end
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

Then(/^I can request an admin password reset$/) do
  click_on t("devise.forgot_password")

  fill_in :user_email, with: CreateFixture.cf_admin.email
  click_on t("residents.passwords.new.submit")
end
