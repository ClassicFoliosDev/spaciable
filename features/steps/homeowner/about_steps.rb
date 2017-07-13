# frozen_string_literal: true
When(/^I visit the About page$/) do
  visit "/homeowners/about"
end

Then(/^I should see the about page links$/) do
  within ".branded-body" do
    expect(page).to have_content(t("components.homeowner.sub_menu.rooms"))
    expect(page).to have_content(t("components.homeowner.sub_menu.appliances"))
    expect(page).to have_content(t("components.homeowner.sub_menu.library"))
    expect(page).to have_content(t("components.homeowner.sub_menu.faqs"))
  end
end
