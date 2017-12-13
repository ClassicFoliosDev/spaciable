# frozen_string_literal: true

Given(/^I am logged in as a homeowner want to download my documents$/) do
  MyLibraryFixture.setup
  MyLibraryFixture.create_documents

  login_as CreateFixture.resident
  visit "/"
end

Then(/^I should see recent documents added to my library$/) do
  within ".library-component" do
    MyLibraryFixture.recent_documents.each do |title, _download_link|
      expect(page).to have_content(title)
    end
  end

  click_on t("homeowner.dashboard.cards.library.view_more")
end

When(/^I go to download the documents for my home$/) do
  within ".navbar" do
    click_on t("layouts.homeowner.nav.my_home")
  end

  within ".sub-navigation-container" do
    click_on t("layouts.homeowner.sub_nav.library")
  end
end

Then(/^I should see all of the documents related to my home$/) do
  within ".documents" do
    MyLibraryFixture.default_filtered_documents.each do |title, download_link|
      expect(page).to have_content(title)

      anchor = first("a[href='#{download_link}']")
      expect(anchor).not_to be_nil
    end

    MyLibraryFixture.default_filtered_out_documents.each do |title, download_link|
      expect(page).not_to have_content(title)

      anchor = first("a[href='#{download_link}']")
      expect(anchor).to be_nil
    end
  end

  within ".branded-hero" do
    active_category = find(".categories .active").text
    expect(active_category).to eq(MyLibraryFixture.default_category_name)
  end
end

When(/^I filter my documents by a different category$/) do
  click_on MyLibraryFixture.other_category_name
end

Then(/^I should only see the documents for the other category$/) do
  within ".documents" do
    MyLibraryFixture.filtered_documents.each do |title, download_link|
      expect(page).to have_content(title)

      anchor = first("a[href='#{download_link}']")
      expect(anchor).not_to be_nil
    end

    MyLibraryFixture.filtered_out_documents.each do |title, download_link|
      expect(page).not_to have_content(title)

      anchor = first("a[href='#{download_link}']")
      expect(anchor).to be_nil
    end
  end

  within ".branded-hero" do
    active_category = find(".categories .active").text
    expect(active_category).to eq(MyLibraryFixture.other_category_name)
  end
end

When(/^I filter the documents by appliances$/) do
  within ".categories" do
    click_on MyLibraryFixture.appliances_category_name
  end
end

Then(/^I should only see the appliance manuals to download$/) do
  within ".branded-body" do
    MyLibraryFixture.appliance_manuals.each do |title|
      expect(page).to have_content(title)
    end

    # Appliance guide
    within ".row" do
      expect(page).to have_content(t("homeowners.appliances.show.guide"))
      expect(page).to have_content(t("homeowners.appliances.show.manual"))
    end

    MyLibraryFixture.not_appliance_manuals.each do |title|
      expect(page).not_to have_content(title)
    end
  end

  within ".hero-text" do
    active_category = find(".categories .active").text
    expect(active_category).to eq(MyLibraryFixture.appliances_category_name)
  end
end

Then(/^I should not see plot documents in the dashboard$/) do
  within ".library-component" do
    expect(page).to have_content("Developer Document")
    expect(page).to have_content("Development Document")
    expect(page).not_to have_content("Phase Plot Document")
  end
end

When(/^I visit the library page$/) do
  visit "/homeowners/library/my_home"
end

Then(/^I should not see plot documents$/) do
  within ".documents" do
    expect(page).to have_content("Developer Document")
    expect(page).to have_content("Development Document")
    expect(page).not_to have_content("Phase Plot Document")
  end
end
