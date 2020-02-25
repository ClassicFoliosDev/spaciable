# frozen_string_literal: true

Given(/^I am a CF admin and there are many plots$/) do
  ResidentNotificationsFixture.create_permission_resources
  login_as CreateFixture.create_cf_admin
  CreateFixture.create_many_plots
end

Given(/^I am a Developer Admin (with CAS)* and there are many plots$/) do |cas|
  ResidentNotificationsFixture.create_permission_resources(cas: cas.present?)
  login_as CreateFixture.create_developer_admin(cas: cas.present?)
  CreateFixture.create_many_plots
end

Given(/^I am a Division Admin (with CAS)* and there are many plots$/) do |cas|
  ResidentNotificationsFixture.create_permission_resources(cas: cas.present?, division: true)
  login_as CreateFixture.create_division_admin(cas: cas.present?)
  CreateFixture.create_many_plots(CreateFixture.division_phase, CreateFixture.division_development)
end

Given(/^I am a Development Admin (with CAS)* and there are many plots$/) do |cas|
  ResidentNotificationsFixture.create_permission_resources(cas: cas.present?)
  login_as CreateFixture.create_development_admin(cas: cas.present?)
  CreateFixture.create_many_plots
end

Given(/^I am a Site Admin (with CAS)* and there are many plots$/) do |cas|
  ResidentNotificationsFixture.create_permission_resources(cas: cas.present?)
  login_as CreateFixture.create_site_admin(cas: cas.present?)
  CreateFixture.create_many_plots
end

When(/^I (CAS )*bulk edit the plots$/) do |cas|
  phase = $current_user.division_admin? ? CreateFixture.division_phase : CreateFixture.phase
  visit "/developments/#{phase.development.id}/phases/#{phase.id}"

  within ".tabs" do
    click_on t("phases.collection.bulk_edit")
  end

  within ".bulk-edit" do
    fill_in :phase_bulk_edit_list, with: "#{CreateFixture.phase_plot_name.to_i},179~181"
    find("#phase_bulk_edit_unit_type_id_check").set true
    select CreateFixture.another_unit_type_name, visible: false

    if(cas.present?)
      %i[phase_bulk_edit_reservation_release_date
         phase_bulk_edit_completion_release_date
         phase_bulk_edit_validity
         phase_bulk_edit_extended_access
         phase_bulk_edit_prefix
         phase_bulk_edit_building_name
         phase_bulk_edit_road_name
         phase_bulk_edit_postcode].each do |selector|
        expect(page).not_to have_selector "##{selector}"

        find("#phase_bulk_edit_progress_check").set true
        select t('activerecord.attributes.plot.progresses.complete_ready'), visible: false
        find("#phase_bulk_edit_completion_date_check").set true
        fill_in :phase_bulk_edit_completion_date, with: (Time.zone.now + 10.days)
      end
    else
      find("#phase_bulk_edit_reservation_release_date_check").set true
      fill_in :phase_bulk_edit_reservation_release_date, with: (Time.zone.now + 10.days)
      find("#phase_bulk_edit_completion_release_date_check").set true
      fill_in :phase_bulk_edit_completion_release_date, with: (Time.zone.now + 20.days)
      find("#phase_bulk_edit_validity_check").set true
      fill_in :phase_bulk_edit_validity, with: 23
      find("#phase_bulk_edit_extended_access_check").trigger('click')
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
    end

    click_on t("bulk_edit.index.submit")
    # Unit type is being updated - confirm the unit type dialog
    find(:xpath, "//button[@id='btn_confirm']").click

  end
end

Then(/^there is an error for plots that don't exist$/) do
  message = I18n.t("activerecord.errors.models.plot.attributes.base.missing")
  error_message = I18n.t("activerecord.errors.messages.bulk_edit_not_save", title: "Plot", numbers: "179", messages: message)
  within ".alert" do
    expect(page).to have_content error_message
  end
end

Then(/^there are errors for plots that don't exist and cannot be updated$/) do
  message = I18n.t("activerecord.errors.models.plot.attributes.base.missing")
  within ".alert" do
    expect(page).to have_content "Plots 179, 180, and 181 could not be saved: Plot not found and Unit Type changes are restricted until after the Completion work has been done by Classic Folios"
  end
end

Then(/^the selected plots are (CAS )*updated$/) do |cas|
  message = I18n.t("bulk_edit.create.success", plot_numbers: "180, 181, and #{CreateFixture.phase_plot_name}")
  within ".notice" do
    expect(page).to have_content message
  end

  test_plot_fields(180, cas.present?)
  test_plot_fields(181, cas.present?)
  test_plot_fields(CreateFixture.phase_plot_name, cas.present?)
end

Then(/^the released plot is CAS updated$/) do
  message = I18n.t("bulk_edit.create.success_one", plot_number: "#{CreateFixture.phase_plot_name}")
  within ".notice" do
    expect(page).to have_content message
  end

  test_plot_fields(CreateFixture.phase_plot_name, true)
end

Then(/^the unselected plots are not (CAS )*updated$/) do |cas|
  plot = Plot.find_by(number: 182)
  visit "/plots/#{plot.id}/edit"

  within ".edit_plot" do
    unit_type = page.find(".plot_unit_type")
    selected_unit_type = unit_type['innerHTML'].split("ui-selectmenu-text").last

    if cas.present?
      expect(find(".current-progress > span")).not_to have_content(t('activerecord.attributes.plot.progresses.complete_ready'))
    else
      expect(selected_unit_type).not_to have_content CreateFixture.another_unit_type_name
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
end

Then(/^the unreleased plots are not CAS updated$/) do
  (180..181).each do |plot_number|
    plot = Plot.find_by(number: plot_number)
    visit "/plots/#{plot.id}/edit"

    within ".edit_plot" do
      unit_type = page.find(".plot_unit_type")
      selected_unit_type = unit_type['innerHTML'].split("ui-selectmenu-text").last
      expect(find(".current-progress > span")).not_to have_content(t('activerecord.attributes.plot.progresses.complete_ready'))
    end
  end
end

Then(/^I can not edit bulk plots$/) do
  phase = $current_user.division_admin? ?  CreateFixture.division_phase : CreateFixture.phase
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
    expect(selected_unit_type).not_to have_content CreateFixture.another_unit_type_name
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

    find("#phase_bulk_edit_reservation_release_date_check").trigger('click')
    fill_in :phase_bulk_edit_reservation_release_date, with: ""
    find("#phase_bulk_edit_completion_release_date_check").trigger('click')
    fill_in :phase_bulk_edit_completion_release_date, with: ""
    # Not possible to set blank validity and extended access, use 0 instead
    find("#phase_bulk_edit_validity_check").trigger('click')
    fill_in :phase_bulk_edit_validity, with: 0
    find("#phase_bulk_edit_extended_access_check").trigger('click')
    fill_in :phase_bulk_edit_extended_access, with: 0

    find("#phase_bulk_edit_prefix_check").set true
    fill_in :phase_bulk_edit_prefix, with: ""
    find("#phase_bulk_edit_house_number_check").trigger('click')
    fill_in :phase_bulk_edit_house_number, with: ""
    find("#phase_bulk_edit_building_name_check").trigger('click')
    fill_in :phase_bulk_edit_building_name, with: ""
    find("#phase_bulk_edit_road_name_check").trigger('click')
    fill_in :phase_bulk_edit_road_name, with: ""
    find("#phase_bulk_edit_postcode_check").trigger('click')
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

    find("#phase_bulk_edit_unit_type_id_check").trigger('click')
    find("#phase_bulk_edit_validity_check").trigger('click')
    find("#phase_bulk_edit_extended_access_check").trigger('click')

    click_on t("bulk_edit.index.submit")
    find(:xpath, "//button[@id='btn_confirm']").click
  end
end

Then(/^I see an error for the mandatory fields$/) do
  within ".flash" do
    expect(page).to have_content I18n.t("activerecord.errors.messages.bulk_edit_field_blank", field_name: "Unit type")
    expect(page).to have_content I18n.t("activerecord.errors.messages.bulk_edit_field_blank", field_name: "Validity (Months)")
    expect(page).to have_content I18n.t("activerecord.errors.messages.bulk_edit_field_blank", field_name: "Extended Access (Months)")
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

def test_plot_fields(plot_number, cas)
  phase = $current_user.division_admin?  ? CreateFixture.division_phase : CreateFixture.phase
  plot = Plot.find_by(number: plot_number, phase: phase)
  visit "/plots/#{plot.id}/edit"

  within ".edit_plot" do
    unit_type = page.find(".plot_unit_type")
    selected_unit_type = unit_type['innerHTML'].split("ui-selectmenu-text").last

    expect(selected_unit_type).to have_content CreateFixture.another_unit_type_name
    expect(selected_unit_type).not_to have_content CreateFixture.unit_type_name

    if cas
      mode_in_date = (Time.zone.now + 10.days).to_date
      res_move_in_date = page.find(".plot_completion_date")
      expect(res_move_in_date['innerHTML']).to include mode_in_date.to_s
      expect(page).to have_content(t('activerecord.attributes.plot.progresses.complete_ready'))
    else
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
end

Given(/^I am a CF admin and there are many spanish plots$/) do

  ResidentNotificationsFixture.create_spanish_permission_resources
  login_as CreateFixture.create_cf_admin
  FactoryGirl.create(:unit_type, name: CreateFixture.another_unit_type_name, development: CreateFixture.spanish_development)
  FactoryGirl.create(:plot, phase: CreateFixture.spanish_phase, number: 180, postcode: "12345")
  FactoryGirl.create(:plot, phase: CreateFixture.spanish_phase, number: 181, postcode: "200111")
  FactoryGirl.create(:plot, unit_type: CreateFixture.unit_type, phase: CreateFixture.spanish_phase, house_number: "18A", postcode: "200200")
end

When(/^I bulk edit the spanish plots$/) do
  phase = CreateFixture.spanish_phase
  visit "/developments/#{phase.development.id}/phases/#{phase.id}"

  within ".tabs" do
    click_on t("phases.collection.bulk_edit")
  end

end

Then(/^I should see spanish address options$/) do
  
  ignore = Capybara.ignore_hidden_elements
  Capybara.ignore_hidden_elements = false
  
  expect(page).not_to have_selector('#phase_bulk_edit_postal_number')
  expect(page).not_to have_selector('#phase_bulk_edit_county')
  find_field(:phase_bulk_edit_house_number).should be_visible
  find_field(:phase_bulk_edit_building_name).should be_visible
  find_field(:phase_bulk_edit_road_name).should be_visible
  find_field(:phase_bulk_edit_postcode).should be_visible

  Capybara.ignore_hidden_elements = ignore

end
