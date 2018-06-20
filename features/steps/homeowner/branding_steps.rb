# frozen_string_literal: true

Given(/^I have a developer with a development with unit type and plot$/) do
  CreateFixture.create_developer_with_division
  CreateFixture.create_division_development
  CreateFixture.create_division_development_unit_type
  CreateFixture.create_division_development_phase
  CreateFixture.create_division_phase_plot
end

Given(/^I have configured branding$/) do
  FactoryGirl.create(:brand, brandable: CreateFixture.developer,
                             bg_color: "#FFFEEE",
                             text_color: "#646467",
                             button_color: "#A6A7B2",
                             button_text_color: "#FCFBE3")

  FactoryGirl.create(:brand, brandable: CreateFixture.division,
                             bg_color: "#000222",
                             content_bg_color: "#32344E",
                             button_text_color: "#4C4D64",
                             header_color: "#222000")

  FactoryGirl.create(:brand, brandable: CreateFixture.division_development,
                             content_text_color: "#446677",
                             button_color: "#776644",
                             button_text_color: "#698492")
end

And(/^I have logged in as a resident and associated the division development plot$/) do
  plot = Plot.find_by(number: CreateFixture.phase_plot_name)
  resident = CreateFixture.create_resident_under_a_phase_plot
  FactoryGirl.create(:plot_residency, plot_id: plot.id, resident_id: resident.id)

  login_as resident
end

When(/^I visit the dashboard$/) do
  visit("/")
end

Then(/^I should see the branding for my page$/) do
  style = page.find("head [data-test='brand-style-overrides']", visible: false)

  # header-color set on division only
  expect(style['outerHTML']).to have_content("branded-header { background-color: #222000")
  # bg-color set on developer and division: should be the division color
  expect(style['outerHTML']).to have_content("branded-body { background-color: #000222")
  # text-color set on developer only
  expect(style['outerHTML']).to have_content("branded-text { color: #646467")
  # content bg-color set on developer and division: should be the division color
  expect(style['outerHTML']).to have_content("branded-content { background-color: #32344E")
  # content outline (aka border) color set on development only
  expect(style['outerHTML']).to have_content("branded-border { border-color: #446677")
  # button background color set on development and developer: should be development color
  expect(style['outerHTML']).to have_content("branded-btn { background-color: #776644")
  # button text color set on development, division, and developer: should be development color
  expect(style['outerHTML']).to have_content("branded-btn { color: #698492")

  # banner set on development, division, and developer: should be development image
  expect(style['outerHTML']).to have_content("cala_banner.jpg")

  # button text color should NOT be the developer color
  expect(style['outerHTML']).not_to have_content("branded-btn { color: #A6A7B2")
  # button text color should NOT be the division color
  expect(style['outerHTML']).not_to have_content("branded-btn { color: #4C4D64")
end

# Specification for sign_in page branding can be referenced here:
# https://alliants.atlassian.net/browse/HOOZ-539

Then(/^I should see the configured branding$/) do
  within ".login-logo" do
    image = page.find("img")
    expect(image["alt"]).to have_content FileFixture.logo_alt
  end

  within ".preamble" do
    # Background colour should be content bg color, set on developer and division: should be division
    expect(page.body).to have_content "branded-content { background-color: #32344E"
    # Text color should be text color, set on developer only
    expect(page.body).to have_content "branded-text { color: #646467"
    # Title color should be button (background) color, set on development and developer: should be development color
    expect(page.body).to have_content "branded-titles h2 { color: #776644"
    expect(page.body).to have_content "branded-titles h2:last-child { color: #776644"
  end

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

Given(/^the resident also has an unbranded plot$/) do
  developer = FactoryGirl.create(:developer)
  division = FactoryGirl.create(:division, developer: developer)
  development = FactoryGirl.create(:development, division: division)
  phase = FactoryGirl.create(:phase, development: development)
  plot = FactoryGirl.create(:plot, phase: phase, prefix: "", number: PlotFixture.another_plot_number)
  FactoryGirl.create(:plot_residency, plot_id: plot.id, resident_id: CreateFixture.resident.id)
end

Then(/^I should see the branded logos$/) do
  within ".plot-list" do
    images = page.all("img")
    expect(images.count).to eq 3

    image_file_names = images.map do |image|
      image["alt"]
    end

    expect(image_file_names).to include FileFixture.logo_alt
    expect(image_file_names).to include FileFixture.default_logo_alt
  end
end

Then(/^I should see the default branding$/) do
  wait_for_branding_to_reload

  within ".logo" do
    image = page.find("img")
    expect(image["alt"]).to have_content FileFixture.default_logo_alt
  end

  style = page.find("head [data-test='brand-style-overrides']", visible: false)

  expect(style['outerHTML']).to have_content("branded-header { background-color: #394F5F")
  expect(style['outerHTML']).to have_content("branded-body { background-color: #FAFAFA")
  expect(style['outerHTML']).to have_content("branded-text { color: #2F2F2F")
  expect(style['outerHTML']).to have_content("branded-content { background-color: #FFFFFF")
  expect(style['outerHTML']).to have_content("branded-border { border-color: #EAEAEA")
  expect(style['outerHTML']).to have_content("branded-btn { background-color: #F93549")
  expect(style['outerHTML']).to have_content("branded-btn { color: #FFFFFF")

  expect(style['outerHTML']).not_to have_content("cala_banner.jpg")
end

When(/^I switch back to the first plot$/) do
  within ".plot-list" do
    plot_link = page.find_link(CreateFixture.division_development_name)
    plot_link.trigger(:click)
  end

  wait_for_branding_to_reload
end

Given(/^I log in as CF Admin$/) do
  login_as CreateFixture.create_cf_admin
  visit "/"
end

Then(/^The resident receives a branded invitation$/) do
  expect(ActionMailer::Base.deliveries.count).to eq 4
  invitation = ActionMailer::Base.deliveries.first

  expect(invitation.parts.second.body.raw_source).to include FileFixture.logo_name
end

Then(/^I visit the accept page$/) do
  invitation = ActionMailer::Base.deliveries.first

  sections = invitation.text_part.body.to_s.split("http://")
  paths = sections[2].split(t("devise.mailer.invitation_instructions.ignore"))

  url = "http://#{paths[0]}"
  visit url

  ActionMailer::Base.deliveries.clear
end

Given(/^I have configured blank branding$/) do
  FactoryGirl.create(:brand, brandable: CreateFixture.developer, bg_color: "", logo: nil)
  FactoryGirl.create(:brand, brandable: CreateFixture.division, header_color: "", logo: nil)
  FactoryGirl.create(:brand, brandable: CreateFixture.division_development, logo: "")
end

Then(/^The resident receives an invitation with default branding$/) do
  expect(ActionMailer::Base.deliveries.count).to eq 4
  invitation = ActionMailer::Base.deliveries.first

  expect(invitation.parts.second.body.raw_source).to include "assets/ISYT-40px-01"

  ActionMailer::Base.deliveries.clear
end

Given(/^I have configured developer branding$/) do
  FactoryGirl.create(:brand, brandable: CreateFixture.developer,
                     bg_color: "#FFFEEE",
                     text_color: "#646467",
                     button_color: "#A6A7B2",
                     button_text_color: "#FCFBE3")
end
