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

  click_on t("plots.collection.add")

  fill_in "plot_number", with: PhasePlotFixture.plot_number
  click_on t("plots.form.submit")
end

Then(/^I should see the created phase plot$/) do
  expect(page).to have_content(PhasePlotFixture.plot_number)
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
  # On the index page
  within ".record-list" do
    expect(page).to have_content(PhasePlotFixture.updated_plot_name)
  end

  # and on the show page
  click_on PhasePlotFixture.updated_plot_name

  within ".section-title" do
    expect(page).to have_content(PhasePlotFixture.update_attrs[:prefix])
    expect(page).to have_content(PhasePlotFixture.update_attrs[:number])
  end

  within ".section-data" do
    expect(page).to have_content(PhasePlotFixture.updated_unit_type_name)
    expect(page).to have_content(PhasePlotFixture.plot_building_name)
    expect(page).to have_content(PhasePlotFixture.plot_road_name)
    expect(page).to have_content(PhasePlotFixture.plot_postcode)
    expect(page).to have_content(PhaseFixture.address_update_attrs[:city_name])
    expect(page).to have_content(PhaseFixture.address_update_attrs[:county_name])

    expect(page).not_to have_content(PlotFixture.unit_type_name)
  end
end

When(/^I delete the phase plot$/) do
  visit "/developers"

  within ".developers" do
    click_on PhasePlotFixture.developer_name
  end

  within ".tabs" do
    click_on t("developers.collection.developments")
  end

  within ".developments" do
    click_on PhasePlotFixture.development_name
  end

  within ".tabs" do
    click_on t("developments.collection.phases")
  end

  within ".record-list" do
    click_on PhasePlotFixture.phase_name
  end

  delete_scope = "[data-plot='#{PhasePlotFixture.plot.id}']"
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

  within ".record-list" do
    expect(page).not_to have_content PhasePlotFixture.updated_plot_name
  end
end

Given(/^I have configured the phase address$/) do
  visit "/developers"

  within ".developers" do
    click_on PhasePlotFixture.developer_name
  end

  within ".tabs" do
    click_on t("developers.collection.developments")
  end

  within ".developments" do
    click_on PhasePlotFixture.development_name
  end

  within ".tabs" do
    click_on t("developments.collection.phases")
  end

  within ".phases" do
    find("[data-action='edit']").click
  end

  PhaseFixture.address_update_attrs.each do |attr, value|
    fill_in "phase_address_attributes_#{attr}", with: value
  end

  click_on t("phases.form.submit")
end

Given(/^I have created a plot for the phase$/) do
  click_on t("plots.collection.add")

  fill_in "plot_prefix", with: PlotFixture.update_attrs[:prefix]
  fill_in "plot_number", with: PlotFixture.updated_plot_number
  click_on t("phases.form.submit")
end

Then(/^I should see the phase address has not been changed$/) do
  visit "/developers"

  within ".developers" do
    click_on PhasePlotFixture.developer_name
  end

  within ".tabs" do
    click_on t("developers.collection.developments")
  end

  within ".developments" do
    click_on PhasePlotFixture.development_name
  end

  within ".tabs" do
    click_on t("developments.collection.phases")
  end

  within ".phases" do
    click_on PhasePlotFixture.phase_name
  end

  within ".section-data" do
    PhaseFixture.address_update_attrs.each do |_attr, value|
      expect(page).to have_content(value)
    end
  end
end
