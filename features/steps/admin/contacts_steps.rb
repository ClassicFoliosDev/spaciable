# frozen_string_literal: true
When(/^I create a contact with no email or phone$/) do
  visit "/"

  within ".navbar" do
    click_on t("components.navigation.contacts")
  end

  click_on t("contacts.collection.create")

  within ".contacts" do
    fill_in "contact_first_name", with: ContactFixture.first_name
  end

  click_on t("contacts.form.submit")
end

Then(/^I should see the contact create fail$/) do
  fail_flash = t(
    "activerecord.errors.models.contact.attributes.base.email_or_phone_required"
  )

  expect(page).to have_content(fail_flash)

  within ".contacts" do
    expect(page).not_to have_content(ContactFixture.email)
  end
end

When(/^I create a contact$/) do
  within ".contacts" do
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

  within ".contacts" do
    expect(page).to have_content(ContactFixture.first_name)
  end
end

When(/^I update the contact$/) do
  find("[data-action='edit']").click

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

  click_on t("rooms.form.submit")
end

Then(/^I should see the updated contact$/) do
  success_flash = t(
    "controller.success.update",
    name: "#{ContactFixture.updated_name} #{ContactFixture.last_name}"
  )

  expect(page).to have_content(success_flash)

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
    expect(image["alt"]).to have_content(FileFixture.avatar_alt)
  end
end

When(/^I remove an image from a contact$/) do
  click_on t("contacts.show.back")

  find("[data-action='edit']").click

  within ".contact_picture" do
    remove_btn = find(".remove-btn", visible: false)
    remove_btn.click
  end

  click_on t("unit_types.form.submit")
end

Then(/^I should see the updated contact without the image$/) do
  success_flash = t(
    "controller.success.update",
    name: "#{ContactFixture.updated_name} #{ContactFixture.last_name}"
  )

  expect(page).to have_content(success_flash)

  within ".contact" do
    expect(page).not_to have_content("img")
  end
end

Given(/^I have created a contact$/) do
  CreateFixture.create_contact
end

When(/^I delete the contact$/) do
  contact_path = "/contacts"
  visit contact_path

  delete_and_confirm!
end

Then(/^I should see the contact deletion complete successfully$/) do
  success_flash = t(
    "controller.success.destroy",
    name: CreateFixture.contact_email
  )
  expect(page).to have_content(success_flash)

  within ".record-list" do
    expect(page).not_to have_content CreateFixture.contact_email
  end
end
