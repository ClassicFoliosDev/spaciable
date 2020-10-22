# frozen_string_literal: true

Given(/^I have a developer with a (CAS )*development$/) do |cas|
  CreateFixture.create_developer_with_development(cas: cas.present?)
end

Given(/^I have a spanish developer with a development$/) do
  CreateFixture.create_spanish_developer_with_development
end

Given(/^I have configured the development address$/) do
  goto_development_show_page

  sleep 0.3
  within ".section-data" do
    find("[data-action='edit']").click
  end

  sleep 0.2
  PhaseFixture.development_address_attrs.each do |attr, value|
    fill_in "development_address_attributes_#{attr}", with: value
  end

  click_on t("developments.form.submit")
end

Given(/^I have configured the spanish development address$/) do
  goto_spanish_development_show_page

  sleep 0.3
  within ".section-data" do
    find("[data-action='edit']").click
  end

  sleep 0.2
  PhaseFixture.spanish_development_address_attrs.each do |attr, value|
    fill_in "development_address_attributes_#{attr}", with: value
  end

  click_on t("developments.form.submit")
end

When(/^I create a phase for the development$/) do
  goto_development_show_page

  click_on t("phases.collection.add")

  fill_in "phase_name", with: CreateFixture.phase_name
  click_on t("phases.form.submit")
end

Then(/^I should see the created phase$/) do
  click_on CreateFixture.phase_name

  # Address fields should be inherited from the development
  PhaseFixture.development_address_attrs.each do |_attr, value|
    expect(page).to have_content(value)
  end
end

When(/^I update the phase$/) do
  find("[data-action='edit']").click

  sleep 0.3 # these fields do not get filled in without the sleep :(
  fill_in "phase[number]", with: PhaseFixture.updated_phase_number
  fill_in "phase[name]", with: PhaseFixture.updated_phase_name

  PhaseFixture.address_update_attrs.each do |attr, value|
    fill_in "phase_address_attributes_#{attr}", with: value
  end

  click_on t("phases.form.submit")
end

Then(/^I should see the updated phase$/) do
  within ".phases" do
    click_on PhaseFixture.updated_phase_name
  end

  PhaseFixture.update_attrs.each do |_attr, value|
    expect(page).to have_content(value)
  end

  PhaseFixture.address_update_attrs.each do |_attr, value|
    expect(page).to have_content(value)
  end
end

When(/^I delete the phase$/) do
  goto_development_show_page

  within ".actions" do
    find(".destroy-permissable").click
  end

  fill_in "password", with: CreateFixture.admin_password
  click_on(t("admin_permissable_destroy.confirm"))
end

Then(/^I should see that the deletion completed successfully$/) do
  success_flash = t(
    "phases.destroy.success",
    phase_name: PhaseFixture.updated_phase_name
  )

  within ".notice" do
    expect(page).to have_content(success_flash)
  end

  within ".breadcrumbs" do
    expect(page).to have_content(CreateFixture.development_name)
  end

  expect(page).not_to have_content(".record-list")

  within ".empty" do
    expect(page).to have_content %r{#{t("components.empty_list.add", action: "Add", type_name: Phase.model_name.human)}}i
  end
end

Then(/^I should see the development address has not been changed$/) do
  goto_development_show_page

  within ".section-data" do
    PhaseFixture.development_address_attrs.each do |_attr, value|
      expect(page).to have_content(value)
    end
  end
end

When(/^I update the progress for the phase$/) do
  ActionMailer::Base.deliveries.clear
  visit "/"
  goto_phase_show_page

  within ".tabs" do
    click_on t("phases.collection.progresses")
  end

  select_from_selectmenu :progress_all, with: PhaseFixture.progress

  within ".form-actions-footer" do
    check :notify
    click_on t("progresses.collection.submit")
  end
end

Then(/^I should see the phase progress has been updated$/) do
  success_message = t(
    "progresses.bulk_update.success",
    progress: PhaseFixture.progress
  )
  residents = Resident.where(developer_email_updates: true)
  success_flash = success_message + t("resident_notification_mailer.notify.update_sent", count: residents.count)

  within ".notice" do
    expect(page).to have_content(success_flash)
  end
end

Then(/^Phase residents should have been notified$/) do
  message = t("notify.updated_progress",
                      state: "#{PhaseFixture.progress}")

  in_app_notification = Notification.all.last
  expect(in_app_notification.residents.count).to eq 1
  expect(in_app_notification.residents.first.email).to eq CreateFixture.resident.email

  email = ActionMailer::Base.deliveries.first
  expect(email).to have_body_text(message)

  ActionMailer::Base.deliveries.clear
end

When(/^I visit the phase$/) do
  visit "/"
  goto_phase_show_page
end

When(/^I create a phase for the spanish development$/) do
  goto_spanish_development_show_page
  click_on t("phases.collection.add")
  fill_in "phase_name", with: CreateFixture.phase_name
end

Then(/^I should see a spanish format phase address$/) do

  ignore = Capybara.ignore_hidden_elements
  Capybara.ignore_hidden_elements = false

  expect(page).not_to have_selector('#phase_address_attributes_postal_number')
  expect(page).not_to have_selector('#dphase_address_attributes_road_name')
  expect(page).not_to have_selector('#phase_address_attributes_building_name')
  find_field(:phase_address_attributes_locality).should be_visible
  find_field(:phase_address_attributes_city).should be_visible
  expect(page).not_to have_selector('#dphase_address_attributes_county')
  find_field(:phase_address_attributes_postcode).should be_visible

  Capybara.ignore_hidden_elements = ignore
end

Then(/^I should see a spanish developer address pre-filled$/) do

  ignore = Capybara.ignore_hidden_elements
  Capybara.ignore_hidden_elements = false

  expect(find_field(:phase_address_attributes_locality).value).to eq PhaseFixture.spanish_development_address_attrs[:locality]
  expect(find_field(:phase_address_attributes_city).value).to eq PhaseFixture.spanish_development_address_attrs[:city]

  Capybara.ignore_hidden_elements = ignore
end

Given(/^I am logged in as a Developer Development branch Admin$/) do
  admin = LettingsFixture.create_developer_development_branch_admin
  login_as admin
end

Then(/^I can see the lettings tab$/) do
  expect(page).to have_content(t("phases.collection.lettings"))
end

Then(/^I should not see the lettings tab$/) do
  expect(page).not_to have_content(t("phases.collection.lettings"))
end

When(/^I select the lettings tab$/) do
  phase = Phase.find_by(name: CreateFixture.phase_name)
  find(:xpath, ".//a[@href='/phases/#{phase.id}/lettings']").click
end

Then(/^I see instructions to authorise my account$/) do
  expect(page).to have_content(t("phases.lettings.index.authorise"))
end

When(/^I deny authorisation$/) do
  button = find_by_id('authorise') #find the authorise button
  stub_request(:any, button[:href]) # stub the link
  button.click #click the button
  # mimic a denied response
  visit '/users/auth/doorkeeper/callback?error=access_denied&error_description=The+resource+owner+or+authorization+server+denied+the+request.&state=b14f98e5b751814b10e31d062bc0d404fe25e9478fe1a592aae1fafb776bcbfd'
end

Then(/^I am informed that Authorisation has been denied$/) do
  expect(page).to have_content("The resource owner or authorization server denied the request")
end

When(/^I authorise from an incorrect planet rent account$/) do
  WebMock.reset!
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

  # The get_user_info request - return a mismatching email
  stub_request(:get, "#{LettingsFixture::URL}/api/v3/get_user_info?access_token=#{LettingsFixture::ACCESS_TOK}").
  with(:headers => LettingsFixture.oauth2_header).
  to_return(:status => 200,
            :body => {"email" => "floopy@ploppy.com"}.to_json,
            :headers => LettingsFixture.response_headers)

  button.click #click the button
  # mimic the authorised response - this will trigger the stubs
  visit "users/auth/doorkeeper/callback?code=#{LettingsFixture::CODE}&state=6934385438a497c3300e3a94696366f256877db1a97ab86f1373869e5cc9f225"
end

Then(/^I am informed that the authorisation is incorrect$/) do
  expect(page).to have_content("Incorrect authorisation. The authorising account must have the email #{$current_user.email}")
end

When(/^I authorise from the correct planet rent account$/) do
  WebMock.reset!
  button = find_by_id('authorise') #find the authorise button

  # The atuhorise link on the button
  stub_request(:any, button[:href]) # stub the link

  # The AOauth2 token request
  stub_request(:post, "#{LettingsFixture::URL}/oauth/token").
  with(:body => LettingsFixture.token_request,
       :headers => LettingsFixture.token_headers).
  to_return(status: 200,
            body: LettingsFixture.token_body.to_json,
            headers:LettingsFixture.response_headers)

  # The get_user_info request
  stub_request(:get, "#{LettingsFixture::URL}/api/v3/get_user_info?access_token=#{LettingsFixture::ACCESS_TOK}").
  with(:headers => LettingsFixture.oauth2_header).
  to_return(:status => 200,
            :body => {"email" => $current_user.email}.to_json,
            :headers => LettingsFixture.response_headers)

  # The get_property call when building the lisitngs
  stub_request(:get, "#{LettingsFixture::URL}/api/v3/property_types?access_token=#{LettingsFixture::ACCESS_TOK}").
  with(:headers => LettingsFixture.oauth2_header).
  to_return(:status => 200,
            :body => LettingsFixture.get_property_types.to_json,
            :headers => LettingsFixture.response_headers)

  # The landlords call when building the lisitngs
  stub_request(:get, "#{LettingsFixture::URL}/api/v3/get_all_landlords?access_token=#{LettingsFixture::ACCESS_TOK}").
  with(:headers => LettingsFixture.oauth2_header).
  to_return(:status => 200,
            :body => LettingsFixture.get_landlords.to_json,
            :headers => LettingsFixture.response_headers)

  button.click #click the button
  # mimic the authorised response - this will trigger all the stubs
  visit "users/auth/doorkeeper/callback?code=#{LettingsFixture::CODE}&state=6934385438a497c3300e3a94696366f256877db1a97ab86f1373869e5cc9f225"
end

Then(/^I should see the admin lettable plots$/) do
  expect(page).not_to have_content("Incorrect authorisation. The authorising account must have the email #{$current_user.email}")
  CreateFixture.phase.plots.each do |plot|
    expect(page).to have_content("Plot #{plot.number}")
  end
end

When(/^I click to let an admin plot$/) do
  find_button("letplot#{CreateFixture.phase_plots.first.number}").click
end

Then(/^I should see an autofilled listings form$/) do
  plot = CreateFixture.phase_plots.first
  expect(page).to have_css('div.lettings-form')
  expect(find_field('letting_address_1').value).to eq LettingsFixture.plot_fields(plot)["address_1"]
  expect(find_field('letting_address_2').value).to eq LettingsFixture.plot_fields(plot)["address_2"]
  expect(find_field('letting_town').value).to eq LettingsFixture.plot_fields(plot)["town"]
  expect(find_field('letting_postcode').value).to eq LettingsFixture.plot_fields(plot)["postcode"]
end

Then(/^I should be able complete the listing$/) do
  plot = CreateFixture.phase_plots.first
  fill_in "letting_bedrooms", with: 100 #willfail validation - and not enable Let Plot
  fill_in "letting_bathrooms", with: LettingsFixture.plot_fields(plot)["bathrooms"]
  fill_in "letting_price", with: LettingsFixture.plot_fields(plot)["price"]
  fill_in "letting_summary", with: LettingsFixture.plot_fields(plot)["summary"]
  fill_in "letting_notes", with: LettingsFixture.plot_fields(plot)["notes"]

  #check Let Plot not enabled
  letplot = find(:xpath, ".//button/span[text()='#{t("phases.lettings.client_admin_listings.submit")}']/parent::button")
  expect(letplot.disabled?).to be true

  #will pass validation - and enable Let Plot
  fill_in "letting_bedrooms", with: LettingsFixture.plot_fields(plot)["bedrooms"]
  expect(letplot.disabled?).to be false
end

Then(/^I should be able to list the plot on Planet Rent$/) do
  WebMock.reset!
  plot = CreateFixture.phase_plots.first

  stub_request(:post, "#{LettingsFixture::URL}/api/v3/let_property").
  with(
    :headers => LettingsFixture.post_header,
    :body => LettingsFixture.get_property(plot, true).to_json
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

  # The landlords call when building the lisitngs
  stub_request(:get, "#{LettingsFixture::URL}/api/v3/get_all_landlords?access_token=#{LettingsFixture::ACCESS_TOK}").
  with(:headers => LettingsFixture.oauth2_header).
  to_return(:status => 200,
            :body => LettingsFixture.get_landlords.to_json,
            :headers => LettingsFixture.response_headers)

  # Click Let Plot
  find(:xpath, ".//button/span[text()='Let Plot']/parent::button").click
  sleep 2 # Wait for javascript post to process
  find_link(nil, href: "https://staging.deals.planetrent.co.uk/show_spaciable_property?other_ref=spaciable#{plot.id}")
end

When(/^I navigate to the lettings tab$/) do
  phase = Phase.find_by(name: CreateFixture.phase_name)
  find_link(nil, href: "/phases/#{phase.id}/lettings").click
  sleep 0.5
  expect(page).to have_content("Admin Lettings")
end

Then(/^I can add "([^"]*)" lettings$/) do |type|
  plots = type == "admin" ? [1,2,3,4,5] : [6,7,8,9,10]
  choose("lettings_#{type}_checked")
  fill_in "phase_lettings_list", with: plots.join(',')
  click_on t("developments.form.submit")

  sleep 1
  within(".#{type}-lettings-list") do
    plots.each do |p|
      expect(page).to have_content("Plot #{p.number}")
    end
  end
end

Then(/^I can move a "([^"]*)" letting to a "([^"]*)" letting$/) do |from, to|
  plots = from == "admin" ? [1,2,3,4,5] : [6,7,8,9,10]
  move = Plot.find_by(number: plots.first)
  find(:xpath, ".//tr[@data-plot='#{move.id}']//button[@data-title='Confirm Switch']").click
  #click the confirm
  find(:xpath, ".//span[text()='Confirm']/parent::button").click

  sleep 1
  within(".#{to}-lettings-list") do
    expect(page).to have_content("Plot #{move.number}")
  end

  within(".#{from}-lettings-list") do
    expect(page).not_to have_content("Plot #{move.number}")
  end

end

Then(/^I can delete a "([^"]*)" letting$/) do |type|
  plots = type == "admin" ? [1,2,3,4,5] : [6,7,8,9,10]
  remove = Plot.find_by(number: plots.last)

  within(".#{type}-lettings-list") do
    expect(page).to have_content("Plot #{remove.number}")
  end

  find(:xpath, ".//tr[@data-plot='#{remove.id}']//button[@data-title='Confirm Remove']").click
  #click the confirm
  find(:xpath, ".//span[text()='Confirm']/parent::button").click

  sleep 1

  within(".#{type}-lettings-list") do
    expect(page).not_to have_content("Plot #{remove.number}")
  end
end

When(/^a letting is live$/) do
  plots = [1,2,3,4,5]
  #Create a LettingsAccount for the current user
  LettingsAccount.create({"authorisation_status" => "authorised",
                          "management" => "agency",
                          "accountable_type" => User.to_s,
                          "accountable_id" => $current_user.id}) do | account, success |
    if success
      listing = Listing.find_by(plot_id: plots.second)
      listing.update_attributes(lettings_account_id: account.id)
      listing.save
    end
  end
end

Then(/^I cannot move or delete the letting$/) do
  plots = [1,2,3,4,5]
  expect(page).not_to have_selector(:xpath, ".//tr[@data-plot='#{plots.second}']//button[@data-title='Confirm Switch']")
  expect(page).not_to have_selector(:xpath, ".//tr[@data-plot='#{plots.second}']//button[@data-title='Confirm Remove']")
end





