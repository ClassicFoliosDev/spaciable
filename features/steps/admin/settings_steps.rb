# frozen_string_literal: true

Given(/^I have run the settings seeds$/) do
  load Rails.root.join("db", "seeds", "settings_seeds.rb")
end

When(/^I navigate to the settings page$/) do
  within ".sidebar-container" do
    click_on t("components.navigation.configuration")
  end

  within ".configuration" do
    expect(page).not_to have_content("https")
    expect(page).not_to have_content("vimeo")
  end
end

When(/^I set the video link$/) do
  within ".section-data" do
    find("[data-action='edit']").click
  end

  within ".setting" do
    fill_in :setting_video_link, with: SettingsFixture.video_url
  end

  within ".form-actions-footer" do
    click_on t("admin.settings.edit.submit")
  end
end

Then(/^The video link has been configured$/) do
  within ".configuration" do
    expect(page).to have_content SettingsFixture.video_url
  end
end
