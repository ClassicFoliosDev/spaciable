# frozen_string_literal: true
Given(/^I have a developer with a development and a unit type$/) do
  CreateFixture.create_unit_type
end

And(/^I have seeded the database$/) do
  load "#{Rails.root}/db/seeds.rb"
end

When(/^I create a room for the development$/) do
  visit "/"

  within ".navbar" do
    click_on t("components.navigation.developers")
  end

  within "[data-developer='#{CreateFixture.developer_id}']" do
    click_on t(".developers.index.developments")
  end

  within "[data-development='#{CreateFixture.development_id}']" do
    click_on t(".developments.developments.unit_types")
  end

  click_on t(".unit_types.index.rooms")

  click_on t("rooms.index.add")

  fill_in "room_name", with: CreateFixture.room_name
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

  select RoomFixture.finish_attrs[:finish_category_id],
         from: "room_finishes_attributes_0_finish_category_id"

  select RoomFixture.finish_attrs[:finish_type_id],
         from: "room_finishes_attributes_0_finish_type_id"

  select RoomFixture.finish_attrs[:manufacturer_id],
         from: "room_finishes_attributes_0_manufacturer_id"

  click_on t("unit_types.form.submit")
end

Then(/^I should see the updated room$/) do
  # On the index page
  within ".record-list" do
    expect(page).to have_content(RoomFixture.updated_room_name)
  end

  # and on the edit page
  click_on RoomFixture.updated_room_name

  within ".room_finishes_finish_category" do
    expect(page).to have_select("", selected: RoomFixture.finish_attrs[:finish_category_id])
  end

  within ".room_finishes_finish_type" do
    expect(page).to have_select("", selected: RoomFixture.finish_attrs[:finish_type_id])
  end

  within ".room_finishes_manufacturer" do
    expect(page).to have_select("", selected: RoomFixture.finish_attrs[:manufacturer_id])
  end
end

When(/^I add a second finish$/) do
  room_path = "/unit_types/1/rooms"
  visit room_path
  find("[data-action='edit']").click

  click_on t(".rooms.form.add_finish")

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

  click_on t("unit_types.form.submit")
end

Then(/^I should see the room with two finishes$/) do
  find("[data-action='edit']").click

  sleep(0.2)
  finish_fields = page.all(".nested-fields")
  second_finish = finish_fields[1]

  within second_finish do
    RoomFixture.second_finish_attrs.each do |_attr, value|
      expect(page).to have_content(value)
    end
  end
end

And(/^I have created a room$/) do
  CreateFixture.create_room
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
    expect(page).to have_no_content CreateFixture.room_name
  end
end
