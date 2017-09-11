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
                             text_color: "#646467",
                             button_color: "#A6A7B2",
                             button_text_color: "#FCFBE3",
                             logo: "logo.png")
  FactoryGirl.create(:brand, brandable: CreateFixture.division,
                             bg_color: "#000222",
                             content_bg_color: "#32344E",
                             button_text_color: "#4C4D64",
                             header_color: "#222000",
                             logo: "logo-small-white.png")
  FactoryGirl.create(:brand, brandable: CreateFixture.division_development,
                             content_text_color: "#446677",
                             button_color: "#776644",
                             button_text_color: "#698492")
end

And(/^I have logged in as a resident and associated the division development plot$/) do
  plot = CreateFixture.division_plot
  resident = FactoryGirl.create(:resident, :with_residency, plot: plot)

  login_as resident
end

When(/^I visit the dashboard$/) do
  visit("/")
end

Then(/^I should see the branding for my page$/) do
  style = find("head [data-test='brand-style-overrides']", visible: false)

  # header-color set on division only
  expect(style.native).to have_content("branded-header { background-color: #222000")
  # bg-color set on developer and division: should be the division color
  expect(style.native).to have_content("branded-body { background-color: #000222")
  # text-color set on developer only
  expect(style.native).to have_content("branded-text { color: #646467")
  # content bg-color set on developer and division: should be the division color
  expect(style.native).to have_content("branded-content { background-color: #32344E")
  # content outline (aka border) color set on development only
  expect(style.native).to have_content("branded-border { border-color: #446677")
  # button background color set on development and developer: should be development color
  expect(style.native).to have_content("branded-btn { background-color: #776644")
  # button text color set on development, division, and developer: should be development color
  expect(style.native).to have_content("branded-btn { color: #698492")

  # banner set on development, division, and developer: should be development image
  expect(style.native).to have_content("cala_banner.jpg")

  # button text color should NOT be the developer color
  expect(style.native).not_to have_content("branded-btn { color: #A6A7B2")
  # button text color should NOT be the division color
  expect(style.native).not_to have_content("branded-btn { color: #4C4D64")
end

# Specification for sign_in page branding can be referenced here:
# https://alliants.atlassian.net/browse/HOOZ-539

Then(/^I should see the configured branding$/) do
  within ".preamble" do
    # Background colour should be content bg color, set on developer and division: should be division
    expect(page.body).to have_content "branded-content { background-color: #32344E"
    # Text color should be text color, set on developer only
    expect(page.body).to have_content "branded-text { color: #646467"
    # Title color should be button (background) color, set on development and developer: should be development color
    expect(page.body).to have_content "branded-titles h2 { color: #776644"
    expect(page.body).to have_content "branded-titles h2:last-child { color: #776644"
  end

  within ".new_resident" do
    # Label text should be text color, only set on developer
    expect(page.body).to have_content "branded-primary-text { color: #646467"
    # Input field background should be content bg color, set on developer and division: should be division
    expect(page.body).to have_content ".branded-input input:-webkit-autofill { -webkit-box-shadow: 0 0 0 30px #32344E"
    # Input field border should be content border color, set on development only
    expect(page.body).to have_content ".branded-input input[type=\"email\"] { border-color: #446677"
    expect(page.body).to have_content ".branded-input input[type=\"password\"] { border-color: #446677"
    # Link text should be button (background) color as text colour, set on development and developer: should be development color
    expect(page.body).to have_content ".branded-primary-text label.checkbox { color: #776644"
    expect(page.body).to have_content ".branded-primary-text a { color: #776644"
    # Button text should be button (text) color, set on development, division and developer: should be development color
    expect(page.body).to have_content "branded-primary-btn { color: #698492"
    # Button border and background should be button (background) color, set on development and developer: should be development color
    expect(page.body).to have_content "branded-primary-btn { background-color: #776644"
  end
end
