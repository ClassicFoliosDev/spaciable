# frozen_string_literal: true

Given(/^There are existing appliances$/) do
  SeedsFixture.create_appliance_manufacturers
end

Then(/^I should not see the seed appliance updates$/) do
  visit "/appliances"

  within ".tabs" do
    click_on t("appliances.collection.appliance_manufacturers")
  end

  within ".record-list" do
    expect(page).to have_content("Aeg")
    expect(page).to have_content("BauMatic")
    expect(page).to have_content("Beko")
    expect(page).to have_content("Caple")

    expect(page).not_to have_content("Baumatic")
    expect(page).not_to have_content("AEG")
  end
end

