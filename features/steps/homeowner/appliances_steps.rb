# frozen_string_literal: true
Given(/^I have an appliance with a guide$/) do
  ApplianceFixture.create_appliance_with_guide
end

When(/^I visit the appliances page$/) do
  visit "/"

  within ".navbar-menu" do
    click_on t("layouts.homeowner.nav.my_home")
  end

  within ".sub-navigation-container" do
    click_on t("layouts.homeowner.sub_nav.appliances")
  end
end

Then(/^I should see the appliances for my plot$/) do
  within ".appliances" do
    expect(page).to have_content(CreateFixture.appliance_category_name)
    expect(page).to have_content(CreateFixture.appliance_manufacturer_name)

    image = page.first(".energy-rating")
    expect(image["src"]).to have_content("Hoozzi Energy Rating A")
    expect(image["alt"]).to have_content("Hoozzi energy rating a")

    register_appliance = page.first(".branded-btn")
    expect(register_appliance[:href]).to have_content(ApplianceFixture.second_manufacturer_link)

    appliance = page.find("span", text: CreateFixture.appliance_name)
    appliance_with_both = appliance.find(:xpath, "..")
    expect(appliance_with_both).to have_content(FileFixture.manual_name)
    expect(appliance_with_both).to have_content(FileFixture.document_name)

    appliance = page.find("span", text: ApplianceFixture.second_manufacturer_name)
    # Second appliance has only guide
    appliance_with_guide = appliance.find(:xpath, "..")
    expect(appliance_with_guide).not_to have_content(FileFixture.manual_name)
    expect(appliance_with_guide).to have_content(FileFixture.document_name)
  end
end
