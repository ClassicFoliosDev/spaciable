# frozen_string_literal: true

When(/^I have created an appliance_room$/) do
  CreateFixture.create_appliance_room
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
  end

  within ".e-rating" do
    image = page.find("img")

    expect(image["src"]).to have_content("Hoozzi Energy Rating A1")
    expect(image["alt"]).to have_content("Hoozzi energy rating a1")
  end
end
