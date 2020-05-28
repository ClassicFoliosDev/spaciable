# frozen_string_literal: true


Given(/^I am logged in as a (CAS )*(.*) wanting to manage plot rooms$/) do |cas, role|
  PlotRoomsFixture.create_plot_rooms_as_cf_admin(cas: cas.present?)

  case role
    when "CF Admin"
      login_as CreateFixture.cf_admin
    when "Developer Admin"
      login_as CreateFixture.create_developer_admin(cas: cas.present?)
    when "Development Admin"
      login_as CreateFixture.create_development_admin(cas: cas.present?)
    when "Site Admin"
      login_as CreateFixture.create_site_admin(cas: cas.present?)
  end
end

When(/^I go to review the plot rooms$/) do
  plot = CreateFixture.phase_plot
  visit "/plots/#{plot.id}?active_tab=rooms"
end

Then(/^I should see the plots unit type rooms$/) do
  PlotRoomsFixture.unit_type_room_names.each do |name|
    within(".record-list") do
      expect(page).to have_content(name)
      check_belongs_to(name)
    end
  end
end

When(/^I add a new plot room$/) do
  click_on t("rooms.collection.add", name: "Plot #{CreateFixture.phase_plot_name}")

  fill_in :room_name, with: PlotRoomsFixture.new_plot_room_name
  click_on t("plots.rooms.form.submit")
end

Then(/^I should see the new plot room$/) do
  within(".record-list") do
    expect(page).to have_content(PlotRoomsFixture.new_plot_room_name)
    check_belongs_to(PlotRoomsFixture.new_plot_room_name)
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
    check_belongs_to(PlotRoomsFixture.updated_plot_room_name)
  end
end

When(/^I delete one of the default unit type rooms$/) do
  within ".breadcrumbs" do
    click_on CreateFixture.phase_plot_name
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
    click_on t("finishes.collection.assign")
  end

  within ".search-finish" do
    fill_in "finish_room_search_finish_text", with: CreateFixture.finish_name
    find(".search-finish-btn", visible: true).trigger(:click)
  end

  within ".finish" do
    finish = Finish.find_by(name: CreateFixture.finish_name)
    select_from_selectmenu :finishes, with: finish.full_name
  end

  within ".form-actions-footer" do
    click_on t("plots.rooms.form.submit")
  end
end

Then(/^I should see the new plot room with the finish$/) do
  within ".breadcrumbs" do
    expect(page).to have_content(CreateFixture.phase_name)
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
    expect(page).to have_content(CreateFixture.phase_name)
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
    expect(page).to have_content(CreateFixture.phase_plot_name)
  end

  within ".empty" do
    expect(page).to have_content(t("components.empty_list.empty", type_names: "finishes"))
  end

  expect(page).not_to have_content(".record-list")
end

Then(/^I should see the appliance remove is successful$/) do
  within ".breadcrumbs" do
    expect(page).to have_content(CreateFixture.phase_plot_name)
  end

  within ".empty" do
    expect(page).to have_content(t("components.empty_list.empty", type_names: "appliances"))
  end

  expect(page).not_to have_content(".record-list")
end

Then(/^I cannot edit or delete the appliance or finish$/) do

  within ".plot" do
    click_on CreateFixture.room_name
  end

  finish_row = find(:xpath, "//a[text()='#{CreateFixture.finish_name}']/parent::td/parent::tr")
  expect(finish_row).not_to have_selector("#edit-btn")
  expect(finish_row).not_to have_selector("#delete-btn")

  find(".tabs").click_on t("plots.rooms.collection.appliances")

  appliance_row = find(:xpath, "//a[contains(text(),'#{CreateFixture.appliance_name}')]/parent::td/parent::tr")
  expect(appliance_row).not_to have_selector("#edit-btn")
  expect(appliance_row).not_to have_selector("#delete-btn")
end

When(/^I remove a finish from the plot$/) do
  within ".plot" do
    click_on CreateFixture.room_name
  end

  within ".room" do
    remove_btn = page.find ".remove"
    remove_btn.click
  end
end

Then(/^I should see the unit type still has appliance and finish$/) do
  goto_development_show_page

  within ".tabs" do
    click_on t("developments.collection.unit_types")
  end

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

def check_belongs_to(roomname)
  room = Room.find_by(name: roomname)
  find("[data-room='#{room.id}']", text: room.plot_id.nil? ? "Unit Type" : "Plot")
end

And(/^I update the plot unit type with option (.*)$/) do |option|
  within ".breadcrumbs" do
    click_on CreateFixture.phase_plot_name
  end

  within ".section-header" do
    find("[data-action='edit']").click
  end

  within ".plot_unit_type" do
    select CreateFixture.second_unit_type_name, visible: false
    page.execute_script("$('.plot_unit_type > span.ui-selectmenu-button > span.ui-selectmenu-text').text('#{CreateFixture.second_unit_type_name}')")
  end

  success_flash = t(
    "controller.success.update",
    name: CreateFixture.phase_plot_name
  )

  # Set the hidden update option in case the dialog doesn't appear
  first('input#plot_ut_update_option', visible: false).set("'#{eval(option)}'")

  find("#submit-plot-btn").trigger('click')

  sleep 1
  if page.html.include?(success_flash) #
    break # choice dialog didn't appear - capybara fault
  else
    # Choose the required option in the dialog
    find(:xpath, "//input[@name='ut_option' and @value='#{eval(option)}']").trigger('click')
    find("#btn_confirm").click
  end

  expect(page).to have_content(success_flash)
end

And(/^I should see the plot rooms according to (.*)$/) do |option|

  click_on t("plots.collection.rooms")

  if (option == "UnitType::RESET")
    expect(page).to have_content(CreateFixture.lounge_name)
    expect(page).not_to have_content(PlotRoomsFixture.template_room_to_delete)
    expect(page).not_to have_content(PlotRoomsFixture.updated_plot_room_name)
    expect(page).not_to have_content(PlotRoomsFixture.new_plot_room_name)
    PlotRoomsFixture::UNIT_TYPE_ROOMS.each do |room_name|
      expect(page).not_to have_content(room_name)
    end
  else
  end

end


