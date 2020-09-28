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

Given(/^there are uneditable shortcuts$/) do
  developer = CreateFixture.developer
  development = CreateFixture.development

  developer.update_attribute(:enable_services, true)
  CustomTile.create(development_id: development.id, category: 'feature', feature: 'services', editable: false)
end

Then(/^the services shortcut is uneditable$/) do
  tile = CustomTile.last
  expect(page).not_to have_selector("[data-url='/custom_tiles/#{tile.id}']")
  find("[data-id='#{tile.id}']").trigger("click")
  within ".ui-dialog-titlebar" do
    expect(page).to have_content(t("custom_tiles.collection.uneditable_title", tile: "Services"))
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

When(/^I edit the existing shortcut$/) do
  within ".actions" do
    find(".fa-pencil").click
  end
end

When(/^I change the category to a link$/) do
  select_from_selectmenu :custom_tile_category, with: "Link"
end

When(/^I enter a link$/) do
  fill_in "custom_tile[link]", with: "www.ducks.com"
end

When(/^I enter content$/) do
  fill_in "custom_tile[title]", with: "Title"
  fill_in "custom_tile[description]", with: "Description"
  fill_in "custom_tile[button]", with: "Button"
end

Then(/^I see the link tile shortcut$/) do
  within ".record-list" do
    click_on "Title"
  end

  within ".custom-tile-show" do
    expect(page).to have_content "Title"
    expect(page).to have_content "www.ducks.com"
  end
end

Then(/^the link tile has been updated$/) do
  expect(CustomTile.where(development_id: CreateFixture.development.id).count).to eq 1
  tile = CustomTile.find_by(link: 'www.ducks.com')
  expect(tile.title).to eq "Title"
  expect(tile.category).to eq "link"
  expect(tile.feature).to eq nil
end

Given(/^there are five custom shortcuts for my development$/) do
  id = CreateFixture.development.id

  # there is one created on development creation, so add four more
  4.times do
    CustomTile.create(development_id: id, category: 'feature', feature: 'referrals')
  end
end

Then(/^I cannot add another shortcut$/) do
  expect(page).to_not have_content ("Button " + I18n.t("activerecord.errors.messages.blank"))
end

When(/^I delete a shortcut$/) do
  within ".record-list" do
    page.first(".actions").find(".fa-trash-o").click
  end

  find(".ui-dialog-buttonpane")
  within ".ui-dialog-buttonpane" do
    click_on "Delete"
  end
end

Then(/^I can add another shortcut$/) do
  within find(".notice") do
    expect(page).to have_content I18n.t("controller.success.destroy", name: "Shortcut")
  end

  find(".section-actions")
  expect(page).to have_content I18n.t("breadcrumbs.custom_tile_add")
end
