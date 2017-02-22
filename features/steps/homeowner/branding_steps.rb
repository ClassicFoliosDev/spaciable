# frozen_string_literal: true
Given(/^I have a developer with a development with unit type and plot$/) do
  CreateFixture.create_developer_with_division
  CreateFixture.create_division_development
  CreateFixture.create_division_development_unit_type
  CreateFixture.create_division_development_plot
end

Given(/^I have configured branding$/) do
  FactoryGirl.create(:brand, brandable: CreateFixture.developer,
                             bg_color: "#FFFEEE",
                             text_color: "#EEEFFF",
                             button_color: "#EEEFFF",
                             button_text_color: "#FFFEEE")
  FactoryGirl.create(:brand, brandable: CreateFixture.division,
                             bg_color: "#000222",
                             content_bg_color: "#000222",
                             button_text_color: "#000222")
  FactoryGirl.create(:brand, brandable: CreateFixture.division_development,
                             content_text_color: "#446677",
                             button_color: "#776644",
                             button_text_color: "#446677")
end

And(/^I have logged in as a resident and associated the division development plot$/) do
  plot = CreateFixture.create_division_development_plot
  resident = FactoryGirl.create(:resident, :with_residency, plot: plot)

  login_as resident
end

When(/^I visit the dashboard$/) do
  visit("/")
end

Then(/^I should see the branding for my page$/) do
  within ".homeowner-view" do
    container = page.find(".content-container")

    style = container.find("style")

    # bg-color set on developer and division: should be the division color
    expect(style.native).to have_content("branded-body { background-color: #000222")
    # text-color set on developer only
    expect(style.native).to have_content("branded-text { color: #EEEFFF")
    # content bg-color set on division only
    expect(style.native).to have_content("branded-content { background-color: #000222")
    # content border (aka text) color set on development only
    expect(style.native).to have_content("branded-border { border-color: #446677")
    # button background color set on development and developer: should be development color
    expect(style.native).to have_content("branded-btn { background-color: #776644")
    # button text color set on development, division, and developer: should be development color
    expect(style.native).to have_content("branded-btn { color: #446677")

    # banner set on development, division, and developer: should be development image
    expect(style.native).to have_content("cala_banner.jpg")

    # button text color should NOT be the developer color
    expect(style.native).not_to have_content("branded-btn { color: #FFFEEE")
    # button text color should NOT be the division color
    expect(style.native).not_to have_content("branded-btn { color: #000222")
  end
end
