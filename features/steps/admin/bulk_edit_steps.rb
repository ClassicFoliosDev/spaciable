# frozen_string_literal: true

Given(/^I am a CF admin and there are many plots$/) do
  ResidentNotificationsFixture.create_permission_resources
  CreateFixture.create_division_phase_plot
  login_as CreateFixture.create_cf_admin
  FactoryGirl.create(:unit_type, name: "Another", development: CreateFixture.development)
  FactoryGirl.create(:plot, phase: CreateFixture.phase, number: 180, road_name: "Bulk Edit Road A", prefix: "Apartment", postcode: "AA 1AB")
  FactoryGirl.create(:plot, phase: CreateFixture.phase, number: 181, road_name: "Bulk Edit Road B", prefix: "Flat")
  FactoryGirl.create(:plot, unit_type: CreateFixture.unit_type, phase: CreateFixture.phase, number: 182, road_name: "Bulk Edit Road C", prefix: "Flat", house_number: "18A", postcode: "AA 1AB")
end

When(/^I bulk edit the plots$/) do
  phase = CreateFixture.phase
  visit "/developments/#{phase.development.id}/phases/#{phase.id}"

  within ".tabs" do
    click_on t("phases.collection.bulk_edit")
  end

  within ".bulk-edit" do
    fill_in :phase_bulk_edit_range_from, with: 179
    fill_in :phase_bulk_edit_range_to, with: 181
    fill_in :phase_bulk_edit_list, with: CreateFixture.phase_plot_name.to_i

    find("#phase_bulk_edit_unit_type_id_check").set true
    select "Another", visible: false
    find("#phase_bulk_edit_reservation_release_date_check").set true
    fill_in :phase_bulk_edit_reservation_release_date, with: (Time.zone.now + 10.days)
    find("#phase_bulk_edit_completion_release_date_check").set true
    fill_in :phase_bulk_edit_completion_release_date, with: (Time.zone.now + 20.days)
    find("#phase_bulk_edit_validity_check").set true
    fill_in :phase_bulk_edit_validity, with: 23
    find("#phase_bulk_edit_extended_access_check").set true
    fill_in :phase_bulk_edit_extended_access, with: 6

    find("#phase_bulk_edit_prefix_check").set true
    fill_in :phase_bulk_edit_prefix, with: "Bulk edit"
    find("#phase_bulk_edit_copy_plot_numbers").set true
    find("#phase_bulk_edit_building_name_check").set true
    fill_in :phase_bulk_edit_building_name, with: "Bulky Building"
    find("#phase_bulk_edit_road_name_check").set true
    fill_in :phase_bulk_edit_road_name, with: "New Bulky Road"
    find("#phase_bulk_edit_postcode_check").set true
    fill_in :phase_bulk_edit_postcode, with: "SO40 1AB"

    click_on t("bulk_edit.index.submit")
  end
end

Then(/^there is an error for plots that don't exist$/) do
  message = I18n.t("activerecord.errors.models.plot.attributes.base.missing")
  error_message = I18n.t("activerecord.errors.messages.bulk_edit_not_save", title: "Plot", numbers: "179", messages: message)
  within ".alert" do
    expect(page).to have_content error_message
  end
end

Then(/^the selected plots are updated$/) do
  message = I18n.t("bulk_edit.create.success", plot_numbers: "180, 181, and #{CreateFixture.phase_plot_name}")
  within ".notice" do
    expect(page).to have_content message
  end

  test_plot_fields(180)
  test_plot_fields(181)
  test_plot_fields(CreateFixture.phase_plot_name)
end

Then(/^the unselected plots are not updated$/) do
  plot = Plot.find_by(number: 182)
  visit "/plots/#{plot.id}/edit"

  within ".edit_plot" do
    unit_type = page.find(".plot_unit_type")
    selected_unit_type = unit_type['innerHTML'].split("ui-selectmenu-text").last

    expect(selected_unit_type).not_to have_content "Another"
    expect(selected_unit_type).to have_content plot.unit_type.to_s

    validity = page.find(".validity")
    expect(validity['innerHTML']).to include "27"

    prefix = page.find(".plot_prefix")
    expect(prefix['innerHTML']).not_to include "Bulk edit"

    house_number = page.find(".plot_house_number")
    expect(house_number['innerHTML']).to include "18A"

    road_name = page.find(".plot_road_name")
    expect(road_name['innerHTML']).to include "Bulk Edit Road C"

    postcode = page.find( ".plot_postcode")
    expect(postcode['innerHTML']).to include "AA 1AB"
  end
end

Then(/^I can not edit bulk plots$/) do
  phase = CreateFixture.phase

  phase = CreateFixture.division_phase if phase.nil?

  visit "/developments/#{phase.development.id}/phases/#{phase.id}"

  within ".tabs" do
    expect(page).not_to have_content t("phases.collection.bulk_edit")
  end

  visit "/phases/#{phase.id}/bulk_edit"

  expect(current_path).to eq "/"
  expect(page).to have_content t("dashboard.section.notifications.title")
end

When(/^I set the postal number for plots$/) do
  phase = CreateFixture.phase
  visit "/phases/#{phase.id}/bulk_edit"

  within ".bulk-edit" do
    fill_in :phase_bulk_edit_list, with: CreateFixture.phase_plot_name.to_i

    find("#phase_bulk_edit_house_number_check").set true
    fill_in :phase_bulk_edit_house_number, with: 61

    click_on t("bulk_edit.index.submit")
  end
end

Then(/^the selected plots have the new postal number$/) do
  plot = CreateFixture.phase_plot

  message = I18n.t("bulk_edit.create.success_one", plot_number: plot.number)
  within ".notice" do
    expect(page).to have_content message
  end

  visit "/plots/#{plot.id}/edit"

  within ".edit_plot" do
    house_number = page.find(".plot_house_number")
    expect(house_number['innerHTML']).to include "61"
  end
end

Given(/^I am a CF admin and there is a plot with all fields set$/) do
  ResidentNotificationsFixture.create_permission_resources
  login_as CreateFixture.create_cf_admin
  FactoryGirl.create(:plot,
      unit_type: CreateFixture.unit_type,
      phase: CreateFixture.phase,
      number: 17,
      reservation_release_date: (Time.zone.now).to_date,
      completion_release_date: (Time.zone.now + 12.days).to_date,
      validity: 20,
      extended_access: 12,
      prefix: "Unset Me",
      house_number: "17B",
      building_name: "Unset building",
      road_name: "Unset lane",
      postcode: "AA 3AB"
      )
end

When(/^I bulk edit the plot but do not set checkboxes$/) do
  phase = CreateFixture.phase
  visit "/developments/#{phase.development.id}/phases/#{phase.id}"

  within ".tabs" do
    click_on t("phases.collection.bulk_edit")
  end

  within ".bulk-edit" do
    fill_in :phase_bulk_edit_list, with: 17

    fill_in :phase_bulk_edit_reservation_release_date, with: (Time.zone.now + 10.days)
    fill_in :phase_bulk_edit_completion_release_date, with: (Time.zone.now + 20.days)
    fill_in :phase_bulk_edit_validity, with: 23
    fill_in :phase_bulk_edit_extended_access, with: 6

    fill_in :phase_bulk_edit_prefix, with: "Bulk edit"
    fill_in :phase_bulk_edit_house_number, with: "71D"
    fill_in :phase_bulk_edit_building_name, with: "Bulky Building"
    fill_in :phase_bulk_edit_road_name, with: "New Bulky Road"
    fill_in :phase_bulk_edit_postcode, with: "SO40 1AB"

    click_on t("bulk_edit.index.submit")
  end
end

Then(/^the plot fields are all unchanged$/) do
  within ".alert" do
    expect(page).to have_content I18n.t("activerecord.errors.messages.bulk_edit_no_fields")
  end

  plot = Plot.find_by(number: 17)
  visit "/plots/#{plot.id}/edit"

  within ".edit_plot" do
    unit_type = page.find(".plot_unit_type")
    selected_unit_type = unit_type['innerHTML'].split("ui-selectmenu-text").last
    expect(selected_unit_type).not_to have_content "Another"
    expect(selected_unit_type).to have_content plot.unit_type.to_s

    reservation_date = Time.zone.now.to_date
    wrong_reservation_date = (Time.zone.now + 10.days).to_date
    res_rel_date = page.find(".plot_reservation_release_date")
    expect(res_rel_date['innerHTML']).to include reservation_date.to_s
    expect(res_rel_date['innerHTML']).not_to include wrong_reservation_date.to_s

    completion_date = (Time.zone.now + 12.days).to_date
    wrong_completion_date = (Time.zone.now + 20.days).to_date
    comp_rel_date = page.find(".plot_completion_release_date")
    expect(comp_rel_date['innerHTML']).to include completion_date.to_s
    expect(comp_rel_date['innerHTML']).not_to include wrong_completion_date.to_s

    validity = page.find(".validity")
    expect(validity['innerHTML']).to include "20"

    prefix = page.find(".plot_prefix")
    expect(prefix['innerHTML']).to include "Unset Me"

    house_number = page.find(".plot_house_number")
    expect(house_number['innerHTML']).to include "17B"

    building_name = page.find(".plot_building_name")
    expect(building_name['innerHTML']).to include "Unset building"

    road_name = page.find(".plot_road_name")
    expect(road_name['innerHTML']).to include "Unset lane"

    postcode = page.find( ".plot_postcode")
    expect(postcode['innerHTML']).to include "AA 3AB"
  end
end

When(/^I bulk edit the plot and set optional fields to empty$/) do
  phase = CreateFixture.phase
  visit "/developments/#{phase.development.id}/phases/#{phase.id}"

  within ".tabs" do
    click_on t("phases.collection.bulk_edit")
  end

  within ".bulk-edit" do
    fill_in :phase_bulk_edit_list, with: 17

    find("#phase_bulk_edit_reservation_release_date_check").set true
    fill_in :phase_bulk_edit_reservation_release_date, with: ""
    find("#phase_bulk_edit_completion_release_date_check").set true
    fill_in :phase_bulk_edit_completion_release_date, with: ""
    # Not possible to set blank validity and extended access, use 0 instead
    find("#phase_bulk_edit_validity_check").set true
    fill_in :phase_bulk_edit_validity, with: 0
    find("#phase_bulk_edit_extended_access_check").set true
    fill_in :phase_bulk_edit_extended_access, with: 0

    find("#phase_bulk_edit_prefix_check").set true
    fill_in :phase_bulk_edit_prefix, with: ""
    find("#phase_bulk_edit_house_number_check").set true
    fill_in :phase_bulk_edit_house_number, with: ""
    find("#phase_bulk_edit_building_name_check").set true
    fill_in :phase_bulk_edit_building_name, with: ""
    find("#phase_bulk_edit_road_name_check").set true
    fill_in :phase_bulk_edit_road_name, with: ""
    find("#phase_bulk_edit_postcode_check").set true
    fill_in :phase_bulk_edit_postcode, with: ""

    click_on t("bulk_edit.index.submit")
  end
end

When(/^I bulk edit the plot and set mandatory fields to empty$/) do
  phase = CreateFixture.phase
  visit "/developments/#{phase.development.id}/phases/#{phase.id}"

  within ".tabs" do
    click_on t("phases.collection.bulk_edit")
  end

  within ".bulk-edit" do
    fill_in :phase_bulk_edit_list, with: 17

    find("#phase_bulk_edit_unit_type_id_check").set true
    find("#phase_bulk_edit_validity_check").set true
    find("#phase_bulk_edit_extended_access_check").set true

    click_on t("bulk_edit.index.submit")
  end
end

Then(/^I see an error for the mandatory fields$/) do
  within ".flash" do
    expect(page).to have_content I18n.t("activerecord.errors.messages.bulk_edit_field_blank", field_name: "Unit type")
    expect(page).to have_content I18n.t("activerecord.errors.messages.bulk_edit_field_blank", field_name: "Validity (months)")
    expect(page).to have_content I18n.t("activerecord.errors.messages.bulk_edit_field_blank", field_name: "Extended access (months)")
  end
end


Then(/^the optional plot fields are unset$/) do
  plot = Plot.find_by(number: 17)

  message = I18n.t("bulk_edit.create.success_one", plot_number: plot.number)
  within ".notice" do
    expect(page).to have_content message
  end

  visit "/plots/#{plot.id}/edit"

  within ".edit_plot" do
    reservation_date = Time.zone.now.to_date
    res_rel_date = page.find(".plot_reservation_release_date")
    expect(res_rel_date['innerHTML']).not_to include reservation_date.to_s

    completion_date = (Time.zone.now + 12.days).to_date
    comp_rel_date = page.find(".plot_completion_release_date")
    expect(comp_rel_date['innerHTML']).not_to include completion_date.to_s

    validity = page.find(".validity")
    expect(validity['innerHTML']).not_to include "20"
    expect(validity['innerHTML']).to include "0"

    prefix = page.find(".plot_prefix")
    expect(prefix['innerHTML']).not_to include "Unset Me"

    house_number = page.find(".plot_house_number")
    expect(house_number['innerHTML']).not_to include "17B"

    building_name = page.find(".plot_building_name")
    expect(building_name['innerHTML']).not_to include "Unset building"

    road_name = page.find(".plot_road_name")
    expect(road_name['innerHTML']).not_to include "Unset lane"

    postcode = page.find( ".plot_postcode")
    expect(postcode['innerHTML']).not_to include "AA 3AB"
  end

end

def test_plot_fields(plot_number)
  phase = CreateFixture.phase
  plot = Plot.find_by(number: plot_number, phase: phase)
  visit "/plots/#{plot.id}/edit"

  within ".edit_plot" do
    unit_type = page.find(".plot_unit_type")
    selected_unit_type = unit_type['innerHTML'].split("ui-selectmenu-text").last

    expect(selected_unit_type).to have_content "Another"
    expect(selected_unit_type).not_to have_content CreateFixture.unit_type_name

    reservation_date = (Time.zone.now + 10.days).to_date
    res_rel_date = page.find(".plot_reservation_release_date")
    expect(res_rel_date['innerHTML']).to include reservation_date.to_s

    completion_date = (Time.zone.now + 20.days).to_date
    comp_rel_date = page.find(".plot_completion_release_date")
    expect(comp_rel_date['innerHTML']).to include completion_date.to_s

    validity = page.find(".validity")
    expect(validity['innerHTML']).to include "23"

    extension = page.find(".extended_access")
    expect(extension['innerHTML']).to include "6"

    prefix = page.find(".plot_prefix")
    expect(prefix['innerHTML']).to include "Bulk edit"

    house_number = page.find(".plot_house_number")
    expect(house_number['innerHTML']).to include plot_number.to_s

    building_name = page.find(".plot_building_name")
    expect(building_name['innerHTML']).to include "Bulky Building"

    road_name = page.find(".plot_road_name")
    expect(road_name['innerHTML']).to include "New Bulky Road"

    postcode = page.find( ".plot_postcode")
    expect(postcode['innerHTML']).to include "SO40 1AB"
  end
end
