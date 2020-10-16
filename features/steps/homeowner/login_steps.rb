# frozen_string_literal: false

Given(/^I am a homeowner$/) do
  HomeownerUserFixture.create
end

Given(/^I am logged in as a homeowner$/) do
  login_as HomeownerUserFixture.create
  visit "/"
end

Given(/^I am logged in as a homeowner with associated timeline (.*)$/) do |timeline|
  login_as HomeownerUserFixture.create(timeline: eval(timeline))
  visit "/"
end

When(/^I log in as a homeowner$/) do
  homeowner = HomeownerUserFixture
  visit "/homeowners/sign_in"

  within ".sign-in" do
    fill_in :resident_email, with: homeowner.email
    fill_in :resident_password, with: homeowner.password

    check_box = find(".accept-ts-and-cs")
    check_box.trigger(:click)

    click_on "Login"
  end
end

When(/^I log in as a returning homeowner$/) do
  homeowner = HomeownerUserFixture
  visit "/"

  within ".sign-in" do
    fill_in :resident_email, with: homeowner.email
    fill_in :resident_password, with: homeowner.password

    click_on "Login"
  end
end

When(/^I log out as a homeowner$/) do
  page.find("#dropdownMenu").click
  find("#signOut").click

  within ".notice" do
    expect(page).to have_content(t("devise.sessions.signed_out"))
  end
end

Then(/^I should be on the branded homeowner login page$/) do
  homeowner = Resident.find_by(email: HomeownerUserFixture.email)

  # Should be safe, we only created one plot
  plot = homeowner.plots.first
  expect(current_path).to eq("/#{plot.development.id}/sign_in")
end

Given(/^I am a homeowner with no plot$/) do
  HomeownerUserFixture.create_without_residency
end

Then(/^I should be on the "Homeowner Login" page with errors$/) do
  expect(page).to have_content(t("residents.sessions.create.no_plot"))
end

Then(/^I can request a password reset$/) do
  visit "/homeowners/sign_in"
  click_on t("devise.forgot_password")

  fill_in :resident_email, with: HomeownerUserFixture.email
  click_on t("residents.passwords.new.submit")
end

Given(/^there is another phase plot for the homeowner$/) do
  second_plot = FactoryGirl.create(:plot, phase: CreateFixture.phase, number: PlotFixture.another_plot_number)
  resident = Resident.find_by(email: HomeownerUserFixture.email)
  FactoryGirl.create(:plot_residency, plot_id: second_plot.id, resident_id: resident.id)
end

Given(/^there is another division phase plot for the homeowner$/) do
  second_plot = FactoryGirl.create(:plot, phase: CreateFixture.division_phase, number: PlotFixture.another_plot_number)
  resident = Resident.find_by(email: HomeownerUserFixture.email)
  FactoryGirl.create(:plot_residency, plot_id: second_plot.id, resident_id: resident.id)
end
