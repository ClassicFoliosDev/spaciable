When(/^I visit the custom shortcuts tab$/) do
  within ".tabs" do
    click_on I18n.t("developments.collection.custom_tiles")
  end
end

Then(/^I see the referrals shortcut$/) do
  within ".record-list" do
    expect(page).to have_content I18n.t("activerecord.attributes.custom_tiles.features.referrals")
  end
end

Then(/^I cannot crud the shortcuts$/) do
  within ".main-container" do
    expect(page).to have_no_css(".section-actions")
  end

  within ".actions" do
    expect(page).to have_no_css(".btn")
  end
end

Then(/^I can preview the referrals the shortcut$/) do
  within ".record-list" do
    click_on I18n.t("activerecord.attributes.custom_tiles.features.referrals")
  end

  within ".section-title" do
    expect(page).to have_content I18n.t("activerecord.attributes.custom_tiles.features.referrals")
  end

  within ".tile-title" do
    expect(page).to have_content I18n.t("homeowners.dashboard.tiles.referrals.title")
  end
end

Then(/^I can add a new shortcut$/) do
  within ".section-actions" do
    click_on I18n.t("breadcrumbs.custom_tile_add")
  end
end

When(/^I navigate to a development$/) do
  within ".navbar" do
    click_on I18n.t("components.navigation.my_division")
  end

  within ".record-list" do
    click_on CreateFixture.division_development
  end
end

Then(/^I can only select features that are turned on for the development$/) do
  selector = page.find(".custom_tile_feature")

  active = ['referrals', 'home_designer', 'snagging', 'area_guide']
  inactive = ['perks', 'services', 'issues']

  active.each do |option|
    selector.find("option[value='#{option}']", visible: false)
  end

  inactive.each do |option|
    selector.find("option[value='#{option}'][disabled='disabled']", visible: false)
  end
end

When(/^I select a feature$/) do
  select "Home Designer", from: :custom_tile_feature, visible: false
end

When(/^I save the tile$/) do
  within ".form-actions-footer" do
    click_on I18n.t("custom_tiles.form.submit")
  end
end
Then(/^I see the feature tile in my custom tiles collection$/) do
  within ".record-list" do
    click_on I18n.t("activerecord.attributes.custom_tiles.features.home_designer")
  end
end

When(/^I select the document category$/) do
  select_from_selectmenu :custom_tile_category, with: "Document"
end

Then(/^there is a list of documents associated with my development$/) do
  select "Developer Document", from: :custom_tile_document_id, visible: false
  select "Development Document", from: :custom_tile_document_id, visible: false
end

When(/^I enter a title and description$/) do
  fill_in "custom_tile[title]", with: "Title"
  fill_in "custom_tile[description]", with: "Description"
end

Then(/^I see an error message$/) do
  within find(".submission-errors") do
    expect(page).to have_content ("Button " + I18n.t("activerecord.errors.messages.blank"))
  end
end

When(/^I enter button text$/) do
  fill_in "custom_tile[button]", with: "Button"
end

Then(/^I see the document shortcut$/) do
  within ".record-list" do
    click_on "Title"
  end

  within ".custom-tile-show" do
    expect(page).to have_content "Title"
    expect(page).to have_content "Development Document"
  end
end
