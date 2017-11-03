# frozen_string_literal: true

Given(/^I am logged in as a CF Admin wanting to manage plot rooms$/) do
  PlotRoomsFixture.setup

  login_as CreateFixture.cf_admin
  visit "/"
end

When(/^I go to review the plot rooms$/) do
  goto_plot_show_page
  click_on t("plots.collection.rooms")
end

Then(/^I should see the plots unit type rooms$/) do
  PlotRoomsFixture.unit_type_room_names.each do |name|
    within(".record-list") do
      expect(page).to have_content(name)
    end
  end
end

When(/^I add a new plot room$/) do
  click_on t("rooms.collection.add", parent_type: "Plot", parent_name: CreateFixture.plot_name)

  fill_in :room_name, with: PlotRoomsFixture.new_plot_room_name
  click_on t("plots.rooms.form.submit")
end

Then(/^I should see the new plot room$/) do
  within(".record-list") do
    expect(page).to have_content(PlotRoomsFixture.new_plot_room_name)
  end
end

When(/^I update one of the default unit type rooms$/) do
  within ".record-list" do
    click_on PlotRoomsFixture.unit_type_room_names.first
  end

  edit_btn = find("[data-action='edit']", visible: false) # coz not use poltegeist
  edit_btn.click

  fill_in :room_name, with: PlotRoomsFixture.updated_plot_room_name
  click_on t("plots.rooms.form.submit")
end

Then(/^I should see the updated plot room$/) do
  within(".record-list") do
    expect(page).to have_content(PlotRoomsFixture.updated_plot_room_name)
    expect(page).not_to have_content(PlotRoomsFixture.unit_type_room_names.first)
  end
end

When(/^I delete one of the default unit type rooms$/) do
  within ".breadcrumbs" do
    click_on CreateFixture.plot_name
  end

  within ".tabs" do
    click_on t("plots.collection.rooms")
  end

  template_room_id = PlotRoomsFixture.template_room_id_to_delete

  delete_and_confirm!(scope: "[data-room='#{template_room_id}']")
end

Then(/^I should not see the deleted default unit type room$/) do
  within ".record-list" do
    expect(page).not_to have_content(PlotRoomsFixture.template_room_to_delete)
  end
end

When(/^I review the plots unit type rooms$/) do
  within(".breadcrumbs") do
    click_on CreateFixture.development_name
  end

  click_on t("developments.collection.unit_types")
  click_on CreateFixture.unit_type_name

  click_on t("unit_types.collection.rooms")
end

Then(/^I should see the unchanged unit type rooms$/) do
  within(".record-list") do
    PlotRoomsFixture.unit_type_room_names.each do |name|
      expect(page).to have_content(name)
    end

    expect(page).not_to have_content(PlotRoomsFixture.new_plot_room_name)
    expect(page).not_to have_content(PlotRoomsFixture.updated_plot_room_name)
  end

  within ".record-list" do
    click_on PlotRoomsFixture.template_room_to_add_finish
  end

  # sleep 0.4

  expect(page).not_to have_content(CreateFixture.finish_name)
  within ".empty" do
    expect(page).to have_content(t("components.empty_list.empty", type_names: "finishes"))
  end

  within ".tabs" do
    click_on t("rooms.collection.appliances")
  end

  expect(page).not_to have_content(CreateFixture.full_appliance_name)
  within ".empty" do
    expect(page).to have_content(t("components.empty_list.empty", type_names: "appliances"))
  end
end

When(/^I add a finish to one of the default unit type rooms$/) do
  within ".record-list" do
    click_on PlotRoomsFixture.template_room_to_add_finish
  end

  within ".empty" do
    click_on t("rooms.form.add_finish")
  end

  within ".search-finish" do
    fill_in "finish_room_search_finish_text", with: CreateFixture.finish_name
    find(".search-finish-btn", visible: true).trigger(:click)
  end

  within ".finish" do
    select_from_selectmenu :finishes, with: CreateFixture.finish_name
  end

  within ".form-actions-footer" do
    click_on t("plots.rooms.form.submit")
  end
end

Then(/^I should see the new plot room with the finish$/) do
  within ".breadcrumbs" do
    expect(page).to have_content(t("developments.collection.plots"))
  end

  within ".record-list" do
    expect(page).to have_content(CreateFixture.finish_name)
  end
end

When(/^I add an appliance to one of the default unit type rooms$/) do
  within ".tabs" do
    click_on t("rooms.collection.appliances")
  end

  within ".empty" do
    click_on t("appliances.collection.create")
  end

  within ".search-appliance" do
    fill_in "appliance_room_search_appliance_text", with: CreateFixture.appliance_name
    find(".search-appliance-btn").click
  end

  within ".appliance" do
    select_from_selectmenu :appliances, with: CreateFixture.full_appliance_name
  end

  within ".form-actions-footer" do
    click_on t("plots.rooms.form.submit")
  end
end

Then(/^I should see the new plot room with the appliance$/) do
  within ".breadcrumbs" do
    expect(page).to have_content(t("developments.collection.plots"))
  end

  within ".record-list" do
    expect(page).to have_content(CreateFixture.full_appliance_name)
  end
end

Given(/^the unit type has an appliance and a finish$/) do
  PlotRoomsFixture.add_appliance_finish_to_unit_type_room
end

When(/^I remove an appliance from the plot$/) do
  within ".tabs" do
    click_on t("rooms.collection.appliances")
  end

  within ".record-list" do
    remove_btn = page.find ".remove", wait: 5
    remove_btn.click
  end
end

Then(/^I should see the finish remove is successful$/) do
  within ".breadcrumbs" do
    expect(page).to have_content(t("developments.collection.plots"))
  end

  within ".empty" do
    expect(page).to have_content(t("components.empty_list.empty", type_names: "finishes"))
  end

  expect(page).not_to have_content(".record-list")
end

Then(/^I should see the appliance remove is successful$/) do
  within ".breadcrumbs" do
    expect(page).to have_content(t("developments.collection.plots"))
  end

  within ".empty" do
    expect(page).to have_content(t("components.empty_list.empty", type_names: "appliances"))
  end

  expect(page).not_to have_content(".record-list")
end

When(/^I remove a finish from the plot$/) do
  goto_plot_show_page
  click_on t("plots.collection.rooms")

  within ".record-list" do
    click_on CreateFixture.room_name
  end

  within ".record-list" do
    remove_btn = page.find ".remove", wait: 5
    remove_btn.click
  end
end

Then(/^I should see the unit type still has appliance and finish$/) do
  goto_development_show_page

  within ".record-list" do
    click_on CreateFixture.unit_type_name
  end

  within ".tabs" do
    click_on t("unit_types.collection.rooms")
  end

  within ".record-list" do
    click_on CreateFixture.room_name
  end

  within ".record-list" do
    expect(page).to have_content(CreateFixture.finish_name)
  end

  within ".tabs" do
    click_on t("rooms.collection.appliances")
  end

  within ".record-list" do
    expect(page).to have_content(CreateFixture.full_appliance_name)
  end
end
