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
  plot = CreateFixture.create_phase_plot
  resident = FactoryGirl.create(:resident, :with_residency, plot: plot, email: "multiple_resident@example.com", ts_and_cs_accepted_at: Time.zone.now)

  login_as resident
end

When(/^I visit the My Home page$/) do
  visit "/"

  within ".navbar-menu" do
    click_on t("layouts.homeowner.nav.my_home")
  end
end

Then(/^I should see the plot rooms$/) do
  within ".sub-navigation-container" do
    click_on t("layouts.homeowner.sub_nav.rooms")
  end
  within ".rooms" do
    expect(page).to have_content(CreateFixture.room_name)
  end
end

Given(/^there is another plot$/) do
  unit_type = FactoryGirl.create(:unit_type)
  plot = FactoryGirl.create(:plot, unit_type: unit_type, number: PlotFixture.another_plot_number)
  resident = Resident.find_by(email: "multiple_resident@example.com")
  FactoryGirl.create(:plot_residency, plot_id: plot.id, resident_id: resident.id)
end

Then(/^I should see no rooms or appliances$/) do
  within ".sub-navigation-container" do
    expect(page).not_to have_content("Rooms")
    expect(page).not_to have_content("Appliances")
  end
end

When(/^I switch back to the development plot$/) do
  plot = Plot.find_by(number: CreateFixture.phase_plot_name)

  within ".session-inner" do
    plot_link = page.find_link(plot.to_homeowner_s)
    plot_link.trigger(:click)
  end
end

When(/^I visit the Library page$/) do
  within ".sub-navigation-container" do
    click_on t("layouts.homeowner.sub_nav.library")
  end
end

Then(/^I should see My Documents$/) do
  within ".filter-hero" do
    expect(page).to have_content("My documents")
    expect(page).to_not have_content("Services")
    expect(page).to_not have_content("Legal & warranty")
    expect(page).to_not have_content("My home")
  end
end

When(/^I visit the Contacts page$/) do
  within ".navbar-menu" do
    click_on t("layouts.homeowner.nav.my_home")
  end
end

Then(/^I should see no tabs$/) do
  expect(page).to_not have_content("Services")
  expect(page).to_not have_content("Sales")
end

