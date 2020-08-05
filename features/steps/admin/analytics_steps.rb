# frozen_string_literal: true

Given(/^there is a developer with plots$/) do
  AnalyticsFixture.create_first_developer
end

Given(/^there is another developer with plots$/) do
  AnalyticsFixture.create_second_developer
end

When(/^I navigate to the analytics page$/) do
  visit "/"

  within ".navbar-menu" do
    click_on t("components.navigation.reports")
  end
end

When(/^I export the Summary Report$/) do
  within ".report-buttons" do
    click_on t("admin.analytics.new.all")
  end
end

# this is currently not in use
Then(/^the Summary Report contents are correct$/) do
  header = page.response_headers['Content-Disposition']
  expect(header).to match /^attachment/
  expect(header).to include "all_developers_summary.csv"

  filename = header.partition('filename="').last.chomp('"')
  path = Rails.root.join("tmp/#{filename}")

  csv = CSV.read(path, headers: true)

  expect(csv.size).to eq 3

  first_row = csv[0]
  expect(first_row["Developer"]).to eq CreateFixture.developer_name
  expect(first_row["Division"]).to eq CreateFixture.division_name
  expect(first_row["Developments Count"]).to eq "1"
  expect(first_row["BestArea4Me Enabled"]).to eq "Yes"
  expect(first_row["Services Enabled"]).to eq "No"
  expect(first_row["Completion Plots"]).to eq "1"
  expect(first_row["Reservation Plots"]).to eq "0"

  third_row = csv[2]
  expect(third_row["Developer"]).to eq AnalyticsFixture.second_developer_name
  expect(third_row["Division"]).to eq AnalyticsFixture.second_division_name
  expect(third_row["Services Enabled"]).to eq "Yes"
  expect(third_row["BestArea4Me Enabled"]).to eq "No"
  expect(third_row["Development FAQs"]).to eq "Yes"
end

Then(/^I cannot export a Developer Report$/) do
  within ".report-buttons" do
    disabled_btns = page.all("[disabled]").map(&:value)

    expect(disabled_btns).to match_array [t("admin.analytics.new.developer"), t("admin.analytics.new.development")]
  end
end

When(/^I select the developer$/) do
  within ".report-targets" do
    select_from_selectmenu :report_developer_id, with: AnalyticsFixture.second_developer
  end
end

Then(/^I can export the Developer Report$/) do
  within ".report-buttons" do
    click_on t("admin.analytics.new.developer")
  end
end

Then(/^I cannot export a Development Report$/) do
  within ".report-targets" do
    select_from_selectmenu :report_developer_id, with: AnalyticsFixture.second_developer_name
  end
  within ".report-buttons" do
    disabled_btns = page.all("[disabled]").map(&:value)

    expect(disabled_btns).to match_array [t("admin.analytics.new.development")]
  end
end

Then(/^I select the development$/) do
  within ".report-targets" do
    select_from_selectmenu :report_division_id, with: AnalyticsFixture.second_division_name
    select_from_selectmenu :report_development_id, with: AnalyticsFixture.second_division_development_name
  end
end

Then(/^I can export the Development Report$/) do
  within ".report-buttons" do
    click_on t("admin.analytics.new.development")
  end
end

Then(/^if I select Completion only plots$/) do
    select_from_selectmenu :report_plot_type, with: "Completion"
end

Then(/^I see a notification saying the report is being processed$/) do
  within ".notice" do
    expect(page).to have_content("is being processed. You will receive an email shortly.")
  end
end

Then(/^I get an email telling me to download to report$/) do
  sleep 2
  email = ActionMailer::Base.deliveries.first
  expect(email).to have_body_text("report")
  expect(email.to).to eq [ExpiryFixture.cf_email]

  ActionMailer::Base.deliveries.clear
end

Given(/^at least one development has maintenance$/) do
  development = Development.find_by(name: CreateFixture.development_name)
  FactoryGirl.create(:maintenance, development_id: development.id)
end

When(/^I export the Billing Report$/) do
  within ".report-buttons" do
    click_on t("admin.analytics.new.billing")
  end
end
