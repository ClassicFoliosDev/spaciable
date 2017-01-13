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

  within "[data-phase='#{PhasePlotFixture.phase_id}']" do
    click_on t("phases.index.plots")
  end

  click_on t("phases.plots.index.add")

  fill_in "plot_number", with: PhasePlotFixture.plot_number
  click_on t("phases.plots.form.submit")
end

Then(/^I should see the created phase plot$/) do
  expect(page).to have_content(PhasePlotFixture.phase_name)

  click_on PhasePlotFixture.plot_name

  screen_value = find("[name='plot[number]']").value
  expect(screen_value).to eq(PhasePlotFixture.plot_number)

  click_on t("phases.plots.edit.back")
end

When(/^I update the phase plot$/) do
  find("[data-action='edit']").click

  sleep 0.3 # these fields do not get filled in without the sleep :(
  fill_in "plot[number]", with: PhasePlotFixture.updated_plot_number
  fill_in "plot[prefix]", with: PhasePlotFixture.update_attrs[:prefix]

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

  # and on the edit page
  click_on PhasePlotFixture.updated_plot_name

  prefix_value = find("[name='plot[prefix]']").value
  expect(prefix_value).to eq(PhasePlotFixture.update_attrs[:prefix])

  number_value = find("[name='plot[number]']").value
  expect(number_value).to eq(PhasePlotFixture.update_attrs[:number])

  within ".plot_unit_type" do
    expect(page).to have_content(PhasePlotFixture.updated_unit_type_name)
    expect(page).not_to have_content(PhasePlotFixture.unit_type_name)
  end
end

When(/^I delete the phase plot$/) do
  click_on t("phases.plots.edit.back")

  delete_and_confirm!
end

Then(/^I should see that the phase plot deletion completed successfully$/) do
  success_flash = t(
    "phases.plots.destroy.archive.success",
    plot_name: PhasePlotFixture.updated_plot_name
  )
  expect(page).to have_content(success_flash)

  within ".breadcrumbs" do
    expect(page).to have_content(PhasePlotFixture.phase_name)
  end

  within ".record-list" do
    expect(page).to have_no_content PhasePlotFixture.updated_plot_name
  end
end
