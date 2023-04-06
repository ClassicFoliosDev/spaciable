When(/^I visit the spotlights tab$/) do
  within ".tabs" do
    click_on I18n.t("developments.collection.spotlights")
  end
end

Then(/^I see the referrals spotlight$/) do
  within ".record-list" do
    expect(page).to have_content I18n.t("activerecord.attributes.custom_tiles.features.referrals")
  end
end

Given(/^there are uneditable spotlights$/) do
  developer = CreateFixture.developer
  development = CreateFixture.development

  developer.update_attribute(:enable_services, true)
  spotlight = Spotlight.create(development_id: development.id, editable: false)
  CustomTile.create(spotlight_id: spotlight.id, category: 'feature', feature: 'services')
end

Then(/^the services spotlight is uneditable$/) do
  spotlight = Spotlight.last
  expect(page).not_to have_selector("[data-url='/spotlights/#{spotlight.id}']")
  find("[data-id='#{spotlight.id}']").trigger("click")
  within ".ui-dialog-titlebar" do
    expect(page).to have_content(t("spotlights.collection.uneditable_title", tile: "Services"))
  end
end

Then(/^I cannot crud the spotlights$/) do
  within ".main-container" do
    expect(page).to have_no_css(".section-actions .fa-plus")
  end

  within ".record-list tbody" do
    expect(page).to have_no_css(".btn")
  end
end

Then(/^I can preview the referrals the spotlight$/) do
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

Then(/^I can add a new spotlight$/) do
  within ".section-actions" do
    find("a.btn.btn-primary").trigger('click')
    sleep 5
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
  selector = page.find(".spotlight_custom_tiles_feature")

  active = ['referrals', 'home_designer', 'snagging', 'area_guide', 'perks', 'services']
  inactive = ['issues']

  active.each do |option|
    selector.find("option[value='#{option}']", visible: false)
  end

  inactive.each do |option|
    selector.find("option[value='#{option}'][disabled='disabled']", visible: false)
  end
end

When(/^I select a feature$/) do
  select "Home Designer", from: :spotlight_custom_tiles_attributes_0_feature, visible: false
end

When(/^I save the tile$/) do
  within ".form-actions-footer" do
    click_on I18n.t("spotlights.form.submit")
  end
end
Then(/^I see the feature tile in my custom tiles collection$/) do
  within ".record-list" do
    click_on I18n.t("activerecord.attributes.custom_tiles.features.home_designer")
  end
end

When(/^I select the document category$/) do
  select_from_selectmenu :spotlight_custom_tiles_category, with: "Document"
end

Then(/^there is a list of documents associated with my development$/) do
  select "Developer Document", from: :spotlight_custom_tiles_attributes_0_document_id, visible: false
  select "Development Document", from: :spotlight_custom_tiles_attributes_0_document_id, visible: false
end

When(/^I enter a title and description$/) do

  fill_in "spotlight[custom_tiles_attributes][0][title]", with: "Title"
  fill_in "spotlight[custom_tiles_attributes][0][description]", with: "Description"
end

Then(/^I see an error message$/) do
  within find(".submission-errors") do
    expect(page).to have_content ("Custom tiles button" + I18n.t("activerecord.errors.messages.blank"))
  end
end

When(/^I enter button text$/) do
  fill_in "spotlight[custom_tiles_attributes][0][button]", with: "Button"
end

Then(/^I see the document spotlight$/) do
  within ".record-list" do
    click_on "Title"
  end

  within ".custom-tile-show" do
    expect(page).to have_content "Title"
    expect(page).to have_content "Development Document"
  end
end

When(/^I edit the existing spotlight$/) do
  find(".fa-pencil").click
end

When(/^I change the category to a link$/) do
  select_from_selectmenu :spotlight_custom_tiles_category, with: "Link"
end

When(/^I enter a link$/) do
  fill_in "spotlight[custom_tiles_attributes][0][link]", with: "www.ducks.com"
end

When(/^I enter content$/) do
  fill_in "spotlight[custom_tiles_attributes][0][title]", with: "Title"
  fill_in "spotlight[custom_tiles_attributes][0][description]", with: "Description"
  fill_in "spotlight[custom_tiles_attributes][0][button]", with: "Button"
end

Then(/^I see the link tile spotlight$/) do
  within ".record-list" do
    click_on "Title"
  end

  within ".custom-tile-show" do
    expect(page).to have_content "Title"
    expect(page).to have_content "www.ducks.com"
  end
end

Then(/^the link tile has been updated$/) do
  expect(Spotlight.joins(:custom_tiles).where(development_id: CreateFixture.development.id, custom_tiles: { feature: "referrals"}).count).to eq 1
  tile = CustomTile.find_by(link: 'www.ducks.com')
  expect(tile.title).to eq "Title"
  expect(tile.category).to eq "link"
  expect(tile.feature).to eq nil
end

Given(/^there are five spotlights for my development$/) do
  id = CreateFixture.development.id


  (5 - Spotlight.where(development_id: id).count).times do
    spotlight = Spotlight.create(development_id: id)
    CustomTile.create(spotlight: spotlight, category: 'feature', feature: 'referrals')
  end
end

Then(/^I cannot add another spotlight$/) do
  expect(page).to_not have_content ("Button " + I18n.t("activerecord.errors.messages.blank"))
end

When(/^I delete a spotlight$/) do
  within ".record-list" do
    page.all(".two-actions").last.find(".fa-trash-o").click
  end

  find(".ui-dialog-buttonpane")
  within ".ui-dialog-buttonpane" do
    click_on "Delete"
  end
end

Then(/^I can add another spotlight$/) do
  within find(".notice") do
    expect(page).to have_content I18n.t("controller.success.destroy", name: "Spotlight")
  end

  find(".section-actions")
  expect(page).to have_content I18n.t("breadcrumbs.spotlight_add")
end
