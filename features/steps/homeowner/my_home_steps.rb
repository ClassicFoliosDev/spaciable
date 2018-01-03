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
  resident = FactoryGirl.create(:resident, :with_residency, plot: plot, email: "multiple_resident@example.com", ts_and_cs_accepted_at: Time.zone.now)

  login_as resident
end

When(/^I visit the My Home page$/) do
  visit "/"

  within ".navbar-menu" do
    click_on t("layouts.homeowner.nav.my_home")
  end

  within ".sub-navigation-container" do
    click_on t("layouts.homeowner.sub_nav.rooms")
  end
end

Then(/^I should see the plot rooms$/) do
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

Then(/^I should see no rooms$/) do
  within ".rooms" do
    expect(page).not_to have_selector(".room")
  end
end

When(/^I switch back to the development plot$/) do
  within ".plot-list" do
    plot_link = page.find_link(CreateFixture.plot_name)
    plot_link.trigger(:click)
  end
end
