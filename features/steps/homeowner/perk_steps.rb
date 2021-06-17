# frozen_string_literal: true

# call this method before loading the dashboard when the user has no perks account
def call_api_no_user_account
  stub_request(:get, "#{PerkFixture::URL}/api/v4/users/#{PerkFixture::ID}/#{PerkFixture::ACCESS_KEY}?Email=#{PerkFixture.resident_email}").
  to_return(body: PerkFixture.no_resident_account.to_json,
            headers: {"Content-Type"=> "application/json"})
end

# call this method when the api is called to check whether premium perks are activated for a plot, when no resident has a premium account
def no_premium_perks_activated
  stub_request(:get, "#{PerkFixture::URL}/api/v4/users/#{PerkFixture::ID}/#{PerkFixture::ACCESS_KEY}?Reference=#{PerkFixture.plot.id}").
  to_return(body: PerkFixture.no_resident_premium_account.to_json,
            headers: {"Content-Type"=> "application/json"})
end

# call this method when the api is called to check whether premium perks are activated for a plot, when a resident has a premium account
def premium_perks_activated
  stub_request(:get, "#{PerkFixture::URL}/api/v4/users/#{PerkFixture::ID}/#{PerkFixture::ACCESS_KEY}?Reference=#{PerkFixture.plot.id}").
  to_return(body: PerkFixture.resident_premium_account.to_json,
            headers: {"Content-Type"=> "application/json"})
end

def resident_perks_account
 # check the sign up page and button are accessible
  within first(".perks-button") do
    find(".branded-btn").trigger('click')
  end

  find(".activate-perks-account")

  # call the api with the user having an account
  stub_request(:get, "#{PerkFixture::URL}/api/v4/users/#{PerkFixture::ID}/#{PerkFixture::ACCESS_KEY}?Email=#{PerkFixture.resident_email}").
  to_return(body: PerkFixture.basic_resident_account.to_json,
            headers: {"Content-Type"=> "application/json"})

  visit "/"
end

When(/^I create a perks developer$/) do
  visit "/"

  CreateFixture.create_countries
  within ".navbar" do
    click_on t("components.navigation.developers")
  end

  click_on t("developers.index.add")
  fill_in "developer_company_name", with: PerkFixture.developer_name
  fill_in "developer_custom_url", with: PerkFixture.developer_name.parameterize
  check "enable_perks"

  click_on t("developers.form.submit")
end

Then(/^I should see the created perks developer$/) do
  within ".developers" do
    click_on PerkFixture.developer_name
  end

  within ".section-data" do
    find("[data-action='edit']").click
  end

  expect(find_field("enable_perks").value).to eq "1"
end

When(/^I update the perks developer with branded perks$/) do
  fill_in "developer_branded_perk_attributes_link", with: PerkFixture.branded_perks_link
  fill_in "developer_branded_perk_attributes_account_number", with: "12345"


  click_on t("developers.form.submit")
end

Then(/^I should see the updated branded perks developer$/) do
  developer = Developer.find_by(company_name: PerkFixture.developer_name)
  branded_developer = BrandedPerk.first # this is the only branded perk created
  expect(branded_developer.developer_id).to eq developer.id

  within ".section-data" do
    find("[data-action='edit']").click
  end

  expect(find_field("developer_branded_perk_attributes_link").value).to eq PerkFixture.branded_perks_link
  expect(find_field("developer_branded_perk_attributes_account_number").value).to eq "12345"

  # to continue testing we need to change the account id back to the spaciable account id
  branded_developer.account_number = PerkFixture::ID
  branded_developer.save!

  within ".navbar" do
    click_on "Log Out"
  end
end

Given(/^I am logged in as a homeowner on a perks plot$/) do
  call_api_no_user_account
  login_as PerkFixture.create_perk_resident
end

Given(/^my plot does not have a legal completion date$/) do
  plot = PerkFixture.plot
  plot.completion_date = nil
  plot.save!
end

Then(/^I see the basic perks link$/) do
  call_api_no_user_account

  visit "/dashboard"
  within first(".perks-summary")do
    expect(page).to have_content(I18n.t("homeowners.dashboard.perks.perks_description"))
    expect(page).to have_link(I18n.t("homeowners.dashboard.perks.perks"), href: "/homeowners/perks?type=basic")
  end
end

When(/^I sign up to perks then I see the branded perks link$/) do
  no_premium_perks_activated
  resident_perks_account

  within first(".perks-summary") do
    expect(page).to have_link(I18n.t("homeowners.dashboard.perks.activated_perks"), href: PerkFixture.branded_perks_link)
  end
end

When(/^I sign up to perks then I see the default perks link$/) do
  resident_perks_account

  within first(".perks-summary") do
    expect(page).to have_link(I18n.t("homeowners.dashboard.perks.activated_perks"), href: PerkFixture.default_perks_link)
  end
end

Given(/^my plot has a legal completion date in the future$/) do
  plot = PerkFixture.plot
  plot.completion_date = Time.zone.today.advance(days: 7)
  plot.save!
end

Given(/^my plot has a legal completion date in the past$/) do
  plot = PerkFixture.plot
  plot.completion_date = Time.zone.today.advance(days: -7)
  plot.save!
end

Given(/^my plot has a legal completion date of today$/) do
  plot = PerkFixture.plot
  plot.completion_date = Time.zone.today

  no_premium_perks_activated

  plot.save!
end

Given(/^the developer has disabled perks$/) do
  developer = PerkFixture.developer
  developer.enable_perks = false
  developer.save!
end

Then(/^I do not see the perks link$/) do
  call_api_no_user_account

  visit "/"
  within ".branded-body" do
    expect(page).to_not have_content "Perks"
  end
end

When(/^I create a perks development$/) do
  within ".developers" do
    click_on PerkFixture.developer_name
  end
  within ".tabs" do
    click_on I18n.t("developers.collection.developments")
  end
  within ".lower" do
    click_on I18n.t("developments.collection.add")
  end
  fill_in "development_name", with: PerkFixture.development_name
  check "development_premium_perk_attributes_enable_premium_perks"
end

When(/^I do not enter a premium licence duration$/) do
  # enter a premium licences bought value, but no duration
  fill_in "development_premium_perk_attributes_premium_licences_bought", with: "1"



  within ".form-actions-footer" do
    click_on t("developments.form.submit")
  end
end

Then(/^I see an error telling me to enter a premium licence duration$/) do
  within find(".submission-errors") do
    expect(page).to have_content("Premium perk premium licence duration is not a number")
  end
end

Then(/^I do not enter a premium licence quantity$/) do
  # enter a premium licence duration, but change premium licences bought to 0
  fill_in "development_premium_perk_attributes_premium_licences_bought", with: "0"
  fill_in "development_premium_perk_attributes_premium_licence_duration", with: "12"



  within ".form-actions-footer" do
    click_on t("developments.form.submit")
  end
end

Then(/^I see an error telling me to enter a premium licence quantity$/) do
  within ".submission-errors" do
    expect(page).to have_content("Premium perk premium licences bought must be greater than or equal to 1")
  end
end

Then(/^I enter a valid premium licence duration and quantity$/) do
  fill_in "development_premium_perk_attributes_premium_licences_bought", with: "10"
  within ".form-actions-footer" do
    click_on t("developments.form.submit")
  end
end

Then(/^I should see the created perks development$/) do
  within ".developments" do
    click_on PerkFixture.development_name
  end



  within ".section-data" do
    find("[data-action='edit']").click
  end
  expect(find_field("development_premium_perk_attributes_enable_premium_perks").value).to eq "1"
  expect(find_field("development_premium_perk_attributes_premium_licences_bought").value).to eq "10"
  expect(find_field("development_premium_perk_attributes_premium_licence_duration").value).to eq "12"
  within ".form-actions-footer" do
    click_on "Back"
  end
end

Then(/^I see the perks coming soon link$/) do
  call_api_no_user_account
  visit "/dashboard"
  within first(".perks-summary") do
    expect(page).to have_content(I18n.t("homeowners.dashboard.perks.perks_description"))
    expect(page).to have_link(I18n.t("homeowners.dashboard.perks.perks"), href: "/homeowners/perks?type=coming_soon")
  end
end

Then(/^I see the premium perks link$/) do
  call_api_no_user_account
  visit "/"
  within first(".perks-summary") do
    expect(page).to have_content(I18n.t("homeowners.dashboard.perks.perks_description"))
    expect(page).to have_link(I18n.t("homeowners.dashboard.perks.perks"), href: "/homeowners/perks?type=premium")
  end
end

Given(/^that I am a limited access user$/) do
  resident = Resident.find_by(email: CreateFixture.resident_email)
  plot = Plot.find_by(number: CreateFixture.phase_plot_name)
  plot_residency = PlotResidency.find_by(plot_id: plot.id, resident_id: resident.id)
  plot_residency.role = "tenant"
  plot_residency.save!
end

Given(/^there are premium licences available$/) do
  development = PerkFixture.development
  perk = PremiumPerk.find_by(development_id: development.id)
  perk.premium_licences_bought = 10
  perk.save!
end

Given(/^no other residents on my plot have activated premium perks$/) do
  attrs = { first_name: "Second", last_name: "Resident", email: "second@email.com", plot: PerkFixture.plot }
  FactoryGirl.create(:resident, :activated, attrs)
end

Then(/^if another resident on my plot has activated premium perks then I see the basic perks link$/) do
  premium_perks_activated

  steps %{Then I see the basic perks link}
end

Then(/^if there are no premium licences available then I see the basic perks link$/) do
  premium_perks_activated

  perk = PremiumPerk.find_by(development_id: PerkFixture.development.id)
  perk.premium_licences_bought = 1
  perk.save!

  steps %{Then I see the basic perks link}
end

Then(/^if I am a limited access user then I see the basic perks link$/) do
  premium_perks_activated

  # increase the premium licences available in order to appropriately test
  perk = PremiumPerk.find_by(development_id: PerkFixture.development.id)
  perk.premium_licences_bought = 10
  perk.save!

  plot_residency = PlotResidency.find_by(resident_id: PerkFixture.resident.id)
  plot_residency.role = "tenant"
  plot_residency.save!

  steps %{Then I see the basic perks link}
end
