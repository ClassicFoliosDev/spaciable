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
    expect(page).to have_content("Document")
  end

  within ".contacts-component" do
    contacts = page.all(".contact")
    expect(contacts.count).to eq(3)
  end

  howtos = page.all(".dashboard-article")
  expect(howtos.count).to eq(5)
  expect(howtos[0]).to have_content("Changing Home Checklist")
  expect(howtos[4]).to have_content("Counter New Home Cracks")
end

Given(/^I have created a homeowner user$/) do
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

  sleep 0.2
  within(".resident_current_password") do
    fill_in :password, with: HomeownerUserFixture.password
  end

  within(".resident_password") do
    fill_in :resident_password, with: HomeownerUserFixture.updated_password
  end

  within(".resident_password_confirmation") do
    fill_in :password, with: HomeownerUserFixture.updated_password
  end

  click_on t("admin.users.form.submit")
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
