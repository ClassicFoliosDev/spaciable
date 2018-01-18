# frozen_string_literal: true

Then(/^I see the recent homeowner contents$/) do
  within ".my-home" do
    expect(page).to have_content(t("homeowners.dashboard.show.my_home_title"))
  end

  within ".faq-list" do
    faqs = page.all("li")
    expect(faqs.count).to eq(1)
  end

  within ".library-component" do
    MyLibraryFixture.all_documents.each do |title, _filename|
      expect(page).to have_content(title)
    end

    appliance_docs = page.all("a", text: CreateFixture.full_appliance_name)
    # Two docs for the same appliance, one manual and one quick reference guide
    expect(appliance_docs.count).to eq(2)
  end

  within ".contacts-component" do
    contacts = page.all(".contact")
    expect(contacts.count).to eq(2)
  end

  within ".dashboard" do
    howtos = page.all(".article")
    expect(howtos.count).to eq(3)
  end

  plot = CreateFixture.phase_plot
  address = plot.phase.address
  first_line = "#{address.building_name} #{address.road_name}"

  within ".my-home" do
    expect(page).to have_content(first_line)
    expect(page).to have_content(address.locality)
    expect(page).to have_content(address.city)
    expect(page).to have_content(address.county)
    expect(page).to have_content(address.postcode)
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
  login_as homeowner
end

When(/^I change my homeowner password$/) do
  visit "/"

  within ".session-inner" do
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
  within ".preamble" do
    expect(page).to have_content(t("residents.sessions.new.welcome_1"))
    expect(page).to have_content(t("residents.sessions.new.welcome_2"))
  end

  within ".sign-in" do
    expect(page).to have_content(t("activerecord.attributes.resident.email"))
    expect(page).to have_content(t("activerecord.attributes.resident.password"))
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
