# frozen_string_literal: true
And(/^I have created a unit_type$/) do
  CreateFixture.create_developer
  CreateFixture.create_division
  CreateFixture.create_development
  CreateFixture.create_division_development
  CreateFixture.create_phases
  CreateFixture.create_unit_type
  CreateFixture.create_room
end

And(/^I have logged in as a resident and associated the plot$/) do
  plot = CreateFixture.create_development_plot
  resident = FactoryGirl.create(:resident, :with_residency, plot: plot)

  login_as resident
end

When(/^I visit the My Home page$/) do
  visit "/"

  within ".navbar-menu" do
    click_on t("layouts.homeowner.nav.my_home")
  end
end

Then(/^I should see the plot rooms$/) do
  within ".rooms" do
    expect(page).to have_content(CreateFixture.room_name)
  end
end
