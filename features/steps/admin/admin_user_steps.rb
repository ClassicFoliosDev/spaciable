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

Given(/^I am logged in as a Site Admin$/) do
  AdminUsersFixture.create_permission_resources
  admin = CreateFixture.create_site_admin

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

  recipient_email = ActionMailer::Base.deliveries.last

  message = t("devise.mailer.invitation_instructions.someone_invited_you_admin", development: "Classic Folios")
  expect(recipient_email.parts.first.body.raw_source).to include message
end

Then(/^I should see the new CF Admin$/) do
  attrs = AdminUsersFixture.second_cf_admin_attrs

  expect(page).to have_content(attrs[:email_address])
  expect(page).to have_content(attrs[:role])
end

Then(/^I should see the restored CF Admin$/) do
  attrs = AdminUsersFixture.second_cf_admin_attrs

  expect(page).to have_content(attrs[:first_name])
  expect(page).to have_content(attrs[:last_name])
  expect(page).to have_content(attrs[:role])
end

When(/^I update the CF Admin$/) do
  within "[data-user=\"#{AdminUsersFixture.second_cf_admin_id}\"]" do
    find("[data-action='edit']").click
  end

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

When(/^I log in as development admin$/) do
  development_user = User.find_by(email: AdminUsersFixture.development_admin_attrs[:email_address] )
  login_as development_user
  visit "/"
end

Then(/^I should see the updated CF Admin$/) do
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
  visit "/admin/users"

  within ".section-actions" do
    click_on t("admin.users.index.add")
  end

  attrs = AdminUsersFixture.developer_admin_attrs

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
    expect(page).to have_content(attrs[:email])
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
    expect(page).to have_content(attrs[:email])
    expect(page).to have_content(attrs[:role])
  end

  click_on attrs[:email_address]

  expect(page).to have_content(attrs[:email_address])
  expect(page).to have_content(attrs[:role])
  expect(page).to have_content(attrs[:division])

  click_on t("admin.users.show.back")
end

When(/^I add a Development Admin$/) do
  visit "/admin/users"

  within ".section-actions" do
    click_on t("admin.users.index.add")
  end

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
    expect(page).to have_content(attrs[:email])
    expect(page).to have_content(attrs[:role])
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
    expect(page).to have_content(attrs[:email])
    expect(page).to have_content(attrs[:role])
  end

  click_on attrs[:email_address]

  expect(page).to have_content(attrs[:email_address])
  expect(page).to have_content(attrs[:role])
  expect(page).to have_content(attrs[:development])

  click_on t("admin.users.show.back")
end

When(/^I update the new admin$/) do
  find("[data-action='edit']").click

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
  within ".record-list" do
    expect(page).to have_content(AdminUsersFixture.second_cf_admin_update_attrs[:first_name])
    expect(page).to have_content(AdminUsersFixture.second_cf_admin_update_attrs[:last_name])
  end
end

When(/^I change my password$/) do
  visit "/"
  click_on t("components.navigation.profile")
  find("[data-action='edit']").click

  within(".user_current_password") do
    fill_in "user[current_password]", with: CreateFixture.admin_password
  end
  within(".user_password") do
    fill_in "user[password]", with: AdminUsersFixture.new_password
  end
  within(".user_password_confirmation") do
    fill_in "user[password_confirmation]", with: AdminUsersFixture.new_password
  end

  click_on t("admin.users.form.submit")
end

Then(/^I should be logged out$/) do
  expect(page).to have_content(t("admin.users.update.success_password", user_name: ""))

  within ".admin-login-form" do
    expect(page).to have_content "You've made it."
  end
end

When(/^I visit the users page$/) do
  visit "/admin/users"
end

Then(/^I see the activated users$/) do
  today = Time.zone.now.to_date.strftime("%d.%m.%Y")

  development_admin = User.find_by(email: AdminUsersFixture.development_admin_attrs[:email_address] )
  within "[data-user=\"#{development_admin.id}\"]" do
    expect(page).to have_content today
  end

  division_admin = User.find_by(email: AdminUsersFixture.division_admin_attrs[:email_address] )
  within "[data-user=\"#{division_admin.id}\"]" do
    expect(page).not_to have_content today
  end

  developer_admin = User.find_by(email: AdminUsersFixture.developer_admin_attrs[:email_address] )
  within "[data-user=\"#{developer_admin.id}\"]" do
    expect(page).not_to have_content today
  end
end

When(/^I accept the invitation as development admin$/) do
  invitation = ActionMailer::Base.deliveries.last
  sections = invitation.text_part.body.to_s.split("http://localhost")
  paths = sections[1].split(t("devise.mailer.invitation_instructions.ignore"))

  visit paths[0]

  within ".admin-login-form" do
    fill_in :user_password, with: AdminUsersFixture.new_password
    fill_in :user_password_confirmation, with: AdminUsersFixture.new_password

    click_on t("residents.invitations.edit.submit_button")
  end

  ActionMailer::Base.deliveries.clear
end

When(/^I delete the developer admin$/) do
  visit "/admin/users"
  developer_admin = User.find_by(email: AdminUsersFixture.developer_admin_attrs[:email_address] )
  delete_and_confirm!(scope: "[data-user=\"#{developer_admin.id}\"]")
end

Then(/^I should not see the deleted developer admin$/) do
  within ".notice" do
    expect(page).to have_content AdminUsersFixture.developer_admin_attrs[:email_address]
  end

  within ".users" do
    expect(page).not_to have_content AdminUsersFixture.developer_admin_attrs[:email_address]
  end

  developer_admin = User.with_deleted.find_by(email: AdminUsersFixture.developer_admin_attrs[:email_address] )
  expect(developer_admin.permission_level_type).to be_nil
  expect(developer_admin.permission_level_id).to be_nil
end

When(/^I delete the division admin$/) do
  visit "/admin/users"
  division_admin = User.find_by(email: AdminUsersFixture.division_admin_attrs[:email_address] )
  delete_and_confirm!(scope: "[data-user=\"#{division_admin.id}\"]")
end

Then(/^I should not see the deleted division admin$/) do
  within ".notice" do
    expect(page).to have_content AdminUsersFixture.division_admin_attrs[:email_address]
  end

  within ".users" do
    expect(page).not_to have_content AdminUsersFixture.division_admin_attrs[:email_address]
  end

  division_admin = User.with_deleted.find_by(email: AdminUsersFixture.division_admin_attrs[:email_address] )
  expect(division_admin.permission_level_type).to be_nil
  expect(division_admin.permission_level_id).to be_nil
end

When(/^I delete the division development admin$/) do
  visit "/admin/users"
  development_admin = User.find_by(email: AdminUsersFixture.division_development_admin_attrs[:email_address] )
  delete_and_confirm!(scope: "[data-user=\"#{development_admin.id}\"]")
end

Then(/^I should not see the deleted division development admin$/) do
  within ".notice" do
    expect(page).to have_content AdminUsersFixture.division_development_admin_attrs[:email_address]
  end

  within ".users" do
    expect(page).not_to have_content AdminUsersFixture.division_development_admin_attrs[:email_address]
  end

  division_development_admin = User.with_deleted.find_by(email: AdminUsersFixture.division_development_admin_attrs[:email_address] )
  expect(division_development_admin.permission_level_type).to be_nil
  expect(division_development_admin.permission_level_id).to be_nil
end


When(/^I delete the development admin$/) do
  visit "/admin/users"
  development_admin = User.find_by(email: AdminUsersFixture.development_admin_attrs[:email_address] )
  delete_and_confirm!(scope: "[data-user=\"#{development_admin.id}\"]")
end

Then(/^I should not see the deleted development admin$/) do
  within ".notice" do
    expect(page).to have_content AdminUsersFixture.development_admin_attrs[:email_address]
  end

  within ".users" do
    expect(page).not_to have_content AdminUsersFixture.development_admin_attrs[:email_address]
  end

  development_admin = User.with_deleted.find_by(email: AdminUsersFixture.development_admin_attrs[:email_address] )
  expect(development_admin.permission_level_type).to be_nil
  expect(development_admin.permission_level_id).to be_nil
end

When(/^I restore the deleted developer admin as CF admin$/) do
  visit "/admin/users"

  within ".section-actions" do
    click_on t("admin.users.index.add")
  end

  within ".user_email" do
    fill_in :user_email, with: AdminUsersFixture.developer_admin_attrs[:email_address]
  end

  select_from_selectmenu :user_role, with: "CF Admin"

  click_on t("admin.users.form.submit")
end

Then(/^I should see the recreated CF admin$/) do
  within ".notice" do
    expect(page).to have_content AdminUsersFixture.developer_admin_attrs[:email_address]
  end

  restored_cf_user = User.find_by(email: AdminUsersFixture.developer_admin_attrs[:email_address])

  within "[data-user=\"#{restored_cf_user.id}\"]" do
    expect(page).to have_content AdminUsersFixture.developer_admin_attrs[:email_address]
    expect(page).to have_content "CF Admin"
    expect(page).not_to have_content "Developer Admin"
  end
end
