# frozen_string_literal: true

When(/^I search for a search term$/) do
  visit "/"

  within ".search-container" do
    fill_in "search_search_text", with: CreateFixture.finish_name
    find(".search-btn").click
  end
end

Then(/^I should see the finish in the search results$/) do
  within ".search-results" do
    expect(page).to have_content("Finish #{CreateFixture.finish_name}")
  end
end

Then(/^I should see the appliance in the search results$/) do
  within ".search-results" do
    expect(page).to have_content("Appliance #{CreateFixture.full_appliance_name}")
  end
end

Then(/^I should be able to navigate to the finish$/) do
  within ".search-results" do
    click_on("Finish #{CreateFixture.finish_name}")
  end

  within ".section-title" do
    expect(page).to have_content(CreateFixture.finish_name)
  end

  within ".finish" do
    expect(page).to have_content(CreateFixture.finish_category_name)
  end
end

When(/^I search for a partial search term$/) do
  within ".search-container" do
    fill_in "search_search_text", with: "WAB281"
    find(".search-btn").click
  end
end

Then(/^I should be able to navigate to the appliance$/) do
  within ".search-results" do
    click_on("Appliance #{CreateFixture.full_appliance_name}")
  end

  within ".section-title" do
    expect(page).to have_content(CreateFixture.full_appliance_name)
  end

  within ".appliance" do
    expect(page).to have_content(CreateFixture.appliance_category)
    expect(page).to have_content(CreateFixture.appliance_manufacturer_name)
  end
end

When(/^there are no matches$/) do
  within ".search-container" do
    fill_in "search_search_text", with: "wordnotindb"
    find(".search-btn").click
  end
end

Then(/^I should see no matches$/) do
  within ".search-results" do
    expect(page).to have_content(I18n.t("admin.search.new.no_match"))
  end
end

Then(/^I should not see the search widget$/) do
  visit "/"

  within ".header-container" do
    expect(page).not_to have_selector(".search-container")
  end
end
