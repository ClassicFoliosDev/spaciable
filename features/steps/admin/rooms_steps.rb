# frozen_string_literal: true
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

  click_on t("rooms.collection.add", parent_type: UnitType.model_name, parent_name: CreateFixture.unit_type_name)
  click_on t("rooms.form.submit")
end

Then(/^I should see the room failure message$/) do
  failure_flash_room = "Room Name " + t("activerecord.errors.messages.blank")
  # "Room Name can't be blank"
  within ".submission-errors" do
    expect(page).to have_content(failure_flash_room)
  end
end

When(/^I create a room$/) do
  fill_in "room_name", with: CreateFixture.room_name

  click_on t("rooms.form.submit")
end

Then(/^I should see the created room$/) do
  expect(page).to have_content(CreateFixture.room_name)

  click_on CreateFixture.room_name

  click_on t("unit_types.edit.back")
end

When(/^I update the room$/) do
  find("[data-action='edit']").click

  fill_in "room[name]", with: RoomFixture.updated_room_name

  select t("activerecord.attributes.room.icon_names.dining_room"),
         from: "room[icon_name]"

  click_on t("rooms.form.submit")
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

  within ".section-data" do
    image_div = page.find(".room-icon")
    expect(image_div["style"]).to have_content("Hoozzi_icon_dining_room")
  end
end

When(/^I add a finish$/) do
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

  click_on CreateFixture.room_name

  within ".tabs" do
    click_on t("rooms.collection.finishes")
  end

  click_on t("finishes.collection.add_finish")

  select_from_selectmenu :finish_category, with: CreateFixture.finish_category_name
  select_from_selectmenu :finish_type, with: CreateFixture.finish_type_name

  select_from_selectmenu :finishes, with: CreateFixture.finish_name

  click_on t("rooms.form.submit")
end

Then(/^I should see the room with a finish$/) do
  success_flash = t(
    "controller.success.update",
    name: CreateFixture.room_name
  )
  expect(page).to have_content(success_flash)

  within ".record-list" do
    expect(page).to have_content CreateFixture.finish_name
  end
end

Then(/^I should see a duplicate finish error$/) do
  duplicate_flash = t(
    "activerecord.errors.messages.taken",
    name: CreateFixture.finish_name
  )
  expect(page).to have_content(duplicate_flash)
end

When(/^I remove a finish$/) do
  click_on t("rooms.form.back")

  within ".record-list" do
    find(".remove").click
  end
end

Then(/^I should see the room with no finish$/) do
  success_flash = t(
    "rooms.remove_finish.success",
    finish_name: CreateFixture.finish_name,
    room_name: CreateFixture.room_name
  )

  expect(page).to have_content(success_flash)

  within ".record-list" do
    expect(page).not_to have_content CreateFixture.finish_name
  end
end

And(/^I have created a room$/) do
  CreateFixture.create_developer_with_development
  CreateFixture.create_unit_type
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

  select_from_selectmenu :appliance_category, with: CreateFixture.appliance_category_name
  select_from_selectmenu :manufacturer, with: CreateFixture.appliance_manufacturer_name
  select_from_selectmenu :appliances, with: CreateFixture.appliance_name

  click_on t("rooms.form.submit")
end

Then(/^I should see the room with an appliance$/) do
  success_flash = t(
    "controller.success.update",
    name: CreateFixture.room_name
  )
  expect(page).to have_content(success_flash)

  within ".record-list" do
    expect(page).to have_content CreateFixture.appliance_name
  end
end

Then(/^I should see a duplicate error$/) do
  duplicate_flash = t(
    "activerecord.errors.messages.taken",
    name: ApplianceFixture.updated_name
  )
  expect(page).to have_content(duplicate_flash)
end

When(/^I remove an appliance$/) do
  click_on t("rooms.form.back")

  within ".record-list" do
    find(".remove").click
  end
end

Then(/^I should see the room with no appliance$/) do
  success_flash = t(
    "rooms.remove_appliance.success",
    appliance_name: CreateFixture.appliance_name,
    room_name: CreateFixture.room_name
  )

  expect(page).to have_content(success_flash)

  within ".record-list" do
    expect(page).not_to have_content CreateFixture.appliance_name
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
