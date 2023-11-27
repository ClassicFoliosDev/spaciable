# frozen_string_literal: true

When(/^I create a contact with no email or phone$/) do
  goto_developer_show_page

  within ".tabs" do
    click_on t("developers.collection.contacts")
  end

  within ".empty" do
    click_on t("contacts.collection.create")
  end

  within ".new_contact" do
    fill_in "contact_first_name", with: ContactFixture.first_name
    click_on t("contacts.form.submit")
  end
end

Then(/^I should see the contact create fail$/) do
  fail_flash = t(
    "activerecord.errors.models.contact.attributes.base.email_or_phone_required"
  )

  expect(page).to have_content(fail_flash)

  within ".contact" do
    expect(page).not_to have_content(ContactFixture.email)
  end
end

When(/^I create a contact$/) do
  within ".contact" do
    fill_in "contact_email", with: ContactFixture.email
  end

  click_on t("contacts.form.submit")
end

Then(/^I should see the created contact$/) do
  success_flash = t(
    "controller.success.create",
    name: ContactFixture.first_name
  )

  expect(page).to have_content(success_flash)

  within ".record-list" do
    expect(page).to have_content(ContactFixture.first_name)
  end
end

When(/^I update the contact$/) do
  within ".record-list" do
    find("[data-action='edit']").click
  end

  within ".contact" do
    fill_in "contact[first_name]", with: ContactFixture.updated_name
    fill_in "contact[last_name]", with: ContactFixture.last_name
    fill_in "contact[phone]", with: ContactFixture.phone
    fill_in "contact[email]", with: ContactFixture.updated_email

    select_from_selectmenu :contact_category, with: ContactFixture.category
    select_from_selectmenu :contact_title, with: ContactFixture.title

    picture_full_path = FileFixture.file_path + FileFixture.avatar_name
    within ".contact_picture" do
      attach_file("contact_picture",
                  File.absolute_path(picture_full_path),
                  visible: false)
    end
  end

  within ".form-actions-footer" do
    check :contact_notify
    click_on t("rooms.form.submit")
  end
end

Then(/^I should see the updated contact$/) do
  success_flash = t(
    "controller.success.update",
    name: "#{ContactFixture.updated_name} #{ContactFixture.last_name}"
  )
  success_flash << t("resident_notification_mailer.notify.update_sent", count: Resident.all.count)
  expect(page).to have_content(success_flash)

  within ".record-list" do
    click_on "#{ContactFixture.updated_name} #{ContactFixture.last_name}"
  end

  # On show page
  within ".section-header" do
    expect(page).to have_content(ContactFixture.updated_name)
  end

  within ".contact" do
    ContactFixture.updated_attrs.each do |_attr, value|
      expect(page).to have_content(value)
    end

    image = page.find("img")

    expect(image["src"]).to have_content(FileFixture.avatar_name)
  end
end

When(/^I remove an image from a contact$/) do
  click_on t("contacts.show.back")

  within ".record-list" do
    find("[data-action='edit']").click
  end

  within ".contact_picture" do
    remove_btn = find(".remove-btn", visible: false)
    remove_btn.trigger("click")
  end

  click_on t("unit_types.form.submit")
end

Then(/^I should see the updated contact without the image$/) do
  success_flash = t(
    "controller.success.update",
    name: "#{ContactFixture.updated_name} #{ContactFixture.last_name}"
  )

  within ".notice" do
    expect(page).to have_content(success_flash)
  end

  within ".contacts" do
    click_on "#{ContactFixture.updated_name} #{ContactFixture.last_name}"
  end

  # On the show page
  within ".contact" do
    expect(page).not_to have_content("img")
  end
end

Then(/^I should see the contact resident has been notified$/) do
  in_app_notification = Notification.all.last
  expect(in_app_notification.residents.count).to eq 1
  expect(in_app_notification.residents.first.email).to eq CreateFixture.resident.email

  email = ActionMailer::Base.deliveries.first
  name = #{ContactFixture.updated_name} + " " + #{ContactFixture.last_name}
  expect(email).to have_body_text("The following contact has been updated on your home's online portal:")
  expect(email).to have_body_text("#{ContactFixture.updated_name} #{ContactFixture.last_name}")
  ActionMailer::Base.deliveries.clear
end

When(/^I delete the contact$/) do
  developer = CreateFixture.developer
  visit "/developers/#{developer.id}/contacts"

  delete_and_confirm!(scope: ".contacts")
end

Then(/^I should see the contact deletion complete successfully$/) do
  success_flash = t(
    "controller.success.destroy",
    name: "#{ContactFixture.updated_name} #{ContactFixture.last_name}"
  )

  within ".notice" do
    expect(page).to have_content(success_flash)
  end

  expect(page).not_to have_content(".record-list")

  within ".empty" do
    expect(page).to have_content %r{#{t("components.empty_list.add", action: "Add", type_name: Contact.model_name.human.downcase)}}i
  end
end

When(/^I create a division contact with no email or phone$/) do
  division = CreateFixture.division
  visit "/divisions/#{division.id}/contacts"

  within ".empty" do
    click_on t("contacts.collection.create")
  end

  within ".new_contact" do
    fill_in "contact_first_name", with: ContactFixture.first_name
    click_on t("contacts.form.submit")
  end
end

When(/^I delete the division contact$/) do
  division = CreateFixture.division
  visit "/divisions/#{division.id}/contacts"

  delete_and_confirm!(scope: ".contacts")
end

When(/^I create a development contact with no name or organisation$/) do
  development = CreateFixture.development
  visit "/developments/#{development.id}/contacts"

  within ".empty" do
    click_on t("contacts.collection.create")
  end

  within ".contact" do
    fill_in "contact_first_name", with: ContactFixture.first_name
  end
  click_on t("contacts.form.submit")
end

When(/^I delete the development contact$/) do
  development = CreateFixture.development
  visit "/developments/#{development.id}/contacts"

  delete_and_confirm!(scope: ".contacts")
end

Then(/^I should not be able to create a developer contact$/) do
  developer = CreateFixture.developer
  visit "/"

  visit "/developers/#{developer.id}"

  click_on t("developers.collection.contacts")

  expect(page).not_to have_content(t("contacts.collection.create"))
end

When(/^I create a (additional )?developer contact$/) do |additional|
  visit "/"

  within ".navbar" do
    if additional
      goto_developer_show_page(additional)
    else
      click_on t("components.navigation.my_area", area: "Developer")
    end
  end

  click_on t("developers.collection.contacts")
  click_on t("contacts.collection.create")

  within ".contact" do
    fill_in "contact_first_name", with: ContactFixture.first_name
  end

  within ".contact" do
    fill_in "contact_email", with: ContactFixture.email
  end

  click_on t("contacts.form.submit")
end

When(/^I create a (additional )?division contact$/) do |additional|
  division = AdditionalRoleFixture.division(additional)
  visit "/divisions/#{division.id}/contacts"

  within ".empty" do
    click_on t("contacts.collection.create")
  end

  within ".contact" do
    fill_in "contact_first_name", with: ContactFixture.first_name
    fill_in "contact_email", with: ContactFixture.email
  end

  click_on t("contacts.form.submit")
end

When(/^I create a (additional )?phase contact$/) do |additional|
  phase = AdditionalRoleFixture.phase(additional)

  visit "/phases/#{phase.id}/contacts"

  within ".empty" do
    click_on t("contacts.collection.create")
  end

  within ".new_contact" do
    fill_in "contact_first_name", with: ContactFixture.first_name
    fill_in "contact_email", with: ContactFixture.email
    click_on t("contacts.form.submit")
  end
end

When(/^I create a (additional )?division phase contact$/) do |additional|
  phase = AdditionalRoleFixture.division_phase(additional)
  visit "/phases/#{phase.id}/contacts"

  within ".empty" do
    click_on t("contacts.collection.create")
  end

  within ".new_contact" do
    fill_in "contact_first_name", with: ContactFixture.first_name
    fill_in "contact_email", with: ContactFixture.email
    click_on t("contacts.form.submit")
  end
end


Then(/^I should not be able to create a division contact$/) do
  visit "/"
  division = CreateFixture.division

  visit "/developers/#{division.developer.id}/divisions/#{division.id}"

  click_on t("developers.collection.contacts")

  expect(page).not_to have_content(t("contacts.collection.create"))
end

When(/^I create a development contact$/) do

  development = Development.find_by(name: CreateFixture.division_development_name)
  visit "/developments/#{development.id}/contacts"

  within ".contact-index" do
    click_on t("contacts.collection.create")
  end

  within ".contact" do
    fill_in "contact_first_name", with: ContactFixture.first_name
    fill_in "contact_email", with: ContactFixture.email
  end

  click_on t("contacts.form.submit")
end

When(/^I create a phase contact with no email or phone$/) do
  phase = CreateFixture.phase
  visit "/phases/#{phase.id}/contacts"

  within ".empty" do
    click_on t("contacts.collection.create")
  end

  within ".new_contact" do
    fill_in "contact_first_name", with: ContactFixture.first_name
    click_on t("contacts.form.submit")
  end
end

When(/^I delete the (additional )?phase contact$/) do |additional|
  phase = AdditionalRoleFixture.phase(additional)
  visit "/phases/#{phase.id}/contacts/"

  delete_and_confirm!(scope: ".contacts")
end

When(/^I delete the (additional )?division phase contact$/) do |additional|
  phase = AdditionalRoleFixture.division_phase(additional)
  visit "/phases/#{phase.id}/contacts/"

  delete_and_confirm!(scope: ".contacts")
end
