# frozen_string_literal: true

And(/^I have created a unit_type$/) do
  CreateFixture.create_developer
  CreateFixture.create_division
  CreateFixture.create_development
  CreateFixture.create_division_development
  CreateFixture.create_phases
  CreateFixture.create_unit_type
  CreateFixture.create_room
  CreateFixture.create_appliance_manufacturer
  CreateFixture.create_appliance
  CreateFixture.create_appliance_room
end

And(/^I have logged in as a resident and associated the plot$/) do
  plot = CreateFixture.create_phase_plot
  CreateFixture.seed_env
  resident = FactoryGirl.create(:resident, :with_residency, plot: plot, email: "multiple_resident@example.com", ts_and_cs_accepted_at: Time.zone.now)

  login_as resident
end

When(/^I visit the My Home page$/) do
  visit "/"

  within ".my-home" do
    click_on t("homeowners.components.address.view_more", construction: t("components.homeowner.sub_menu.title"))
  end
end

Then(/^I should see the plot rooms$/) do
  within ".sub-navigation-container" do
    click_on t("components.homeowner.sub_menu.rooms")
  end
  within ".rooms" do
    expect(page).to have_content(CreateFixture.room_name)
  end
end

Given(/^there is another plot$/) do
  unit_type = FactoryGirl.create(:unit_type)
  plot = FactoryGirl.create(:plot, phase: Phase.first, unit_type: unit_type, number: PlotFixture.another_plot_number)
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

  within ".plots" do
    find(:xpath, "//a[@href='/homeowners/change_plot?id=#{plot.id}']").click
  end
end

When(/^I visit the Library page$/) do
  within ".sub-navigation-container" do
    click_on t("components.homeowner.sub_menu.library")
  end
end

Then(/^I should see My Documents$/) do
  within ".library-navigation" do
    expect(page).to have_content("My Documents")
    expect(page).to_not have_content("Services")
    expect(page).to_not have_content("Legal & Warranty")
    expect(page).to_not have_content("My Home")
  end
end

When(/^I visit the Contacts page$/) do
  within ".burger-navigation" do
    check_box = find(".burger")
    check_box.trigger(:click)
  end
  click_on(t("layouts.homeowner.nav.contacts"))
end

Then(/^I should see no tabs$/) do
  expect(page).to_not have_content("Services")
  expect(page).to_not have_content("Sales")
end

Then(/^I should see the tenant on my account$/) do
  visit "/"

  page.find("#dropdownMenu").click
  click_on t("homeowners.residents.show.my_account")

  within ".other-residents" do
    expect(page).to have_content "Other residents with access to "
    expect(page).to have_content("tenant@example.com")
  end
end

Then(/^I should not see the homeowner on my account$/) do
  visit "/"

  page.find("#dropdownMenu").click
  click_on t("homeowners.residents.show.my_account")

  within ".branded-body" do
    expect(page).to_not have_content t("homeowners.residents.show.other_residents")
    expect(page).to_not have_content("homeowner@example.com")
  end
end
