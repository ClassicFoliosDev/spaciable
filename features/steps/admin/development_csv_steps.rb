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
    page.assert_selector(:css, "a[href='/download_development_csv']")
    first(:link, "Download").click
  end
end

# First check the alert when no file is selected, then upload a file
Then(/^I can upload a CSV$/) do
  within ".csv-upload" do
    click_on t("development_csv.index.upload_csv")
  end
  within ".alert" do
    expect(page).to have_content t("development_csv.errors.no_file")
  end

  csv_full_path = FileFixture.file_path + FileFixture.csv_file_name
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
Then(/^I see the error messages$/) do
  within ".alert" do
    phase = PhasePlotFixture.phase_name
    expect(page).to have_content(t("development_csv.errors.phase_error_strip", phase: "First"))
    expect(page).to have_content(t("development_csv.errors.plot_error_strip", plots: "#{phase}: 9"))
    expect(page).to have_content(t("development_csv.errors.unit_errors_strip", unit: "#{phase}: Penthouse"))
    expect(page).to have_content(t("development_csv.errors.progress_error_strip", progress: "#{phase}: wrong_progress"))
    expect(page).to have_content(t("development_csv.errors.duplicate_plots_strip", plots: "#{phase}: 4"))
    expect(page).to have_content(t("development_csv.errors.uprn_error_strip", uprns: "#{phase}: aaa, 1234567890123"))
  end
end

Then(/^I see the notify messages$/) do
  within ".notice" do
    phase = PhasePlotFixture.phase_name
    expect(page).to have_content(t("development_csv.errors.success", plots: "#{phase}: 4"))
  end
end

Then(/^the valid plot has been updated$/) do
  plot = Plot.find_by(number: 4)
  visit "/plots/#{plot.id}/edit"
  within ".edit_plot" do
    expect(page).to have_content(PhasePlotFixture.updated_unit_type_name)
  end
  within ".current-progress" do
    expect(page).to have_content(t("activerecord.attributes.plot.progresses.roof_on"))
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
  within ".current-progress" do
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
