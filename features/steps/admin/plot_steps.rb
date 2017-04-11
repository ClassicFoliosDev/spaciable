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
    click_on t("developers.index.developments")
  end

  within "[data-development='#{PlotFixture.development_id}']" do
    click_on t("developments.collection.plots")
  end

  click_on t("plots.collection.add")
  fill_in "plot_list", with: PlotFixture.plot_number

  within ".plot_unit_type" do
    select PlotFixture.unit_type_name, visible: false
  end

  click_on t("plots.form.submit")
end

Then(/^I should see the created plot$/) do
  expect(page).to have_content(PlotFixture.developer_name)
  click_on PlotFixture.plot_name

  expect(page).to have_content(PlotFixture.plot_number)
  expect(page).to have_content(PlotFixture.unit_type_name)

  click_on t("plots.edit.back")
end

When(/^I update the plot$/) do
  within ".record-list" do
    find("[data-action='edit']").click
  end

  sleep 0.3 # these fields do not get filled in without the sleep :(

  PlotFixture.update_attrs.each do |attr, value|
    fill_in "plot_#{attr}", with: value
  end

  within ".plot_unit_type" do
    select PlotFixture.updated_unit_type_name, visible: false
  end

  click_on t("plots.form.submit")
end

Then(/^I should see the updated plot$/) do
  within ".record-list" do
    click_on PlotFixture.plot_name
  end

  within ".section-title" do
    expect(page).to have_content(PlotFixture.update_attrs[:prefix])
    expect(page).to have_content(PlotFixture.update_attrs[:number])
  end

  within ".section-data" do
    expect(page).to have_content(PlotFixture.updated_unit_type_name)
    expect(page).to have_content(PlotFixture.updated_house_number)
    expect(page).to have_content(PlotFixture.plot_building_name)
    expect(page).to have_content(PlotFixture.plot_road_name)
    expect(page).to have_content(PlotFixture.plot_postcode)
    expect(page).to have_content(PhaseFixture.development_address_attrs[:city_name])
    expect(page).to have_content(PhaseFixture.development_address_attrs[:county_name])

    expect(page).not_to have_content(PlotFixture.unit_type_name)
  end
end

When(/^I delete the plot$/) do
  goto_development_show_page

  within ".tabs" do
    click_on t("developments.collection.plots")
  end

  plot_id = PlotFixture.plot_id
  delete_and_confirm!(scope: "[data-plot='#{plot_id}']")
end

Then(/^I should see that the plot deletion completed successfully$/) do
  success_flash = t(
    "plots.destroy.success",
    plot_name: PlotFixture.plot_name
  )
  expect(page).to have_content(success_flash)

  within ".breadcrumbs" do
    expect(page).to have_content(PlotFixture.development_name)
  end

  expect(page).not_to have_content(".record-list")

  within ".empty" do
    expect(page).to have_content t("components.empty_list.add", type_name: Plot.model_name.human.downcase)
  end
end

Given(/^I have created a plot for the development$/) do
  goto_development_show_page

  within ".tabs" do
    click_on t("developments.collection.plots")
  end

  click_on t("plots.collection.add")

  fill_in "plot_prefix", with: PlotFixture.update_attrs[:prefix]
  fill_in "plot_list", with: PlotFixture.plot_number
  within ".plot_unit_type" do
    select PlotFixture.unit_type_name, visible: false
  end

  click_on t("phases.form.submit")
end

When(/^I preview the plot$/) do
  within ".record-list" do
    click_on PlotFixture.plot_name
  end

  sleep 0.2

  within ".above-footer" do
    click_on t("plots.show.preview")
  end
end

Then(/^I see the plot preview page$/) do
  sleep 0.3

  within_frame("rails_iframe") do
    expect(page).to have_content(t("layouts.homeowner.nav.dashboard"))
    expect(page).to have_content(t("layouts.homeowner.nav.my_home"))
    expect(page).to have_content(t("layouts.homeowner.nav.how_to"))
    expect(page).to have_content(t("layouts.homeowner.nav.contacts"))

    expect(page).to have_content(t("homeowners.dashboard.show.my_home_title"))
    expect(page).to have_content(t("homeowners.dashboard.show.my_home_view_more"))

    expect(page).to have_content(DeveloperFixture.developer_address_attrs[:building_name])
    expect(page).to have_content(DeveloperFixture.developer_address_attrs[:road_name])
    expect(page).to have_content(DeveloperFixture.developer_address_attrs[:postcode])

    expect(page).to have_content(t("homeowners.dashboard.show.contacts_title"))
    expect(page).to have_content(t("homeowners.dashboard.show.contacts_view_more"))

    expect(page).to have_content(t("homeowner.dashboard.cards.faqs.title"))
    expect(page).to have_content(t("homeowner.dashboard.cards.faqs.view_more"))
  end
end

Then(/^I can see my library$/) do
  within_frame("rails_iframe") do
    click_on t("homeowner.dashboard.cards.library.view_more")
  end

  sleep 0.2
  within_frame("rails_iframe") do
    expect(page).to have_content(t("homeowners.library.index.title"))
  end
end

Then(/^I can see my appliances$/) do
  within_frame("rails_iframe") do
    click_on t("layouts.homeowner.sub_nav.rooms")
  end

  sleep 0.2
  within_frame("rails_iframe") do
    expect(page).to have_content(DeveloperFixture.developer_address_attrs[:building_name])
    expect(page).to have_content(DeveloperFixture.developer_address_attrs[:road_name])
    expect(page).to have_content(DeveloperFixture.developer_address_attrs[:postcode])
  end
end

Then(/^I can see my contacts$/) do
  within_frame("rails_iframe") do
    click_on t("layouts.homeowner.nav.contacts")
  end

  sleep 0.2
  within_frame("rails_iframe") do
    expect(page).to have_content(t("homeowners.contacts.index.title"))
  end
end

Then(/^I can see my faqs$/) do
  within_frame("rails_iframe") do
    click_on t("layouts.homeowner.sub_nav.faqs")
  end

  sleep 0.2
  within_frame("rails_iframe") do
    expect(page).to have_content(t("homeowners.faqs.index.title"))
  end
end
