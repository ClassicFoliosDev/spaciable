# frozen_string_literal: true

When(/^I visit the maintenance page$/) do
  visit "/"
  within ".navbar-menu" do
    click_on I18n.t("components.homeowner.navigation.maintenance")
  end
end

Then(/^I should see the maintenance page$/) do
  expect(page).to have_selector(".maintenance")
end

Then(/^I should see the bafm link$/) do
  visit "/"
  expect(page).to have_content(I18n.t("components.homeowner.navigation.house_search"))
end

When(/^the expiry date is past$/) do
  plot = CreateFixture.development_plot
  plot.update_attributes(completion_release_date: Time.zone.now.ago(2.years))
end

Then(/^I should not see the maintenance link$/) do
  visit "/"

  within ".branded-header" do
    expect(page).not_to have_content(I18n.t("components.homeowner.navigation.maintenance"))
  end
end

Given(/^the plot does have a completion release date$/) do
  plot = CreateFixture.development_plot
  plot.update_attributes(completion_release_date: Time.zone.now)
  visit "/"
end

Given(/^the developer has enabled home designer$/) do
  developer = Developer.find_by(company_name: HomeownerUserFixture.developer_name)
end

Given(/^the developer has disabled home designer$/) do
  developer = Developer.find_by(company_name: HomeownerUserFixture.developer_name)
  developer.update_attributes(enable_roomsketcher: false)
end

Then(/^I should see the home designer link$/) do
  expect(page).to have_content(I18n.t("layouts.homeowner.nav.home_designer", construction: t("construction_type.home")))
end

Then(/^when I visit the home designer page$/) do
  within ".navbar-menu" do
    click_on I18n.t("layouts.homeowner.nav.home_designer", construction: t("construction_type.home"))
  end
end

Then(/^I can see the home designer page$/) do
  expect(page).to have_selector(".home-designer")
  expect(page).to have_content(t("homeowners.home_designers.show.new_tab"))
end

Then(/^I should not see the home designer link$/) do
  visit "/"
  expect(page).not_to have_content(I18n.t("layouts.homeowner.nav.home_designer"))
end

Given(/^the development has maintenance enabled$/) do
  development = CreateFixture.development
  FactoryGirl.create(:maintenance, development_id: development.id)
end
