# frozen_string_literal: true

Given(/^I have plots$/) do
  DevelopmentCsvFixture.create_plots
end

When(/^I navigate to the development page$/) do
  developer = Developer.find_by(company_name: CreateFixture.developer_name)
  development = Development.find_by(name: CreateFixture.development_name)
  visit "/developers/#{developer.id}/developments/#{development.id}"
end

When(/^I click on the Upload CSV tab$/) do
  within ".tabs" do
    click_on(I18n.t("developments.collection.development_csv"))
  end
end

Then(/^I can download a CSV template$/) do
  within ".csv-download" do
    page.assert_selector(:css, "a[href='/developments/#{CreateFixture.developer.id}/download_development_csv']")
    first(:link, "Download").click
  end
end

Then(/^I can upload the (.*) file$/) do |csv_file|
  csv_full_path = FileFixture.file_path + csv_file
  within ".csv-upload" do
    attach_file("plot_file",
      File.absolute_path(csv_full_path),
      visible: false)
    click_on t("development_csv.index.upload_csv")
  end
end

# Since allowed completion release dates are set between a particular range, the test_csv file
# used in this test will need updating when the date set is outside of the specified range
# this will be on 12 April 2021
Then(/^I see the (.*) error messages$/) do |user|
  within ".alert" do
    phase = PhasePlotFixture.phase_name
    expect(page).to have_content(t("development_csv.errors.phase_error_strip", phase: "First"))
    expect(page).to have_content(t("development_csv.errors.plot_error_strip", plots: "#{phase}: 9"))
    expect(page).to have_content(t("development_csv.errors.unit_errors_strip", unit: "#{phase}: Penthouse")) if user == "admin"
    expect(page).to have_content(t("development_csv.errors.duplicate_plots_strip", plots: "#{phase}: 4"))
    expect(page).to have_content(t("development_csv.errors.uprn_error_strip", uprns: "First: aaa #{phase}: 1234567890123"))
  end
end

Then(/^I see the (.*) notify messages$/) do |user|
  within ".notice" do
    phase = PhasePlotFixture.phase_name
    expect(page).to have_content(t("development_csv.errors.success", plots: "#{phase}: #{user == "admin" ? '4' : '3, 4' }"))
  end
end

Then(/^the valid (.*) plot has been updated$/) do |user|
  plot = Plot.find_by(number: 4)
  visit "/plots/#{plot.id}/edit"
  within ".edit_plot" do
    expect(page).to have_content(PhasePlotFixture.updated_unit_type_name) if user == "admin"
  end
  expect(find_field("plot_prefix").value).to eq "Flat"
  expect(find_field("plot_house_number").value).to eq "9"
  expect(find_field("plot_building_name").value).to eq "The Glen"
  expect(find_field("plot_road_name").value).to eq "Cranbury Road"
  expect(find_field("plot_postcode").value).to eq "SO50 5TL"
  expect(find_field("plot_completion_date").value).to eq "2021-10-12"
end

Then(/^the invalid plot has not been updated$/) do
  plot = Plot.find_by(number: 3)
  visit "/plots/#{plot.id}/edit"
  within ".edit_plot" do
    expect(page).to have_content(PhasePlotFixture.unit_type_name)
  end
  within ".build-progress .ui-selectmenu-text" do
    expect(page).to have_content(t("activerecord.attributes.plot.progresses.soon"))
  end
end

When(/^I navigate to my development$/) do
  within ".navbar" do
    click_on I18n.t("components.navigation.my_development")
  end
end

Then(/^I cannot see the Upload CSV tab$/) do
  within ".tabs" do
    expect(page).to_not have_content(I18n.t("developments.collection.development_csv"))
  end
end
