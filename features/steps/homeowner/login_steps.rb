# frozen_string_literal: false

Given(/^I am a homeowner$/) do
  HomeownerUserFixture.create
end

Given(/^I am logged in as a homeowner$/) do
  login_as HomeownerUserFixture.create
  visit "/"
end

When(/^I log in as a homeowner$/) do
  homeowner = HomeownerUserFixture

  visit "/homeowners/sign_in"

  fill_in :resident_email, with: homeowner.email
  fill_in :resident_password, with: homeowner.password

  within ".branded-primary-btn" do
    click_on "Login"
  end
end

When(/^I log out as a homeowner$/) do
  first(:css, "[data-test='homeowner-sign-out']").click

  within ".notice" do
    expect(page).to have_content(t("devise.sessions.signed_out"))
  end
end

Then(/^I should be on the "My Home" dashboard$/) do
  homeowner = HomeownerUserFixture

  within ".header-container" do
    expect(page).to have_content "Hi #{homeowner.first_name}"
    expect(page).to have_link "My home"
  end
end

Then(/^I should be on the "Hoozzi Home" page$/) do
  expect(current_path).to eq("/")
end

Then(/^I should be on the branded homeowner login page$/) do
  homeowner = Resident.find_by(email: HomeownerUserFixture.email)

  # Should be safe, we only created one plot
  plot = homeowner.plots.first

  expected_path = "/#{plot.developer.to_s.parameterize}"
  expected_path << "/#{plot.division.to_s.parameterize}" if plot.division
  expected_path << "/#{plot.development.to_s.parameterize}/sign_in"

  expect(current_path).to eq(expected_path)
end

Given(/^I am a homeowner with no plot$/) do
  HomeownerUserFixture.create_without_residency
end

Then(/^I should be on the "Homeowner Login" page with errors$/) do
  expect(page).to have_content(t("residents.sessions.create.no_plot"))
  expect(page).to have_content(t("activerecord.attributes.resident.email"))
  expect(page).to have_content(t("activerecord.attributes.resident.password"))
end

When(/^I visit the data policy page$/) do
  visit "/data_policy"
end

Then(/^I should see the data policy contents$/) do
  within ".policy" do
    expect(page).to have_content(t("legal.data_policy.title"))
    expect(page).to have_content(t("legal.data_policy.information"))
    expect(page).to have_content(t("legal.data_policy.links"))
    expect(page).to have_content(t("legal.data_policy.what_we_do"))
    expect(page).to have_content(t("legal.data_policy.where_we_store"))
    expect(page).to have_content(t("legal.data_policy.who_we_are"))
    expect(page).to have_content(t("legal.data_policy.your_rights"))
  end
end

When(/^I visit the ts_and_cs page$/) do
  visit "/ts_and_cs"
end

Then(/^I should see the terms and conditions for using Hoozzi$/) do
  within ".policy" do
    expect(page).to have_content(t("legal.ts_and_cs.title"))
    expect(page).to have_content(t("legal.ts_and_cs.about_us"))
    expect(page).to have_content(t("legal.ts_and_cs.ip"))
    expect(page).to have_content(t("legal.ts_and_cs.accuracy"))
    expect(page).to have_content(t("legal.ts_and_cs.law"))
    expect(page).to have_content(t("legal.ts_and_cs.limitation"))
    expect(page).to have_content(t("legal.ts_and_cs.security"))
    expect(page).to have_content(t("legal.ts_and_cs.viruses"))
    expect(page).to have_content(t("legal.ts_and_cs.welcome").first(80))
  end
end

Then(/^I can request a password reset$/) do
  visit "/"
  click_on t("devise.forgot_password")

  fill_in :resident_email, with: HomeownerUserFixture.email
  click_on t("residents.passwords.new.submit")
end

Given(/^there is another phase plot for the homeowner$/) do
  second_plot = FactoryGirl.create(:plot, phase: CreateFixture.phase, prefix: "", number: PlotFixture.another_plot_number)
  resident = Resident.find_by(email: HomeownerUserFixture.email)
  FactoryGirl.create(:plot_residency, plot_id: second_plot.id, resident_id: resident.id)
end

Given(/^there is another division phase plot for the homeowner$/) do
  second_plot = FactoryGirl.create(:plot, phase: CreateFixture.division_phase, prefix: "", number: PlotFixture.another_plot_number)
  resident = Resident.find_by(email: HomeownerUserFixture.email)
  FactoryGirl.create(:plot_residency, plot_id: second_plot.id, resident_id: resident.id)
end
