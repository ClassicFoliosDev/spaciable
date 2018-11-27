# frozen_string_literal: true

When(/^I navigate to the analytics page$/) do
  visit "/"

  within ".navbar-menu" do
    click_on t("components.navigation.reports")
  end
end

Then(/^I export all developers CSV$/) do
  within ".report-buttons" do
    click_on t("admin.analytics.new.all")
    click_on t("admin.analytics.new.all")
  end
end

Then(/^I export a developer CSV$/) do
  within ".report-buttons" do
    click_on t("admin.analytics.new.developer")
  end
end

Then(/^I export a development CSV$/) do
  within ".report-buttons" do
    click_on t("admin.analytics.new.development")
    click_on t("admin.analytics.new.development")
  end
end

Then(/^I can not export a developer CSV$/) do
  within ".report-buttons" do
    disabled_btns = page.all("[disabled]").map(&:value)

    expect(disabled_btns).to match_array [t("admin.analytics.new.developer"), t("admin.analytics.new.development")]
  end
end

Then(/^I can not export a development CSV$/) do
  within ".report-buttons" do
    disabled_btns = page.all("[disabled]").map(&:value)

    expect(disabled_btns).to match_array [t("admin.analytics.new.development")]
  end
end

When(/^I select the developer$/) do
  plot = ResidentNotificationsFixture.development_plot

  within ".report-targets" do
    select_from_selectmenu :report_developer_id, with: plot.developer
  end
end

Then(/^I select the development$/) do
  plot = ResidentNotificationsFixture.development_plot

  within ".report-targets" do
    select_from_selectmenu :report_development_id, with: plot.development
  end
end

Then(/^the developer CSV contents are correct$/) do
  header = page.response_headers['Content-Disposition']
  expect(header).to match /^attachment/
  expect(header).to include "#{CreateFixture.developer_name.parameterize.underscore}.csv"

  filename = header.partition('filename="').last.chomp('"')
  path = Rails.root.join("tmp/#{filename}")

  csv = CSV.read(path, headers: true)
  expect(csv.size).to eq 4

  development_row = csv[0]
  expect(development_row["Name"]).to eq CreateFixture.development_name
  expect(development_row["Parent"]).to eq CreateFixture.developer_name

  division_row = csv[1]
  expect(division_row["Name"]).to eq CreateFixture.division_name
  expect(division_row["Parent"]).to eq CreateFixture.developer_name

  division_development_row = csv[2]
  expect(division_development_row["Name"]).to eq CreateFixture.division_development_name
  expect(division_development_row["Parent"]).to eq CreateFixture.division_name

  development_row = csv[3]
  expect(development_row["Name"]).to eq AnalyticsFixture.development_name
  expect(development_row["Parent"]).to eq CreateFixture.division_name
end

Then(/^the development CSV contents are correct$/) do
  header = page.response_headers['Content-Disposition']
  expect(header).to match /^attachment/
  expect(header).to include "#{CreateFixture.development_name.parameterize.underscore}.csv"

  filename = header.partition('filename="').last.chomp('"')
  path = Rails.root.join("tmp/#{filename}")

  csv = CSV.read(path, headers: true)
  expect(csv.size).to eq(4)

  development = Development.find_by(name: CreateFixture.development_name)

  expect(csv[0]["Development name"]).to eq development.to_s
  expect(csv[1]["Plot number"]).to eq "Plot 200"
  expect(csv[1]["Resident email"]).to eq "200@residents.com"
  expect(csv[2]["Plot number"]).to eq "Plot 200"
  expect(csv[2]["Resident email"]).to eq "multiple_plot@residents.com"
  expect(csv[3]["Plot number"]).to eq "Plot 200"
  expect(csv[3]["Resident email"]).to eq "unactivated@resident.com"
end

Then(/^the all developer CSV contents are correct$/) do
  header = page.response_headers['Content-Disposition']
  expect(header).to match /^attachment/
  expect(header).to include "all_developers_summary.csv"

  filename = header.partition('filename="').last.chomp('"')
  path = Rails.root.join("tmp/#{filename}")

  csv = CSV.read(path, headers: true)
  expect(csv.size).to eq 4

  division_row = csv[0]
  expect(division_row["Name"]).to eq CreateFixture.division_name
  expect(division_row["Parent"]).to eq CreateFixture.developer_name
  expect(division_row["BestArea4Me enabled"]).to eq "true"

  developer_row = csv[1]
  expect(developer_row["Parent"]).to eq "DEVELOPER"
  expect(developer_row["BestArea4Me enabled"]).to eq "false"

  second_developer_row = csv[2]
  expect(second_developer_row["Parent"]).to eq AnalyticsFixture.developer_name
  expect(second_developer_row["Name"]).to eq AnalyticsFixture.division_name

  third_developer_row = csv[3]
  expect(third_developer_row["Name"]).to eq AnalyticsFixture.other_developer_name
  expect(third_developer_row["Parent"]).to eq "DEVELOPER"
end

Given(/^there is another developer with a division and development$/) do
  developer = FactoryGirl.create(:developer, company_name: AnalyticsFixture.developer_name, house_search: nil)
  FactoryGirl.create(:division, division_name: AnalyticsFixture.division_name, developer: developer)
  FactoryGirl.create(:development, name: AnalyticsFixture.development_name, developer: developer)
end

Given(/^there is another developer with no children$/) do
  FactoryGirl.create(:developer, company_name: AnalyticsFixture.other_developer_name, house_search: nil)
end

Given(/^there is another development for the division$/) do
  FactoryGirl.create(:development, name: AnalyticsFixture.development_name, division: CreateFixture.division)
end

Then(/^I export billing CSV$/) do
  within ".report-buttons" do
    click_on t("admin.analytics.new.billing")
  end
end

Then(/^the all billing CSV contents are correct$/) do
  header = page.response_headers['Content-Disposition']
  expect(header).to include "billing"

  filename = header.partition('filename="').last.chomp('"')
  path = Rails.root.join("tmp/#{filename}")

  csv = CSV.read(path, headers: true)

  expect(csv.size).to eq(1)
  expect(csv[0]["Plot"]).to eq "Plot 200"
end
