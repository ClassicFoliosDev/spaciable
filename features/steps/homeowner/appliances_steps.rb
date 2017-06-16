# frozen_string_literal: true
When(/^I visit the appliances page$/) do
  visit "/"

  within ".navbar-menu" do
    click_on t("layouts.homeowner.nav.my_home")
  end

  within ".sub-navigation-container" do
    click_on t("layouts.homeowner.sub_nav.appliances")
  end
end

Given(/^there is a second appliance$/) do
  manufacturer = FactoryGirl.create(:manufacturer, name: ApplianceFixture.second_manufacturer_name)
  category = FactoryGirl.create(:appliance_category, name: ApplianceFixture.second_appliance_category_name)

  appliance = FactoryGirl.create(:appliance,
                                 manufacturer: manufacturer,
                                 appliance_category: category,
                                 model_num: ApplianceFixture.second_model_num)

  FactoryGirl.create(:appliance_room, room: CreateFixture.room, appliance: appliance)
end

Then(/^I should see the appliances for my plot$/) do
  within ".appliances" do
    expect(page).to have_content(CreateFixture.appliance_category_name)
    expect(page).to have_content(CreateFixture.appliance_manufacturer_name)

    image = page.first(".energy-rating")
    expect(image["src"]).to have_content("Hoozzi Energy Rating A")
    expect(image["alt"]).to have_content("Hoozzi energy rating a")

    register_appliance = page.first(".branded-btn")
    expect(register_appliance[:href]).to have_content(CreateFixture.manufacturer_link)

    appliance = page.find("span", text: CreateFixture.appliance_name)
    appliance_with_both = appliance.find(:xpath, "..")
    expect(appliance_with_both).to have_link("Download", href: ApplianceFixture.manual_url)
    expect(appliance_with_both).to have_link("Download", href: ApplianceFixture.guide_url)

    appliance = page.find("span", text: ApplianceFixture.second_manufacturer_name)
    # Second appliance has only guide
    appliance_with_guide = appliance.find(:xpath, "..")
    expect(appliance_with_guide).not_to have_content(FileFixture.manual_name)
    expect(appliance_with_guide).not_to have_content(FileFixture.document_name)
  end
end
