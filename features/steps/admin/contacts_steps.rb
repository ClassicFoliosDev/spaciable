# frozen_string_literal: true
When(/^I create a contact with no email or phone$/) do
  visit "/"

  within ".navbar" do
    click_on t("components.navigation.developers")
  end

  click_on CreateFixture.developer_name

  click_on t("developers.collection.contacts")

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

  within ".record-list" do
    expect(page).to have_content(ContactFixture.first_name)
  end
end

When(/^I update the contact$/) do
  within ".record-list" do
    find("[data-action='edit']").click
  end

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
    expect(image["alt"]).to have_content(FileFixture.avatar_alt)
  end
end

When(/^I remove an image from a contact$/) do
  click_on t("contacts.show.back")

  within ".record-list" do
    find("[data-action='edit']").click
  end

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

  within ".record-list" do
    click_on "#{ContactFixture.updated_name} #{ContactFixture.last_name}"
  end

  # On the show page
  within ".contact" do
    expect(page).not_to have_content("img")
  end
end

When(/^I delete the contact$/) do
  visit "/developers"

  click_on CreateFixture.developer_name

  click_on t("developers.collection.contacts")

  delete_and_confirm!
end

Then(/^I should see the contact deletion complete successfully$/) do
  success_flash = t(
    "controller.success.destroy",
    name: "#{ContactFixture.updated_name} #{ContactFixture.last_name}"
  )
  expect(page).to have_content(success_flash)

  expect(page).not_to have_content(".record-list")

  within ".empty" do
    expect(page).to have_content t("components.empty_list.add", type_name: Contact.model_name.human.downcase)
  end
end

When(/^I create a division contact with no email or phone$/) do
  visit "/"

  within ".navbar" do
    click_on t("components.navigation.developers")
  end

  click_on t("developers.collection.divisions")

  within ".record-list" do
    click_on CreateFixture.division_name
  end

  click_on t("developers.collection.contacts")

  click_on t("contacts.collection.create")

  within ".contacts" do
    fill_in "contact_first_name", with: ContactFixture.first_name
  end

  click_on t("contacts.form.submit")
end

When(/^I delete the division contact$/) do
  visit "/developers"

  click_on CreateFixture.developer_name

  click_on t("developers.collection.divisions")

  within ".record-list" do
    click_on CreateFixture.division_name
  end

  click_on t("developers.collection.contacts")

  delete_and_confirm!
end

When(/^I create a development contact with no name or organisation$/) do
  visit "/"

  within ".navbar" do
    click_on t("components.navigation.developers")
  end

  click_on t("developers.collection.developments")

  within ".record-list" do
    click_on CreateFixture.development_name
  end

  click_on t("developers.collection.contacts")

  click_on t("contacts.collection.create")

  within ".contacts" do
    fill_in "contact_first_name", with: ContactFixture.first_name
  end
  click_on t("contacts.form.submit")
end

When(/^I delete the development contact$/) do
  visit "/developers"

  click_on CreateFixture.developer_name

  click_on t("developers.collection.developments")

  within ".record-list" do
    click_on CreateFixture.development_name
  end

  click_on t("developers.collection.contacts")

  delete_and_confirm!
end

Then(/^I should not be able to create a developer contact$/) do
  visit "/"

  within ".navbar" do
    click_on t("components.navigation.developers")
  end

  click_on CreateFixture.developer_name

  click_on t("developers.collection.contacts")

  expect(page).not_to have_content(t("contacts.collection.create"))
end

When(/^I create a developer contact$/) do
  visit "/"

  within ".navbar" do
    click_on t("components.navigation.developers")
  end

  click_on CreateFixture.developer_name
  click_on t("developers.collection.contacts")
  click_on t("contacts.collection.create")

  within ".contacts" do
    fill_in "contact_first_name", with: ContactFixture.first_name
  end

  within ".contacts" do
    fill_in "contact_email", with: ContactFixture.email
  end

  click_on t("contacts.form.submit")
end

When(/^I create a division contact$/) do
  visit "/"

  within ".navbar" do
    click_on t("components.navigation.developers")
  end

  click_on t("developers.collection.divisions")
  within ".record-list" do
    click_on CreateFixture.division_name
  end

  click_on t("developers.collection.contacts")
  click_on t("contacts.collection.create")

  within ".contacts" do
    fill_in "contact_first_name", with: ContactFixture.first_name
  end

  within ".contacts" do
    fill_in "contact_email", with: ContactFixture.email
  end

  click_on t("contacts.form.submit")
end

Then(/^I should not be able to create a division contact$/) do
  visit "/"

  within ".navbar" do
    click_on t("components.navigation.developers")
  end

  within ".record-list" do
    click_on t("developers.collection.divisions")
  end

  click_on CreateFixture.division_name
  click_on t("developers.collection.contacts")

  expect(page).not_to have_content(t("contacts.collection.create"))
end

When(/^I create a development contact$/) do
  visit "/"

  within ".navbar" do
    click_on t("components.navigation.developers")
  end

  click_on t("developers.collection.divisions")
  within ".record-list" do
    click_on CreateFixture.division_name
  end

  click_on t("developers.collection.developments")
  within ".record-list" do
    click_on CreateFixture.division_development_name
  end

  click_on t("developers.collection.contacts")
  click_on t("contacts.collection.create")

  within ".contacts" do
    fill_in "contact_first_name", with: ContactFixture.first_name
  end

  within ".contacts" do
    fill_in "contact_email", with: ContactFixture.email
  end

  click_on t("contacts.form.submit")
end
