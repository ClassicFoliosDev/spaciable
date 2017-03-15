# frozen_string_literal: true
Given(/^I am logged in as a CF Admin$/) do
  AdminUsersFixture.create_permission_resources
  admin = CreateFixture.create_cf_admin

  login_as admin
  visit "/"
end

Given(/^I am logged in as a Developer Admin$/) do
  AdminUsersFixture.create_permission_resources
  admin = CreateFixture.create_developer_admin

  login_as admin
  visit "/"
end

Given(/^I am logged in as a Division Admin$/) do
  AdminUsersFixture.create_permission_resources
  admin = CreateFixture.create_division_admin

  login_as admin
  visit "/"
end

Given(/^I am logged in as a Development Admin$/) do
  AdminUsersFixture.create_permission_resources
  admin = CreateFixture.create_development_admin

  login_as admin
  visit "/"
end

Given(/^I am logged in as a Development Admin for a Division$/) do
  AdminUsersFixture.create_permission_resources
  admin = CreateFixture.create_division_development_admin

  login_as admin
  visit "/"
end

Given(/^I am on the Admin Users page$/) do
  within ".navbar" do
    click_on "Users"
  end
end

When(/^I add a new CF Admin$/) do
  click_on t("admin.users.index.add")

  within ".user_email" do
    fill_in :user_email, with: AdminUsersFixture.second_cf_admin_attrs[:email_address]
  end

  select "CF Admin", visible: false

  click_on t("admin.users.form.submit")
end

Then(/^I should see the new CF Admin$/) do
  attrs = AdminUsersFixture.second_cf_admin_attrs

  click_on attrs[:email_address]

  expect(page).to have_content(attrs[:email_address])
  expect(page).to have_content(attrs[:role])

  click_on t("admin.users.show.back")
end

When(/^I update the CF Admin$/) do
  sleep 0.2
  within "[data-user=\"#{AdminUsersFixture.second_cf_admin_id}\"]" do
    find("[data-action='edit']").click
  end

  sleep 0.3
  within ".user_first_name" do
    fill_in "user[first_name]", with: AdminUsersFixture.second_cf_admin_update_attrs[:first_name]
  end
  within ".user_last_name" do
    fill_in "user[last_name]", with: AdminUsersFixture.second_cf_admin_update_attrs[:last_name]
  end

  within ".form-actions-footer" do
    click_on t("admin.users.form.submit")
  end
end

Then(/^I should see the updated CF Admin$/) do
  sleep 0.4

  within ".record-list" do
    expect(page).to have_content(AdminUsersFixture.second_cf_admin_update_attrs[:first_name])
    expect(page).to have_content(AdminUsersFixture.second_cf_admin_update_attrs[:last_name])
  end
end

When(/^I delete the updated CF Admin$/) do
  delete_and_confirm!(scope: "[data-user=\"#{AdminUsersFixture.second_cf_admin_id}\"]")
end

Then(/^I should not see the deleted CF Admin$/) do
  within ".record-list" do
    expect(page).not_to have_content(AdminUsersFixture.second_cf_admin_update_attrs[:first_name])
    expect(page).not_to have_content(AdminUsersFixture.second_cf_admin_update_attrs[:last_name])
  end
end

When(/^I add a new Developer Admin$/) do
  click_on t("admin.users.index.add")

  attrs = AdminUsersFixture.developer_admin_attrs

  sleep 0.3
  within ".user_email" do
    fill_in "user[email]", with: attrs[:email_address]
  end

  select_from_selectmenu :user_role, with: attrs[:role]
  select_from_selectmenu :user_developer_id, with: attrs[:developer]

  click_on t("admin.users.form.submit")
end

Then(/^I should see the new Developer Admin$/) do
  attrs = AdminUsersFixture.developer_admin_attrs

  within ".record-list" do
    expect(page).to have_content(attrs[:role])
    expect(page).to have_content(attrs[:developer])
  end

  click_on attrs[:email_address]

  expect(page).to have_content(attrs[:email_address])
  expect(page).to have_content(attrs[:role])
  expect(page).to have_content(attrs[:developer])

  click_on t("admin.users.show.back")
end

When(/^I add a new Division Admin$/) do
  click_on t("admin.users.index.add")

  attrs = AdminUsersFixture.division_admin_attrs

  sleep 0.3
  within ".user_email" do
    fill_in "user[email]", with: attrs[:email_address]
  end

  select_from_selectmenu :user_role, with: attrs[:role]
  select_from_selectmenu :user_developer_id, with: attrs[:developer]
  select_from_selectmenu :user_division_id, with: attrs[:division]

  click_on t("admin.users.form.submit")
end

Then(/^I should see the new Division Admin$/) do
  attrs = AdminUsersFixture.division_admin_attrs

  within ".record-list" do
    expect(page).to have_content(attrs[:role])
    expect(page).to have_content(attrs[:division])
  end

  click_on attrs[:email_address]

  expect(page).to have_content(attrs[:email_address])
  expect(page).to have_content(attrs[:role])
  expect(page).to have_content(attrs[:division])

  click_on t("admin.users.show.back")
end

When(/^I add a Development Admin$/) do
  click_on t("admin.users.index.add")

  attrs = AdminUsersFixture.development_admin_attrs

  within ".user_email" do
    fill_in :user_email, with: attrs[:email_address]
  end

  select_from_selectmenu :user_role, with: attrs[:role]
  select_from_selectmenu :user_developer_id, with: attrs[:developer]
  select_from_selectmenu :user_development_id, with: attrs[:development]

  click_on t("admin.users.form.submit")
end

Then(/^I should see the new Development Admin$/) do
  attrs = AdminUsersFixture.development_admin_attrs

  within ".record-list" do
    expect(page).to have_content(attrs[:role])
    expect(page).to have_content(attrs[:development])
  end

  click_on attrs[:email_address]

  expect(page).to have_content(attrs[:email_address])
  expect(page).to have_content(attrs[:role])
  expect(page).to have_content(attrs[:development])

  click_on t("admin.users.show.back")
end

When(/^I add a \(division\) Development Admin$/) do
  click_on t("admin.users.index.add")

  attrs = AdminUsersFixture.division_development_admin_attrs

  within ".user_email" do
    fill_in :user_email, with: attrs[:email_address]
  end

  select_from_selectmenu :user_role, with: attrs[:role]
  select_from_selectmenu :user_developer_id, with: attrs[:developer]
  select_from_selectmenu :user_division_id, with: attrs[:division]
  select_from_selectmenu :user_development_id, with: attrs[:development]

  click_on t("admin.users.form.submit")
end

Then(/^I should see the new \(division\) Development Admin$/) do
  attrs = AdminUsersFixture.division_development_admin_attrs

  within ".record-list" do
    expect(page).to have_content(attrs[:role])
    expect(page).to have_content(attrs[:development])
  end

  click_on attrs[:email_address]

  expect(page).to have_content(attrs[:email_address])
  expect(page).to have_content(attrs[:role])
  expect(page).to have_content(attrs[:development])

  click_on t("admin.users.show.back")
end

When(/^I update the new admin$/) do
  find("[data-action='edit']").click

  sleep 0.2
  expect(page).not_to have_content(".password")
  within ".user_first_name" do
    fill_in "user[first_name]", with: AdminUsersFixture.second_cf_admin_update_attrs[:first_name]
  end
  within ".user_last_name" do
    fill_in "user[last_name]", with: AdminUsersFixture.second_cf_admin_update_attrs[:last_name]
  end

  click_on t("admin.users.form.submit")
end

Then(/^I should see the updated admin$/) do
  sleep 0.2
  within ".record-list" do
    expect(page).to have_content(AdminUsersFixture.second_cf_admin_update_attrs[:first_name])
    expect(page).to have_content(AdminUsersFixture.second_cf_admin_update_attrs[:last_name])
  end
end

When(/^I change my password$/) do
  visit "/"
  click_on t("components.navigation.profile")
  find("[data-action='edit']").click

  sleep 0.2
  within(".user_current_password") do
    fill_in :password, with: CreateFixture.admin_password
  end
  within(".user_password") do
    fill_in :password, with: AdminUsersFixture.new_password
  end
  within(".user_password_confirmation") do
    fill_in :password, with: AdminUsersFixture.new_password
  end

  click_on t("admin.users.form.submit")
end

Then(/^I should be logged out$/) do
  expect(page).to have_content(t("devise.failure.unauthenticated"))

  within ".admin-login-form" do
    expect(page).to have_content(t("activerecord.attributes.user.email"))
    expect(page).to have_content(t("activerecord.attributes.user.password"))
  end
end
