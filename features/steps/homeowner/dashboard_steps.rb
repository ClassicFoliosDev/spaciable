# frozen_string_literal: true

Then(/^I see the recent homeowner contents$/) do
  within ".my-home" do
    expect(page).to have_content(t("homeowners.dashboard.show.my_title", construction: t("components.homeowner.sub_menu.title")))
  end

  within ".faq-list" do
    faqs = page.all("li")
    expect(faqs.count).to eq(1)
  end

  within ".library-component" do
    MyLibraryFixture.all_documents.each do |title, _filename|
      expect(page).to have_content(title)
    end

    # the pinned document should be the first in the list
    expect(page.first(".document-name")).to have_content("Development Document")

    appliance_docs = page.all("a", text: CreateFixture.full_appliance_name)
    # Two docs for the same appliance, one manual and one quick reference guide
    expect(appliance_docs.count).to eq(2)
  end

  within ".contacts-component" do
    contacts = page.all(".contact")
    expect(contacts.count).to eq(2)
  end

  within ".dashboard" do
    howtos = page.all(".how-to-dash")
    expect(howtos.count).to eq(3)
  end

  plot = CreateFixture.phase_plot

  within ".my-home" do
    expect(page).to have_content(plot.to_homeowner_s)
    expect(page).to have_content(plot.building_name)
    expect(page).to have_content(plot.road_name)
    expect(page).to have_content(plot.locality)
    expect(page).to have_content(plot.city)
    expect(page).to have_content(plot.county)
    expect(page).to have_content(plot.postcode)
  end

  within ".footer" do
    copyright = t("components.homeowner.footer.copyright", year: Time.current.year)
    copyright = copyright.gsub(/&copy;/, "")
    expect(page).to have_content(copyright)
    expect(page).to have_link(t("components.homeowner.footer.privacy"))
    expect(page).to have_link(t("components.homeowner.footer.ts_and_cs"))
  end
end

Given(/^I have created and logged in as a homeowner user$/) do
  homeowner = HomeownerUserFixture.create
  CreateFixture.seed_env
  login_as homeowner
end

When(/^I change my homeowner password$/) do
  visit "/"

  page.find("#dropdownMenu").click
  within ".links-list" do
    click_on t("homeowners.residents.show.my_account")
  end

  within ".actions" do
    click_on t("homeowners.residents.show.edit_profile")
  end

  within(".resident_current_password") do
    fill_in :password, with: HomeownerUserFixture.password
  end

  within(".resident_password") do
    fill_in :resident_password, with: HomeownerUserFixture.updated_password
  end

  within(".resident_password_confirmation") do
    fill_in :password, with: HomeownerUserFixture.updated_password
  end

  click_on t("homeowners.residents.edit.submit")
end

Then(/^I should be logged out of homeowner$/) do
  within ".sign-in" do
    expect(page).to have_content(t("residents.sessions.new.welcome_1"))
    expect(page).to have_content(t("residents.sessions.new.welcome_2"))
  end
end

And(/^I can see the data policy page$/) do
  within ".footer" do
    click_on t("components.homeowner.footer.privacy")
  end

  within ".policy" do
    expect(page).to have_content(t("legal.data_policy.title"))
    expect(page).to have_content(t("legal.data_policy.information_1"))
    expect(page).to have_content(t("legal.data_policy.us_1"))
    expect(page).to have_content(t("legal.data_policy.rights_1"))
  end
end

When(/^I the plot has a postal number$/) do
  plot = CreateFixture.phase_plot
  plot.build_address
  plot.address.postal_number = "7C"
  plot.save!
end

Then(/^I see the dashboard address reformatted$/) do
  visit "/"

  plot = CreateFixture.phase_plot
  address = plot.phase.address

  first_line = "#{plot.address.postal_number} #{address.building_name}"

  within ".my-home" do
    expect(page).to have_content(first_line)
    expect(page).to have_content(address.road_name)
    expect(page).to have_content(address.locality)
    expect(page).to have_content(address.city)
    expect(page).to have_content(address.county)
    expect(page).to have_content(address.postcode)
  end
end

Then(/^I see the plot number as postal number$/) do
  visit "/"

  plot = Plot.find_by(number: HomeownerUserFixture.plot_number)

  within ".my-home" do
    expect(page).to have_content(plot.to_homeowner_s)
    expect(page).to have_content(plot.building_name)
    expect(page).to have_content(plot.road_name)
    expect(page).to have_content(plot.locality)
    expect(page).to have_content(plot.city)
    expect(page).to have_content(plot.county)
    expect(page).to have_content(plot.postcode)
  end
end

Then(/^I see the savings$/) do
  within ".articles" do
    services = page.all(".services-component")
    expect(services.count).to eq 1
  end
end

Then(/^I only see three articles$/) do
  within ".articles" do
    how_tos = page.all(".how-to-dash")
    expect(how_tos.count).to eq 3
  end
end

Given(/^the developer has enabled referrals$/) do
  developer = Developer.find_by(company_name: HomeownerUserFixture.developer_name)
  developer = Developer.find_by(company_name: CreateFixture.developer_name) unless developer

  developer.update_attributes(enable_referrals: true)
end

Then(/^I see the referral link$/) do
  within ".articles" do
    referral = page.all(".refer-summary")
    expect(referral.count).to eq 1
  end
end

Given(/^the developer has not enabled referrals$/) do
  developer = Developer.find_by(company_name: HomeownerUserFixture.developer_name)
  developer = Developer.find_by(company_name: CreateFixture.developer_name) unless developer

  developer.update_attributes(enable_referrals: false)
end

Then(/^I see no referral link$/) do
  within ".articles" do
    referral = page.all(".refer-summary")
    expect(referral.count).to eq 0
  end
end

Then(/^I see no savings link$/) do
  within ".articles" do
    services = page.all(".services-summary")
    expect(services.count).to eq 0
  end
end

Given(/^the developer has a custom tile for savings$/) do
  development = Development.find_by(name: HomeownerUserFixture.development_name)
  FactoryGirl.create(:custom_tile, spotlight_id: Spotlight.create(development_id: development.id).id, feature: 'services')
end

Given(/^the developer has a custom tile for referrals$/) do
  development = Development.find_by(name: HomeownerUserFixture.development_name)
  FactoryGirl.create(:custom_tile, spotlight_id: Spotlight.create(development_id: development.id).id, feature: 'referrals')
end

When(/^I refer a friend$/) do
  visit "/"
  referafriend
end

Then(/^I should see the referral has been sent$/) do
  within ".notice" do
    expect(page).to have_content t("homeowners.dashboard.tiles.referrals.confirm")
  end
end

When(/^I accept the referral$/) do
  email = ActionMailer::Base.deliveries.last
  email.should deliver_to(ReferralFixture.referee_email)   # Check the email has sent to the correct recipient
  click_first_link_in_email email   # Click the 'I Agree' link
end

Then(/^I should see that my details have been confirmed$/) do
  within ".accept" do
    image = page.find("img")
    expect(image["alt"]).to have_content(ReferralFixture.accept_alt)
  end
end

Then(/^the Spaciable Admin should receive an email containing my details$/) do
  email = ActionMailer::Base.deliveries.last
  email.should deliver_to("feedback@spaciable.com")
  expect(email).to have_subject (/New Referral/)
  expect(email).to have_body_text(ReferralFixture.referee_email)
  expect(email).to have_body_text(ReferralFixture.referee_first_name)
end

Given(/^the development has a custom link tile$/) do
  development = Development.find_by(name: HomeownerUserFixture.development_name)

  CustomTile.create(spotlight_id: Spotlight.create(development_id: development.id).id, category: "link", link: "https://ducks.com",
                    title: "Title", description: "Description", button: "Button")

  stub_request(:get, "https://ducks.com").
  to_return(:headers => {})
end

Then(/^I can see the custom link tile$/) do
  visit "/"

  within ".dash-tile" do
    expect(page).to have_content ("Title")
    expect(page).to have_content ("Description")
    expect(page).to have_content ("Button")
  end
end

Given(/^the development has enabled snagging/) do
  development = Development.find_by(name: HomeownerUserFixture.development_name)
  development.enable_snagging = true
  development.snag_duration = 10
  development.save!
end

Given(/^the development has set a snagging tile$/) do
  development = Development.find_by(name: HomeownerUserFixture.development_name)

  FactoryGirl.create(:custom_tile, spotlight_id: Spotlight.create(development_id: development.id).id, feature: 'snagging')
end

Then(/^I should not see the snagging tile$/) do
  visit "/"
  within ".dashboard" do
    expect(page).to_not have_content I18n.t("homeowners.dashboard.tiles.snagging.title")
    expect(page).to_not have_content I18n.t("homeowners.dashboard.tiles.snagging.description")
  end
end

Given(/^there is a estimated move in date in the past$/) do
  plot = Plot.find_by(number: HomeownerUserFixture.plot_number)
  plot.completion_date = Time.zone.today - 9.days
  plot.save!
end

Then(/^I should see the snagging tile$/) do
  visit "/"

  within ".dashboard" do
    expect(page).to have_content I18n.t("homeowners.dashboard.tiles.snagging.description",
                                         title: HomeownerUserFixture.custom_snag_name)
  end
end

When(/^the snagging duration is past$/) do
  development = Development.find_by(name: HomeownerUserFixture.development_name)
  development.snag_duration = 5
  development.save!
end

def referafriend
  sleep 0.5

  within ".refer-summary" do
    click_on t("homeowners.dashboard.tiles.referrals.title")
  end

  within ".ui-dialog" do
    fill_in :referral_referee_first_name, with: ReferralFixture.referee_first_name
    fill_in :referral_referee_last_name, with: ReferralFixture.referee_last_name
    fill_in :referral_referee_email, with: ReferralFixture.referee_email
    fill_in :referral_referee_phone, with: ReferralFixture.referee_phone
  end

  send_button = page.find(".btn-send")
  send_button.trigger("click")
end
