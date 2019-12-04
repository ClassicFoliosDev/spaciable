# frozen_string_literal: true

Given(/^I have a developer with a development with unit types and a phase$/) do
  PhasePlotFixture.create_developer_with_development_and_unit_types_and_phase
end

When(/^I create a plot for the phase$/) do
  visit "/"

  within ".navbar" do
    click_on t("components.navigation.developers")
  end

  within "[data-developer='#{PhasePlotFixture.developer_id}']" do
    click_on t("developers.index.developments")
  end

  within "[data-development='#{PhasePlotFixture.development_id}']" do
    click_on t("developments.collection.phases")
  end

  within "[data-phase='#{PhasePlotFixture.phase.id}']" do
    click_on t("phases.collection.plots")
  end

  click_on t("components.empty_list.add", type_name: "Plot")
  within ".plot_unit_type" do
    select PhasePlotFixture.unit_type_name, visible: false
  end

  fill_in "plot_list", with: PhasePlotFixture.plot_number
  click_on t("plots.form.submit")
end

When(/^I specify "([^"]*)" range of plots$/) do |validity|
  visit "/"

  within ".navbar" do
    click_on t("components.navigation.developers")
  end

  within "[data-developer='#{PhasePlotFixture.developer_id}']" do
    click_on t("developers.index.developments")
  end

  within "[data-development='#{PhasePlotFixture.development_id}']" do
    click_on t("developments.collection.phases")
  end

  within "[data-phase='#{PhasePlotFixture.phase.id}']" do
    click_on t("phases.collection.plots")
  end

  click_on t("components.empty_list.add", type_name: "Plot")
  within ".plot_unit_type" do
    select PhasePlotFixture.unit_type_name, visible: false
  end

  fill_in "plot_list", with: validity == "valid" ? PhasePlotFixture.valid_plot_range_numbers : PhasePlotFixture.invalid_plot_range_numbers
  click_on t("plots.form.submit")
end

Then(/^I see an invalid range message$/) do
  expect(page).to have_content(PhasePlotFixture.invalid_plot_range)
end

Then(/^I see a range of new plots$/) do
  PhasePlotFixture.valid_plot_range_numbers.each do |plot|
    expect(page).to have_content(plot)
  end
end

Then(/^I should see the created phase plot$/) do
  expect(page).to have_content(PhasePlotFixture.plot_number)
  expect(page).to have_content(PhasePlotFixture.unit_type_name)
end

When(/^I update the phase plot$/) do
  within ".record-list" do
    find("[data-action='edit']").click
  end

  sleep 0.3 # these fields do not get filled in without the sleep :(
  PhasePlotFixture.update_attrs.each do |attr, value|
    fill_in "plot_#{attr}", with: value
  end

  within ".plot_unit_type" do
    select PhasePlotFixture.updated_unit_type_name, visible: false
  end

  click_on t("plots.form.submit")
end

Then(/^I should see the updated phase plot$/) do
  within ".section-title" do
    expect(page).to have_content(PhasePlotFixture.update_attrs[:number])
    expect(page).to have_content(I18n.t("activerecord.attributes.plot.progresses.soon"))
    expect(page).not_to have_content(I18n.t("activerecord.attributes.plot.progresses.complete_ready"))
    expect(page).not_to have_content(I18n.t("activerecord.attributes.plot.progresses.completed"))
    expect(page).not_to have_content(I18n.t("activerecord.attributes.plot.progresses.roof_on"))
  end

  within ".section-data" do
    expect(page).to have_content(PhasePlotFixture.updated_unit_type_name)
    expect(page).to have_content(PhasePlotFixture.updated_house_number)
    expect(page).to have_content(PhasePlotFixture.plot_building_name)
    expect(page).to have_content(PhasePlotFixture.plot_road_name)
    expect(page).to have_content(PhasePlotFixture.plot_postcode)
    expect(page).to have_content(PhaseFixture.address_update_attrs[:locality])
    expect(page).to have_content(PhaseFixture.address_update_attrs[:city_name])
    expect(page).to have_content(PhaseFixture.address_update_attrs[:county_name])

    expect(page).not_to have_content(PlotFixture.unit_type_name)
  end
end

When(/^I delete the phase plot$/) do
  phase = Phase.find_by(name: PhasePlotFixture.phase_name)

  visit "/developments/#{phase.development.id}/phases/#{phase.id}?active_tab=plots"

  delete_scope = "[data-plot='#{PhasePlotFixture.updated_plot.id}']"
  delete_and_confirm!(scope: delete_scope)
end

Then(/^I should see that the phase plot deletion completed successfully$/) do
  success_flash = t(
    "plots.destroy.success",
    plot_name: PhasePlotFixture.updated_plot_name
  )
  expect(page).to have_content(success_flash)

  within ".breadcrumbs" do
    expect(page).to have_content(PhasePlotFixture.phase_name)
  end

  within ".plots" do
    expect(page).not_to have_content PhasePlotFixture.updated_plot_name
  end
end

Given(/^I have configured the phase address$/) do
  visit "/developers"

  within ".record-list" do
    click_on PhasePlotFixture.developer_name
  end

  within ".tabs" do
    click_on t("developers.collection.developments")
  end

  within ".record-list" do
    click_on PhasePlotFixture.development_name
  end

  within ".tabs" do
    click_on t("developments.collection.phases")
  end

  within ".record-list" do
    find("[data-action='edit']").click
  end

  PhaseFixture.address_update_attrs.each do |attr, value|
    fill_in "phase_address_attributes_#{attr}", with: value
  end

  click_on t("phases.form.submit")
end

Given(/^I have created a plot for the phase$/) do
  click_on t("components.empty_list.add", type_name: "Plot")

  fill_in "plot_list", with: PhasePlotFixture.update_attrs[:number]
  within ".plot_unit_type" do
    select PhasePlotFixture.unit_type_name, visible: false
  end

  click_on t("phases.form.submit")
end

Then(/^I should see the phase address has not been changed$/) do
  visit "/developers"

  within ".record-list" do
    click_on PhasePlotFixture.developer_name
  end

  within ".tabs" do
    click_on t("developers.collection.developments")
  end

  within ".record-list" do
    click_on PhasePlotFixture.development_name
  end

  within ".tabs" do
    click_on t("developments.collection.phases")
  end

  within ".record-list" do
    click_on PhasePlotFixture.phase_name
  end

  within ".section-data" do
    PhaseFixture.address_update_attrs.each do |_attr, value|
      expect(page).to have_content(value)
    end
  end
end

When(/^I delete the plot with resident$/) do
  phase = CreateFixture.phase
  visit "/developments/#{phase.development.id}/phases/#{phase.id}?active_tab=plots"

  plot = CreateFixture.phase_plot
  delete_and_confirm!(scope: "[data-plot='#{plot.id}']")
end

Then(/^I should see the progress update is not sent to the former resident$/) do
  within ".notice" do
    expect(page).to have_content("and 0 residents have been notified")
  end

  resident_notifications = ResidentNotification.all
  expect(resident_notifications.count).to be_zero

  # Should not be a resident notification, but there will be a closed account email
  emails = ActionMailer::Base.deliveries
  expect(emails.length).to eq 1

  expect(emails.first.subject).to eq I18n.t("devise.mailer.close_account.title")
end

Given(/^I have a spanish developer with a development with unit types and a phase$/) do
  PhasePlotFixture.create_spanish_developer_with_development_and_unit_types_and_phase
end

When(/^I create a plot for the spanish phase$/) do
  visit "/"

  within ".navbar" do
    click_on t("components.navigation.developers")
  end

  within "[data-developer='#{PhasePlotFixture.spanish_developer_id}']" do
    click_on t("developers.index.developments")
  end

  within "[data-development='#{PhasePlotFixture.spanish_development_id}']" do
    click_on t("developments.collection.phases")
  end

  within "[data-phase='#{PhasePlotFixture.spanish_phase.id}']" do
    click_on t("phases.collection.plots")
  end

  click_on t("components.empty_list.add", type_name: "Plot")
  within ".plot_unit_type" do
    select PhasePlotFixture.unit_type_name, visible: false
  end

  fill_in "plot_list", with: PhasePlotFixture.plot_number
end

Then(/^I should see the spanish plot address format$/) do

  ignore = Capybara.ignore_hidden_elements
  Capybara.ignore_hidden_elements = false

  expect(page).not_to have_selector('#plot_county')
  find_field(:plot_house_number).should be_visible
  find_field(:plot_building_name).should be_visible
  find_field(:plot_road_name).should be_visible
  find_field(:plot_postcode).should be_visible
  find_field(:plot_locality).should be_visible
  find_field(:plot_city).should be_visible

  Capybara.ignore_hidden_elements = ignore
end
