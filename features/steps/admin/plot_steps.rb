# frozen_string_literal: true
Given(/^I have a developer with a development with unit types$/) do
  PlotFixture.create_developer_with_development_and_unit_types
end

When(/^I create a plot for the development$/) do
  visit "/"

  within ".navbar" do
    click_on t("components.navigation.developers")
  end

  within "[data-developer='#{PlotFixture.developer_id}']" do
    click_on t(".developers.index.developments")
  end

  within "[data-development='#{PlotFixture.development_id}']" do
    click_on t(".developments.developments.plots")
  end

  click_on t("plots.index.add")

  fill_in "plot_number", with: PlotFixture.plot_number
  click_on t("plots.form.submit")
end

Then(/^I should see the created plot$/) do
  expect(page).to have_content(PlotFixture.developer_name)

  click_on PlotFixture.plot_name

  screen_value = find("[name='plot[number]']").value
  expect(screen_value).to eq(PlotFixture.plot_number)

  click_on t("plots.edit.back")
end

When(/^I update the plot$/) do
  find("[data-action='edit']").click

  sleep 0.3 # these fields do not get filled in without the sleep :(
  fill_in "plot[number]", with: PlotFixture.updated_plot_number
  fill_in "plot[prefix]", with: PlotFixture.update_attrs[:prefix]

  within ".plot_unit_type" do
    select PlotFixture.updated_unit_type_name, visible: false
  end

  click_on t("plots.form.submit")
end

Then(/^I should see the updated plot$/) do
  # On the index page
  within ".record-list" do
    expect(page).to have_content(PlotFixture.updated_plot_name)
  end

  # and on the edit page
  click_on PlotFixture.updated_plot_name

  prefix_value = find("[name='plot[prefix]']").value
  expect(prefix_value).to eq(PlotFixture.update_attrs[:prefix])

  number_value = find("[name='plot[number]']").value
  expect(number_value).to eq(PlotFixture.update_attrs[:number])

  within ".plot_unit_type" do
    expect(page).to have_content(PlotFixture.updated_unit_type_name)
    expect(page).not_to have_content(PlotFixture.unit_type_name)
  end
end

When(/^I delete the plot$/) do
  click_on t("plots.edit.back")

  delete_and_confirm!
end

Then(/^I should see that the plot deletion completed successfully$/) do
  success_flash = t(
    "plots.destroy.archive.success",
    plot_name: PlotFixture.updated_plot_name
  )
  expect(page).to have_content(success_flash)

  within ".breadcrumbs" do
    expect(page).to have_content(PlotFixture.development_name)
  end

  within ".record-list" do
    expect(page).to have_no_content PlotFixture.updated_plot_name
  end
end
