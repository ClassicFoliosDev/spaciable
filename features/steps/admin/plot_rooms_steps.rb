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
  click_on t("plots.rooms.collection.add", parent_type: "Plot", parent_name: CreateFixture.plot_name)

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
end
