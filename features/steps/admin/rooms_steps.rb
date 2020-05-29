# frozen_string_literal: true

When(/^I create a room with no room name$/) do
  navigate_to_unit_type

  click_on t("unit_types.collection.rooms")
  click_on t("components.empty_list.add", action: "Add", type_name: Room.model_name.human.titleize)

  click_on t("rooms.form.submit")
end

Then(/^I should see the room failure message$/) do
  failure_flash_room = "Room name " + t("activerecord.errors.messages.blank")
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
  within ".record-list" do
    find("[data-action='edit']").click
  end

  fill_in "room[name]", with: RoomFixture.updated_room_name

  select_from_selectmenu "room_icon_name", with: t("activerecord.attributes.room.icon_names.dining_room")

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
    image_div = page.find(".room-icon")
    expect(image_div["style"]).to have_content("icon_dining_room")
  end
end

When(/^I (search for and )*add a finish$/) do |search|
  navigate_to_unit_type

  click_on t("unit_types.collection.rooms")

  click_on CreateFixture.room_name

  within ".tabs" do
    click_on t("rooms.collection.finishes")
  end

  click_on t("components.empty_list.add", action: "Add", type_name: Finish.model_name.human.titleize)

  if search.present?
    full_name = Finish.find_by(name: CreateFixture.finish_name).full_name

    [CreateFixture.finish_type_name,
     CreateFixture.finish_name].each do |search|
      fill_in 'finish_room_search_finish_text', :with => CreateFixture.finish_type_name
      find('.search-finish-btn').click

      within "#finishes-button" do
        find('span', text: "Choose..")
      end
      select_from_selectmenu :finishes, with: full_name
    end
  else
    select_from_selectmenu :finish_category, with: CreateFixture.finish_category_name
    select_from_selectmenu :finish_type, with: CreateFixture.finish_type_name
    select_from_selectmenu :finishes, with: CreateFixture.finish_name
  end

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

  expect(page).not_to have_content(".record-list")

  within ".empty" do
    expect(page).to have_content %r{#{t("components.empty_list.add", action: "Add", type_name: Finish.model_name.human)}}i
  end
end

And(/^I have created a room$/) do  
  CreateFixture.create_developer_with_development
  CreateFixture.create_unit_type if !$current_user.division_admin?
  CreateFixture.create_division_development_unit_type if $current_user.division_admin?
  CreateFixture.create_room  
end

When(/^I add an appliance$/) do
  navigate_to_unit_type

  click_on Room.model_name.human

  click_on CreateFixture.room_name

  within ".tabs" do
    click_on t("rooms.collection.appliances")
  end

  click_on t("components.empty_list.add", action: "Add", type_name: Appliance.model_name.human.titleize)

  select_from_selectmenu :appliance_category, with: CreateFixture.appliance_category_name
  select_from_selectmenu :appliance_manufacturer, with: CreateFixture.appliance_manufacturer_name
  select_from_selectmenu :appliances, with: CreateFixture.full_appliance_name

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
    name: ApplianceFixture.updated_full_name
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
    appliance_name: CreateFixture.full_appliance_name,
    room_name: CreateFixture.room_name
  )
  expect(page).to have_content(success_flash)

  expect(page).not_to have_content(".record-list")

  within ".empty" do
    expect(page).to have_content %r{#{t("components.empty_list.add", action: "Add", type_name: Appliance.model_name.human)}}i
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
    expect(page).to have_content(CreateFixture.development_name) if !$current_user.division_admin?
    expect(page).to have_content(CreateFixture.division_development_name) if $current_user.division_admin?
  end

  expect(page).not_to have_content(".record-list")

  within ".empty" do
    expect(page).to have_content %r{#{t("components.empty_list.add", action: "Add", type_name: Room.model_name.human)}}i
  end
end

def navigate_to_unit_type
  visit "/"

  development_id = CreateFixture.development.id
  case $current_user.role
    when "cf_admin"
      within ".navbar" do
        click_on t("components.navigation.developers")
      end
      within "[data-developer='#{CreateFixture.developer_id}']" do
        click_on t("developers.index.developments")
      end
    when "developer_admin"
      within ".navbar" do
        click_on t("components.navigation.my_developer")
      end

      within ".tabs" do
        click_on t("developers.index.developments")
      end
    when "division_admin"
      development_id = CreateFixture.division_development.id

      within ".navbar" do
        click_on t("components.navigation.my_division")
      end

      within ".tabs" do
        click_on t("developers.index.developments")
      end
    when "development_admin", "site_admin"
      within ".navbar" do
        click_on t("components.navigation.my_development")
      end
  end

  case $current_user.role
    when "cf_admin", "developer_admin", "division_admin"
      within "[data-development='#{development_id}']" do
        visit find('a', text: "Unit Types")[:href]
      end
    when "development_admin", "site_admin"
      within ".tabs" do
        visit find('a', text: "Unit Types")[:href]
      end
  end
end