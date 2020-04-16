Given(/^I am a homeowner with multiple plots$/) do
  HomeownerUserFixture.create
  HomeownerUserFixture.create_more_plot_residencies
end

When(/I have no lettable plots$/) do
  expect($current_user.listings?).to be false
end

Then(/^I shall not see a lettings button on my dashboard$/) do
  page.find("#dropdownMenu").click
  within ".links-list" do
    expect(page).not_to have_content(t('components.homeowner.header.lettings'))
  end
end

Given(/^the homeowner lettable phase plots have multiple occupation$/) do
  LettingsFixture.create_multiple_resident_plot_occupation
end

When(/^I log in as homeowner "([^"]*)" of lettable multiple occupation plots$/) do |arg1|
  login_as LettingsFixture.residents[arg1.to_i-1]
  visit '/'
end

Then(/^I shall see a lettings button on my dashboard$/) do
  page.find("#dropdownMenu").click
  within ".links-list" do
    expect(page).to have_content(t('components.homeowner.header.lettings'))
  end
end

When(/^another resident is listing plots I occupy$/) do
  LettingsFixture.let_plot(CreateFixture.phase_plots.first,
                           LettingsFixture.residents.second)
end

When(/^I press my lettings button$/) do
  visit "/"
  page.find("#acctNav").click
  click_on(t('components.homeowner.header.lettings'))
end

Then(/^I shall see two options to set up a Planet Rent account$/) do
  find_button("Select #{t(".homeowners.lettings.show.self_managed")}")
  find_button("Select #{t(".homeowners.lettings.show.management_service")}")
end

When(/^I choose to let "([^"]*)"$/) do |managed|
  
  stub_request(:post, "#{LettingsFixture::URL}/api/v3/create_landlord").
  with(
    :headers => LettingsFixture.post_header,
    :body => LettingsFixture.create_landlord($current_user, 
                                             managed == "management_service").to_json
    ).
  to_return(:status => 200, 
            :body => LettingsFixture.create_landlord_response($current_user).to_json, 
            :headers => LettingsFixture.response_headers)

  # select 
  find_button("Select #{t(".homeowners.lettings.show.#{managed}")}").click

  # And Confirmation dialog
  find(:xpath, ".//button/span[text()='Confirm Choice']/parent::button").click
end

Then(/^I shall get a message that my account has been set up$/) do
  sleep 1
  expect(page).to have_content(t('.homeowners.lettings_account.created', username: $current_user.first_name))
end

Then(/^I shall be able to authorise my account$/) do
   expect(page).to have_content(t("homeowners.lettings.show.authorise"))
end

When(/^I authorise my account$/) do
  button = find_by_id('authorise') #find the authorise button

  # The authorise link on the button
  stub_request(:any, button[:href]) # stub the link

  # The AOauth2 token request
  stub_request(:post, "#{LettingsFixture::URL}/oauth/token").
  with(:body => LettingsFixture.token_request,
       :headers => LettingsFixture.token_headers).
  to_return(status: 200, 
            body: LettingsFixture.token_body.to_json,
            headers:LettingsFixture.response_headers)

   # The get_property call when building the lisitngs 
  stub_request(:get, "#{LettingsFixture::URL}/api/v3/property_types?access_token=#{LettingsFixture::ACCESS_TOK}").
  with(:headers => LettingsFixture.oauth2_header).
  to_return(:status => 200, 
            :body => LettingsFixture.get_property_types.to_json, 
            :headers => LettingsFixture.response_headers)

  button.click #click the button
  # mimic the authorised response - this will trigger the stubs
  visit "users/auth/doorkeeper/callback?code=#{LettingsFixture::CODE}&state=6934385438a497c3300e3a94696366f256877db1a97ab86f1373869e5cc9f225"
end

Then(/^I shall see listings for all my plots$/) do
  $current_user.plots. each do |p|
    expect(page).to have_content("Plot #{p.number}")
    container = find(:xpath, ".//h3[text()='Plot #{p.number}']/parent::div/parent::div")
    let = p&.listing.live? && p.listing.belongs_to?($current_user)
    listing = find_by_id("listing#{p.number}")
    if p&.listing.live?
      if p.listing.belongs_to?($current_user)
        expect(listing).to have_content(t("homeowners.components.lettings.dashboard"))
      else
        expect(listing).to have_content(t("homeowners.components.lettings.let_out_other", other: p&.listing.belongs_to))
      end
    else
        expect(listing).to have_content(t("homeowners.components.lettings.let_my_plot"))
    end                                          
  end
end

When(/^I choose to list plot "([^"]*)"$/) do |arg1|
  plot = Plot.find(arg1.to_i)
  within("#listing#{plot.number}") do
    #click the let button
    find(:xpath, ".//button").click
  end

  #fill in the form
  fill_in "letting_bedrooms", with: 100 #willfail validation - and not enable Let Plot
  fill_in "letting_bathrooms", with: LettingsFixture.plot_fields(plot)["bathrooms"]
  fill_in "letting_price", with: LettingsFixture.plot_fields(plot)["price"]
  fill_in "letting_summary", with: LettingsFixture.plot_fields(plot)["summary"]
  fill_in "letting_notes", with: LettingsFixture.plot_fields(plot)["notes"]

  #check Let Plot not enabled
  letplot = find(:xpath, ".//button/span[text()='#{t("homeowners.components.lettings.submit")}']/parent::button")
  expect(letplot.disabled?).to be true

  #will pass validation - and enable Let Plot
  fill_in "letting_bedrooms", with: LettingsFixture.plot_fields(plot)["bedrooms"]
  expect(letplot.disabled?).to be false

  stub_request(:post, "#{LettingsFixture::URL}/api/v3/let_property").
  with(
    :headers => LettingsFixture.post_header,
    :body => LettingsFixture.get_property(plot).to_json
    ).
  to_return(:status => 200, 
            :body => LettingsFixture.get_property_response(plot).to_json, 
            :headers => LettingsFixture.response_headers(LettingsFixture::CREATED))

  # The get_property call when building the lisitngs 
  stub_request(:get, "#{LettingsFixture::URL}/api/v3/property_types?access_token=#{LettingsFixture::ACCESS_TOK}").
  with(:headers => LettingsFixture.oauth2_header).
  to_return(:status => 200, 
            :body => LettingsFixture.get_property_types.to_json, 
            :headers => LettingsFixture.response_headers)

  letplot.click
end

Then(/^I shall see plot "([^"]*)" as listed on Planet Rent$/) do |arg1|
  sleep 2
  plot = Plot.find(arg1.to_i)
  within("#listing#{plot.number}") do
    find_link(t("homeowners.components.lettings.dashboard",
              href: "#{LettingsFixture::URL}/show_spaciable_property?other_ref=spaciable#{plot.id}"))
  end
end

Then(/^I shall see the details of the "([^"]*)" lettings by other residents$/) do |num_lettings|
  expect($current_user.plots_listing_by_others.count).to be num_lettings.to_i
  $current_user.plots_listing_by_others.each do |p|
    within("#listing#{p.number}") do
      expect(page).to have_content("Plot #{p.number}")
      expect(page).to have_content(p&.listing.belongs_to)
    end
  end
end#

When(/^I try and fail to let self_managed$/) do
  
  stub_request(:post, "#{LettingsFixture::URL}/api/v3/create_landlord").
  with(
    :headers => LettingsFixture.post_header,
    :body => LettingsFixture.create_landlord($current_user, 
                                             false).to_json
    ).
  to_return(:status => 200, 
            :body => LettingsFixture.create_landlord_failure_response.to_json, 
            :headers => LettingsFixture.response_headers(LettingsFixture::BAD_REQUEST))

  # select 
  find_button("Select #{t(".homeowners.lettings.show.self_managed")}").click

  # And Confirmation dialog
  find(:xpath, ".//button/span[text()='Confirm Choice']/parent::button").click
end

Then(/^I should see an add user failure message$/) do
  sleep 1
  expect(page).to have_content("Failed to create PlanetRent user account. Failed to create landlord. Validation failed: First name can't be blank")
end

When(/^I choose to list plot "([^"]*)" with errors$/) do |arg1|
  plot = Plot.find(arg1.to_i)
  within("#listing#{plot.number}") do
    #click the let button
    find(:xpath, ".//button").click
  end

  #fill in the form
  fill_in "letting_bedrooms", with: LettingsFixture.plot_fields(plot)["bedrooms"]
  fill_in "letting_bathrooms", with: LettingsFixture.plot_fields(plot)["bathrooms"]
  fill_in "letting_price", with: LettingsFixture.plot_fields(plot)["price"]
  fill_in "letting_summary", with: LettingsFixture.plot_fields(plot)["summary"]
  fill_in "letting_notes", with: LettingsFixture.plot_fields(plot)["notes"]

  #check Let Plot not enabled
  letplot = find(:xpath, ".//button/span[text()='#{t("homeowners.components.lettings.submit")}']/parent::button")

  stub_request(:post, "#{LettingsFixture::URL}/api/v3/let_property").
  with(
    :headers => LettingsFixture.post_header,
    :body => LettingsFixture.get_property(plot).to_json
    ).
  to_return(:status => 200, 
            :body => LettingsFixture.get_property_error_response(plot).to_json, 
            :headers => LettingsFixture.response_headers(LettingsFixture::CREATED))

  # The get_property call when building the lisitngs 
  stub_request(:get, "#{LettingsFixture::URL}/api/v3/property_types?access_token=#{LettingsFixture::ACCESS_TOK}").
  with(:headers => LettingsFixture.oauth2_header).
  to_return(:status => 200, 
            :body => LettingsFixture.get_property_types.to_json, 
            :headers => LettingsFixture.response_headers)

  letplot.click
  sleep 2 
end

Then(/^I shall see a listing error for plot "([^"]*)"$/) do |arg1|
  plot = Plot.find(arg1.to_i)
  expect(page).to have_content("Failed to create listing. other_ref spaciable#{plot.id} property already exists on PlanetRent")
end

When(/^I have an expired token$/) do
  token = $current_user.lettings_account.access_token
  token.update_attributes(expires_at: Time.now.to_i - 60)
  token.save

  # This will cause a AOauth2 token request
  stub_request(:post, "#{LettingsFixture::URL}/oauth/token").
  with(:body => LettingsFixture.refresh_token,
       :headers => LettingsFixture.token_headers).
  to_return(status: 200, 
            body: LettingsFixture.token_body.to_json,
            headers:LettingsFixture.response_headers)
end

