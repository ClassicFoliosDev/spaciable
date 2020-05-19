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
  sleep 0.5
  save_and_open_screenshot
  within ".section-actions" do
    click_on I18n.t("breadcrumbs.custom_tile_add")
  end
end
