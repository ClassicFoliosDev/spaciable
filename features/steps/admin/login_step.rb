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

When(/^I visit the admin ts_and_cs page$/) do
  visit "/ts_and_cs2"
end

Then(/^I should see the terms and conditions for developers using Hoozzi$/) do
  within ".policy" do
    expect(page).to have_content(t("legal.ts_and_cs2.title"))
    expect(page).to have_content(t("legal.ts_and_cs2.about_us"))
    expect(page).to have_content(t("legal.ts_and_cs2.ip"))
    expect(page).to have_content(t("legal.ts_and_cs2.law"))
    expect(page).to have_content(t("legal.ts_and_cs2.limitation"))
    expect(page).to have_content(t("legal.ts_and_cs2.viruses"))
    expect(page).to have_content(t("legal.ts_and_cs2.welcome").first(30))
    expect(page).to have_content(t("legal.ts_and_cs2.changes"))
    expect(page).to have_content(t("legal.ts_and_cs2.severance"))
    expect(page).to have_content(t("legal.ts_and_cs2.third_party"))
  end
end

Then(/^I can request an admin password reset$/) do
  click_on t("devise.forgot_password")

  fill_in :user_email, with: CreateFixture.cf_admin.email
  click_on t("residents.passwords.new.submit")
end
