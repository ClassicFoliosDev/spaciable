# frozen_string_literal: true
Given(/^I have a developer with a development and a unit type$/) do
  CreateFixture.create_unit_type
end

And(/^I have seeded the database$/) do
  load "#{Rails.root}/db/seeds.rb"
end

When(/^I create a room with no room name$/) do
  visit "/"

  within ".navbar" do
    click_on t("components.navigation.developers")
  end

  within "[data-developer='#{CreateFixture.developer_id}']" do
    click_on t("developers.index.developments")
  end

  within "[data-development='#{CreateFixture.development_id}']" do
    click_on t("developments.collection.unit_types")
  end

  click_on t("unit_types.collection.rooms")

  click_on t("rooms.collection.add")
  click_on t("rooms.form.submit")
end

Then(/^I should see the room failure message$/) do
  failure_flash_room = "Room Name " + t("activerecord.errors.messages.blank")
  # "Room Name can't be blank"
  within ".submission-errors" do
    expect(page).to have_content(failure_flash_room)
  end
end

When(/^I create a room with no finish category/) do
  fill_in "room_name", with: CreateFixture.room_name
  fill_in "room_finishes_attributes_0_name", with: CreateFixture.finish_name
  click_on t("rooms.form.submit")
end

Then(/^I should see the category failure message$/) do
  failure_flash_finishes_category = Finish.model_name.human.pluralize + " " +
                                    Finish.human_attribute_name(:finish_category).downcase +
                                    t("activerecord.errors.messages.required")
  failure_flash_finish_category = Finish.human_attribute_name(:finish_category) +
                                  t("activerecord.errors.messages.required")

  expect(page).to have_content(failure_flash_finishes_category)
  expect(page).to have_content(failure_flash_finish_category)

  expect(page).not_to have_content CreateFixture.room_name
end

When(/^I create a room for the development$/) do
  fill_in "room_name", with: CreateFixture.room_name
  within ".nested-fields" do
    fill_in t("finishes.form.name"), with: CreateFixture.finish_name
  end

  select RoomFixture.finish_attrs[:finish_category_id],
         from: "room_finishes_attributes_0_finish_category_id"

  click_on t("rooms.form.submit")
end

Then(/^I should see the created room$/) do
  expect(page).to have_content(CreateFixture.room_name)

  click_on CreateFixture.room_name

  click_on t("unit_types.edit.back")
end

When(/^I update the room and finish$/) do
  find("[data-action='edit']").click

  fill_in "room[name]", with: RoomFixture.updated_room_name

  select RoomFixture.finish_attrs[:finish_type_id],
         from: "room_finishes_attributes_0_finish_type_id"

  select RoomFixture.finish_attrs[:manufacturer_id],
         from: "room_finishes_attributes_0_manufacturer_id"

  click_on t("unit_types.form.submit")
end

Then(/^I should see the updated room$/) do
  # On the show page
  success_flash = t(
    "controller.success.update",
    name: RoomFixture.updated_room_name
  )
  expect(page).to have_content(success_flash)
  within ".section-title" do
    expect(page).to have_content(RoomFixture.updated_room_name)
  end

  click_on CreateFixture.finish_name

  expect(page).to have_content RoomFixture.finish_attrs[:finish_category_id]
  expect(page).to have_content RoomFixture.finish_attrs[:finish_type_id]
  expect(page).to have_content RoomFixture.finish_attrs[:manufacturer_id]
end

When(/^I add a second finish$/) do
  visit "/"

  within ".navbar" do
    click_on t("components.navigation.developers")
  end

  within "[data-developer='#{CreateFixture.developer_id}']" do
    click_on t("developers.index.developments")
  end

  within "[data-development='#{CreateFixture.development_id}']" do
    click_on t("developments.collection.unit_types")
  end

  click_on Room.model_name.human

  click_on CreateFixture.room_name

  find("[data-action='edit']").click

  click_on t("rooms.form.add_finish")

  finish_names = page.all(".room_finishes_name")
  first_finish = finish_names[0]
  second_finish = finish_names[1]

  within first_finish do
    fill_in t("finishes.form.name"), with: CreateFixture.finish_name
  end

  within second_finish do
    fill_in t("finishes.form.name"), with: RoomFixture.second_finish_name
  end

  categories = page.all(".finish-category")
  category = categories[0]

  within category do
    finish_arrow = page.find ".ui-icon"
    finish_arrow.click

    category_ul = page.find ".ui-menu"

    category_list = category_ul.all("li")
    category_list[1].click
  end

  category = categories[1]
  within category do
    finish_arrow = page.find ".ui-icon"
    finish_arrow.click

    category_ul = page.find ".ui-menu"

    category_list = category_ul.all("li")
    category_list.find { |node| node.text == "Sanitaryware" }.click
    sleep 0.3
  end

  finish_types = page.all(".finish-type")
  finish_type = finish_types[1]

  within finish_type do
    finish_arrow = page.find ".ui-icon"
    finish_arrow.click

    type_ul = page.find ".ui-menu"

    type_list = type_ul.all("li")
    type_list.find { |node| node.text == "Shower Unit" }.click
    sleep 0.3
  end

  manufacturers = page.all(".manufacturer")
  manufacturer = manufacturers[1]

  within manufacturer do
    finish_arrow = page.find ".ui-icon"
    finish_arrow.click
    manuf_ul = page.find ".ui-menu"

    manuf_list = manuf_ul.all("li")
    manuf_list.find { |node| node.text == "Aqualisa" }.click
  end

  click_on t("rooms.form.submit")
end

Then(/^I should see the room with two finishes$/) do
  success_flash = t(
    "controller.success.update",
    name: CreateFixture.room_name
  )
  expect(page).to have_content(success_flash)

  expect(page).to have_content CreateFixture.finish_name
  expect(page).to have_content RoomFixture.second_finish_name

  click_on RoomFixture.second_finish_name

  RoomFixture.second_finish_attrs.each do |_attr, value|
    expect(page).to have_content(value)
  end
end

And(/^I have created a room$/) do
  CreateFixture.create_room
end

When(/^I add an appliance$/) do
  visit "/"

  within ".navbar" do
    click_on t("components.navigation.developers")
  end

  within "[data-developer='#{CreateFixture.developer_id}']" do
    click_on t("developers.index.developments")
  end

  within "[data-development='#{CreateFixture.development_id}']" do
    click_on t("developments.collection.unit_types")
  end

  click_on Room.model_name.human

  click_on CreateFixture.room_name

  within ".tabs" do
    click_on t("rooms.collection.appliances")
  end

  click_on t("appliances.collection.add_appliance_room")

  within ".appliance-category" do
    category_arrow = page.find ".ui-icon"
    category_arrow.click

    category_ul = page.find ".ui-menu"

    category_list = category_ul.all("li")
    category_list.find { |node| node.text == ApplianceFixture.category }.click
  end

  within ".appliance-manufacturer" do
    manufacturer_arrow = page.find ".ui-icon"
    manufacturer_arrow.click

    manufacturer_ul = page.find ".ui-menu"

    manufacturer_list = manufacturer_ul.all("li")
    manufacturer_list.find { |node| node.text == ApplianceFixture.manufacturer }.click
  end

  within ".appliance" do
    appliance_arrow = page.find ".ui-icon"
    appliance_arrow.click

    appliance_ul = page.find ".ui-menu"

    appliance_list = appliance_ul.all("li")
    appliance_list.find { |node| node.text == ApplianceFixture.updated_name }.click
  end

  click_on t("rooms.form.submit")
end

Then(/^I should see the room with an appliance$/) do
  success_flash = t(
    "controller.success.update",
    name: CreateFixture.room_name
  )
  expect(page).to have_content(success_flash)

  within ".record-list" do
    expect(page).to have_content ApplianceFixture.updated_name
  end
end

Then(/^I should not see any duplicates$/) do
  within ".record-list" do
    expect(page).to have_content(ApplianceFixture.updated_name, count: 1)
  end
end

When(/^I remove an appliance$/) do
  within ".appliances" do
    find(".remove").click
  end
end

Then(/^I should see the room with no appliance$/) do
  success_flash = t(
    "rooms.remove_appliance.success",
    appliance_name: ApplianceFixture.updated_name,
    room_name: CreateFixture.room_name
  )

  expect(page).to have_content(success_flash)

  within ".record-list" do
    expect(page).not_to have_content ApplianceFixture.updated_name
  end
end

When(/^I delete the room$/) do
  room_path = "/unit_types/1/rooms"
  visit room_path

  delete_and_confirm!
end

Then(/^I should see the room deletion complete successfully$/) do
  success_flash = t(
    "controller.success.destroy",
    name: CreateFixture.room_name
  )
  expect(page).to have_content(success_flash)

  within ".breadcrumbs" do
    expect(page).to have_content(CreateFixture.development_name)
  end

  within ".record-list" do
    expect(page).not_to have_content CreateFixture.room_name
  end
end
