# frozen_string_literal: true

Given(/^I am logged in as a CF Admin$/) do
  AdminUsersFixture.create_permission_resources
  admin = CreateFixture.create_cf_admin

  login_as admin
  visit "/"
end

Given(/^I am logged in as a Developer Admin( with CAS)*$/) do |cas|
  AdminUsersFixture.create_permission_resources(cas: cas.present?)
  admin = CreateFixture.create_developer_admin(cas: cas.present?)
  login_as admin
  visit "/"
end

Given(/^I am logged in as a Division Admin( with CAS)*$/) do |cas|
  AdminUsersFixture.create_permission_resources(cas: cas.present?)
  admin = CreateFixture.create_division_admin(cas: cas.present?)

  login_as admin
  visit "/"
end

Given(/^I am logged in as a Development Admin( with CAS)*$/) do |cas|
  AdminUsersFixture.create_permission_resources(cas: cas.present?)
  admin = CreateFixture.create_development_admin(cas: cas.present?)

  login_as admin
  visit "/"
end

Given(/^I am logged in as a Site Admin( with CAS)*$/) do |cas|
  AdminUsersFixture.create_permission_resources(cas: cas.present?)
  admin = CreateFixture.create_site_admin(cas: cas.present?)

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
    click_on t("components.navigation.users")
  end
end

When(/^I add a new CF Admin$/) do
  click_on t("admin.users.index.add")

  within ".user_email" do
    fill_in :user_email, with: AdminUsersFixture.second_cf_admin_attrs[:email_address]
  end

  cas_validate(visible: false, disabled: true, checked: false)

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

When(/^I add a new (.*) user$/) do |role|
  visit "/admin/users"

  within ".section-actions" do
    click_on t("admin.users.index.add")
  end

  attrs = nil
  case role
    when "Developer Admin"
      attrs = AdminUsersFixture.developer_admin_attrs
    when "Division Admin"
      attrs = AdminUsersFixture.division_admin_attrs
    when "Development Admin"
      attrs = AdminUsersFixture.development_admin_attrs
    when "Division Development Admin"
      attrs = AdminUsersFixture.division_development_admin_attrs
  end

  within ".user_email" do
    fill_in "user[email]", with: attrs[:email_address]
  end

  page.execute_script "window.scrollTo(0,200)"

  select_from_selectmenu :user_role, with: attrs[:role]
  select_from_selectmenu :user_developer_id, with: attrs[:developer]
  select_from_selectmenu :user_division_id, with: attrs[:division] if attrs[:division]
  select_from_selectmenu :user_development_id, with: attrs[:development] if attrs[:development]

  visible = CreateFixture.developer.cas
  disabled = (role == "Developer Admin" || role == "Division Admin")
  checked = (role == "Developer Admin" || role == "Division Admin")
  cas_validate(visible: visible, disabled: disabled, checked: checked)

  click_on t("admin.users.form.submit")
end

Then(/^I should see the new (.*) user$/) do |role|

  attrs = nil
  case role
    when "Developer Admin"
      attrs = AdminUsersFixture.developer_admin_attrs
    when "Division Admin"
      attrs = AdminUsersFixture.division_admin_attrs
    when "Development Admin"
      attrs = AdminUsersFixture.development_admin_attrs
    when "Division Development Admin"
      attrs = AdminUsersFixture.division_development_admin_attrs
  end

  within find(".record-list") do
    expect(page).to have_content(attrs[:role])
    expect(page).to have_content(attrs[:email_address])
  end

  click_on attrs[:email_address]

  expect(page).to have_content(attrs[:email_address])
  expect(page).to have_content(attrs[:role])
  expect(page).to have_content(attrs[:developer]) unless (attrs[:division] || attrs[:development])
  expect(page).to have_content(attrs[:division]) if (attrs[:division] && !attrs[:development])
  expect(page).to have_content(attrs[:development]) if attrs[:development]

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
  open_email('development@cf.com')
  click_first_link_in_email

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
  expect(developer_admin.permission_level_type).to have_content("Developer")
  expect(developer_admin.permission_level_id).to have_content(Developer.find_by(company_name: AdminUsersFixture.developer_admin_attrs[:developer]).id)
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
  expect(division_admin.permission_level_type).to have_content("Division")
  expect(division_admin.permission_level_id).to have_content(Division.find_by(division_name: AdminUsersFixture.division_admin_attrs[:division]).id)
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
  expect(division_development_admin.permission_level_type).to have_content("Development")
  expect(division_development_admin.permission_level_id).to have_content(Development.find_by(name: AdminUsersFixture.division_development_admin_attrs[:development]).id)
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
  expect(development_admin.permission_level_type).to have_content("Development")
  expect(development_admin.permission_level_id).to have_content(Development.find_by(name: AdminUsersFixture.development_admin_attrs[:development]).id)
end

When(/^I restore the deleted developer admin as CF admin$/) do
  visit "/admin/users"

  within ".section-actions" do
    click_on t("admin.users.index.add")
  end

  within ".user_email" do
    fill_in :user_email, with: AdminUsersFixture.developer_admin_attrs[:email_address]
  end

  select "CF Admin", visible: false

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

Given(/^that I have developer, division and development users$/) do
  LettingsFixture.create_letting_admins
end

When(/^I edit the developer details$/) do
  visit "/developers/#{CreateFixture.developer.id}/edit"
end

Then(/^I can set the primary developer admin$/) do
  select_from_selectmenu :developer_prime_lettings_admin,
                         with: LettingsFixture.developer_admins.first.to_s
  click_on t("admin.users.form.submit")
end

When(/^I edit the division details$/) do
  visit "/developers/#{CreateFixture.developer.id}/divisions/#{CreateFixture.division.id}/edit"
end

Then(/^I can set the primary division admin$/) do
  select_from_selectmenu :division_prime_lettings_admin,
                         with: LettingsFixture.division_admins.second.to_s
  click_on t("admin.users.form.submit")
end

When(/^I log in as the primary developer admin$/) do
  login_as LettingsFixture.developer_admins.first
  visit "/admin/users"
end

Then(/^I can enable my developer development users to perform lettings$/) do
  # I can see the users
  LettingsFixture.developer_development_admins.each do |admin|
    expect(page).to have_content admin.to_s
  end

  find(:xpath, ".//a[@href='/admin/users/#{LettingsFixture.developer_development_admins.first.id}/edit']").click
  expect(page).to have_content t("admin.users.form.administer_branch")

  find('#branch_admin_check').trigger('click')

  # The edit user javascript doesn't work properly - update manually
  admin = LettingsFixture.developer_development_admins.first
  admin.update_attributes(lettings_management: User.lettings_managements.key(User.lettings_managements[:branch]))
  admin.save

  expect(LettingsFixture.developer_development_admins.first.lettings_management).to be == User.lettings_managements.key(User.lettings_managements[:branch])
end

When(/^I log in as the non primary developer admin$/) do
  login_as LettingsFixture.developer_admins.second
  visit "/admin/users"
end

Then(/^I cannot enable my developer development users to perform lettings$/) do
  # I can see the users
  LettingsFixture.developer_development_admins.each do |admin|
    expect(page).to have_content admin.to_s
  end

  find(:xpath, ".//a[@href='/admin/users/#{LettingsFixture.developer_development_admins.first.id}/edit']").click
  expect(page).to have_content t("admin.users.form.administer_branch")
  expect(page).to have_field('branch_admin_check', type: 'checkbox', disabled: true)
end

When(/^I log in as the primary division admin$/) do
  login_as LettingsFixture.division_admins.second
  visit "/admin/users"
end

Then(/^I can enable my division development users to perform lettings$/) do
  # I can see the users
  LettingsFixture.division_development_admins.each do |admin|
    expect(page).to have_content admin.to_s
  end

  find(:xpath, ".//a[@href='/admin/users/#{LettingsFixture.division_development_admins.first.id}/edit']").click
  expect(page).to have_content t("admin.users.form.administer_branch")
  find('#branch_admin_check').trigger('click')

    # The edit user javascript doesn't work properly - update manually
  admin = LettingsFixture.division_development_admins.first
  admin.update_attributes(lettings_management: User.lettings_managements.key(User.lettings_managements[:branch]))
  admin.save

  expect(LettingsFixture.division_development_admins.first.lettings_management).to be == User.lettings_managements.key(User.lettings_managements[:branch])
end

When(/^I log in as the non primary division admin$/) do
  login_as LettingsFixture.developer_admins.first
  visit "/admin/users"
end

Then(/^I cannot enable my division development users to perform lettings$/) do
  # I can see the users
  LettingsFixture.division_development_admins.each do |admin|
    expect(page).to have_content admin.to_s
  end

  find(:xpath, ".//a[@href='/admin/users/#{LettingsFixture.division_development_admins.first.id}/edit']").click
  expect(page).to have_content t("admin.users.form.administer_branch")
  expect(page).to have_field('branch_admin_check', type: 'checkbox', disabled: true)
end

When(/the developer has CAS (.*)$/) do |status|
  Developer.find(CreateFixture.developer.id).update_attributes(cas: status == "enabled")
end

def cas_validate(visible: false, disabled: true, checked: false)
  if visible
    expect(page).to have_content(t("admin.users.form.adds_specifications"))
    expect(page).to have_field 'cas_check', disabled: disabled, checked: checked
  else
    expect(page).not_to have_content(t("admin.users.form.adds_specifications"))
  end
end

Then(/^I should see the restored developer admin$/) do
  within ".record-list" do
    expect(page).to have_content(AdminUsersFixture.developer_admin_attrs[:email_address])
    expect(page).to have_content(AdminUsersFixture.development_admin_attrs[:developer])
  end
end

Then(/^I can resend an invitation to the unactivated developer admin$/) do
  developer_admin = User.with_deleted.find_by(email: AdminUsersFixture.developer_admin_attrs[:email_address] )
  within "[data-invite=\"#{developer_admin.id}\"]" do
    find(".fa-envelope-o").click
  end

  within ".ui-dialog-buttonset" do
    click_on "Send"
  end

  sleep 0.5

  email = ActionMailer::Base.deliveries.last
  expect(email.to).to eq [AdminUsersFixture.developer_admin_attrs[:email_address]]
end

Given(/^I have an additional developer$/) do
  dev = CreateFixture.create_developer(name: AdminUsersFixture.additional_developer_name)
  Division.create(division_name: AdminUsersFixture.additional_division_name, developer: dev)
end

Given(/^I go to the add user page$/) do
  visit "/admin/users/new"
end

Then(/^I cannot add an additional role$/) do
  expect(page).not_to have_content(t("admin.users.index.add"))
end


Then(/^when I define a new (.*) user$/) do |role|
  visit "/admin/users"

  within ".section-actions" do
    click_on t("admin.users.index.add")
  end

  attrs = nil
  case role
    when "Developer Admin"
      attrs = AdminUsersFixture.developer_admin_attrs
    when "Division Admin"
      attrs = AdminUsersFixture.division_admin_attrs
    when "Development Admin"
      attrs = AdminUsersFixture.development_admin_attrs
    when "Division Development Admin"
      attrs = AdminUsersFixture.division_development_admin_attrs
  end

  within ".user_email" do
    fill_in "user[email]", with: attrs[:email_address]
  end

  page.execute_script "window.scrollTo(0,200)"

  select_from_selectmenu :user_role, with: attrs[:role]
  select_from_selectmenu :user_developer_id, with: attrs[:developer]
  select_from_selectmenu :user_division_id, with: attrs[:division] if attrs[:division]
  select_from_selectmenu :user_development_id, with: attrs[:development] if attrs[:development]
end

Then(/^I can add an additional (.*) role$/) do |role|
  define_additional_user(role)
  page.find("#add_role").trigger('click')
  within ".additional-roles" do
    expect(page).to have_content(role)

    case role
    when "Developer Admin"
      expect(page).to have_content(AdminUsersFixture.additional_developer_admin_attrs[:developer])
    when "Division Admin"
      expect(page).to have_content(AdminUsersFixture.additional_division_admin_attrs[:division])
    end
  end
end

def define_additional_user(role)
  attrs = nil
  case role
  when "CF Admin"
      attrs = AdminUsersFixture.additional_CF_admin_attrs
    when "Developer Admin"
      attrs = AdminUsersFixture.additional_developer_admin_attrs
    when "Division Admin"
      attrs = AdminUsersFixture.additional_division_admin_attrs
  end

  page.execute_script "window.scrollTo(0,200)"

  select_from_selectmenu :user_su_role, with: attrs[:role]
  select_from_selectmenu :user_su_developer_id, with: attrs[:developer] if attrs[:developer]
  select_from_selectmenu :user_su_division_id, with: attrs[:division] if attrs[:division]
end

Then(/^I cannot add a duplicate additional Division Admin role$/) do
  define_additional_user("Division Admin")
  page.find("#add_role").trigger('click')
  expect(page).to have_content(t("admin.users.form.duplicate_role"))
  click_on "Cancel"
end

Then(/^I cannot save the new user$/) do
  click_on t("admin.users.form.submit")
  expect(page).to have_content(t("admin.users.form.higher_precidence"))
  click_on "Cancel"
end

Then(/^I can delete the additional Developer Admin role$/) do
  find(".additional-role:last-child #metadata i").trigger('click')
  click_on "Delete"
end

Then(/^I can save the new user$/) do
  click_on t("admin.users.form.submit")
  expect(page).to have_content("#{AdminUsersFixture.division_admin_attrs[:email]} was created successfully")
end
