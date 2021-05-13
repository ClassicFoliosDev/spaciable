# frozen_string_literal: true

Given(/^I have a (.*)developer with a development with unit type and plot$/) do |branded|
  CreateFixture.create_developer_with_division(branded: branded.present?)
  CreateFixture.create_division_development(branded: branded.present?)
  CreateFixture.create_division_development_unit_type(branded: branded.present?)
  CreateFixture.create_division_development_phase(branded: branded.present?)
  CreateFixture.create_division_phase_plot
end

Given(/^I have configured branding$/) do
  FactoryGirl.create(:brand, brandable: CreateFixture.developer(branded: true),
                             bg_color: "#FFFEEE",
                             text_color: "#646467",
                             button_color: "#A6A7B2",
                             button_text_color: "#FCFBE3",
                             topnav_text_color: "#48f442",
                             text_left_color: "#00FF49",
                             text_right_color: "#0008FF",
                             login_button_static_color: "#42697D",
                             content_box_color: "#000000",
                             login_button_hover_color: "#000000"
                             )

  FactoryGirl.create(:brand, brandable: CreateFixture.division(branded: true),
                             bg_color: "#000222",
                             content_bg_color: "#32344E",
                             button_text_color: "#4C4D64",
                             header_color: "#222000",
                             login_box_right_color: "#00FF6C",
                             content_box_color: "#FF0051",
                             content_box_outline_color: "#616734",
                             login_button_hover_color: "#56427D",
                             login_box_left_color: "#000000",
                             content_box_text: "#000000")

  FactoryGirl.create(:brand, brandable: CreateFixture.division_development(branded: true),
                             content_text_color: "#446677",
                             button_color: "#776644",
                             button_text_color: "#698492",
                             login_box_left_color: "#D800FF",
                             content_box_text: "#427D56")
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
  expect(style['outerHTML']).to have_content("branded-nav-background { background-color: #222000")
  # bg-color set on developer and division: should be the division color
  expect(style['outerHTML']).to have_content("library-navigation { background-color: #000222")
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
  expect(style['outerHTML']).to have_content("branded-nav-text a { color: #48f442")

  # banner set on development, division, and developer: should be development image
  expect(style['outerHTML']).to have_content("cala_banner.jpg")

  # button text color should NOT be the developer color
  expect(style['outerHTML']).not_to have_content("branded-btn { color: #A6A7B2")
  # button text color should NOT be the division color
  expect(style['outerHTML']).not_to have_content("branded-btn { color: #4C4D64")
end

Then(/^I should see the developer level configured branding$/) do
  within ".login-logo" do
    image = page.find("img")
    expect(image["alt"]).to have_content FileFixture.logo_alt
  end
end

# Specification for sign_in page branding can be referenced here:
# https://alliants.atlassian.net/browse/HOOZ-539

Then(/^I should see the configured branding$/) do
  within ".login-logo" do
    image = page.find("img")
    expect(image["alt"]).to have_content FileFixture.logo_alt
  end

  within ".preamble" do
    # Left text color should be left text color, set on developer only
    expect(page.body).to have_content "branded-left-text { color: #00FF49"
  end

  # Right text color should be branded external text, set on developer only
  expect(page.body).to have_content "branded-external-text label { color: #0008FF"
  # Left login box should be login box left color, set on division and development: should be development color
  expect(page.body).to have_content "branded-left-box, .branded-left-box .preamble { background-image: none; background-color: #D800FF"
  # Right login box should be login box right color, set on division only
  expect(page.body).to have_content "branded-right-box { background-color: #00FF6C"
  # Login content box and checkbox color should be content box color, set on developer and division: should be division color
  expect(page.body).to have_content "branded-content-box input { background-color: #FF0051"
  expect(page.body).to have_content "branded-content-box .branded-checkbox { background-color: #FF0051"
  # Login content box and checkbox outline color should be content box outline color, set on division only
  expect(page.body).to have_content "branded-content-box input { border-color: #616734"
  expect(page.body).to have_content "branded-content-box .branded-checkbox { border-color: #616734"
  # Login content box text and checkmark color should be content box text color, set on development and division: should be development color
  expect(page.body).to have_content "branded-content-box input { color: #427D56"
  expect(page.body).to have_content "branded-content-box input[type=checkbox]:checked + i:before { color: #427D56"
  # Login button background color and hover text color should be login button static color, set on developer only
  expect(page.body).to have_content "branded-submit { background-color: #42697D"
  expect(page.body).to have_content "branded-submit:hover { color: #42697D"
  # Login button hover background color and static text color should be login button hover color, set on division and developer: should be division color
  expect(page.body).to have_content "branded-submit:hover { background-color: #56427D"
  expect(page.body).to have_content "branded-submit { color: #56427D"

end

Given(/^the resident also has an unbranded plot$/) do
  country = FactoryGirl.create(:country)
  developer = FactoryGirl.create(:developer, country_id: country.id)
  developer.update_attributes(enable_perks: false, house_search: false, enable_referrals: false, enable_services: false)
  division = FactoryGirl.create(:division, developer: developer)
  development = FactoryGirl.create(:development, division: division)
  phase = FactoryGirl.create(:phase, development: development)
  plot = FactoryGirl.create(:plot, phase: phase, number: PlotFixture.another_plot_number)
  FactoryGirl.create(:plot_residency, plot_id: plot.id, resident_id: CreateFixture.resident.id)
end

Then(/^I should see the branded logos$/) do
  within ".plots" do
    images = page.all("img")
    expect(images.count).to eq 3

    image_file_names = images.map do |image|
      image["alt"]
    end

    expect(image_file_names).to include FileFixture.logo_alt
    expect(image_file_names).to include FileFixture.default_icon_alt
  end
end

Then(/^I should see the default branding$/) do
  wait_for_branding_to_reload

  within ".logo" do
    image = page.find("img")
    expect(image["alt"]).to have_content FileFixture.default_logo_alt
  end

  style = page.find("head [data-test='brand-style-overrides']", visible: false)

  expect(style['outerHTML']).to have_content("branded-body { background-color: #FFFFFF")
  expect(style['outerHTML']).to have_content("branded-text { color: #002A3A")
  expect(style['outerHTML']).to have_content("branded-content { background-color: #FFFFFF")
  expect(style['outerHTML']).to have_content("branded-border { border-color: #c5d1d6")
  expect(style['outerHTML']).to have_content("branded-btn { background-color: #FFFFFF")
  expect(style['outerHTML']).to have_content("branded-btn { color: #FF293F")

  expect(style['outerHTML']).not_to have_content("cala_banner.jpg")
end

When(/^I switch back to the first plot$/) do
  first_plot = Plot.find_by!(number: CreateFixture.phase_plot_name,
                             phase_id: CreateFixture.division_phase.id)

  within ".plots" do
    find(:xpath, "//a[@href='/homeowners/change_plot?id=#{first_plot.id}']").click
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
  open_email('jo@bloggs.com')
  click_first_link_in_email

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

  expect(invitation.parts.second.body.raw_source).to include "assets/Spaciable_full"

  ActionMailer::Base.deliveries.clear
end
