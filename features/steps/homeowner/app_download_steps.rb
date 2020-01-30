Then(/^I do not see an app download reminder$/) do
  expect(page).to_not have_content(t("homeowners.components.app_download.modal_title"))
end

Then(/^I see an app download reminder$/) do
  within ".app-download-dialog" do
    expect(page).to have_content(t("homeowners.components.app_download.modal_title"))
  end
end

Then(/^the download button links to the default android app$/) do
  android_link = "https://play.google.com/store/apps/details?id=io.gonative.android.kodlkr&hl=en_GB"
  within ".app-download-dialog" do
    expect(page).to have_link(t("homeowners.components.app_download.download_app"), href: android_link)
  end
end

Then(/^the modal displays the default spaciable logo$/) do
  within ".app-download-dialog" do
    image = page.find("img")
    expect(image["src"]).to have_content("Spaciable_icon")
  end
end

When(/^I exit the modal$/) do
  within ".ui-dialog-buttonset" do
    button = find_by_id("appDismissBtn")
    button.click
  end
end

When(/^I go to another page$/) do
  within ".navbar-menu" do
    click_on(t("layouts.homeowner.nav.my_home"))
  end
end

Then(/^the download button links to the default apple app$/) do
  apple_link = BrandFixture.default_apple_link
  within ".app-download-dialog" do
    expect(page).to have_link(t("homeowners.components.app_download.download_app"), href: apple_link)
  end
end

Given(/^my developer has branded app enabled$/) do
  developer = Developer.find_by(company_name: HomeownerUserFixture.developer_name)
  BrandedApp.create(app_owner: developer)
end

Given(/^the branded app has been configured for my developer$/) do
  developer = Developer.find_by(company_name: HomeownerUserFixture.developer_name)
  branded_app = BrandedApp.find_by(app_owner: developer)

  BrandFixture.update_app_icon

  branded_app.android_link = BrandFixture.android_link
  branded_app.apple_link = BrandFixture.apple_link

  branded_app.save!
end

Then(/^the download button links to the branded android app$/) do
  android_link = BrandFixture.android_link
  within ".app-download-dialog" do
    expect(page).to have_link(t("homeowners.components.app_download.download_app"), href: android_link)
  end
end

Then(/^the modal displays the branded developer icon$/) do
  within ".app-download-dialog" do
    image = page.find("img")
    expect(image["src"]).to have_content(FileFixture.appliance_secondary_picture_name)
  end
end

Then(/^the download button links to the branded apple app$/) do
  apple_link = BrandFixture.apple_link
  within ".app-download-dialog" do
    expect(page).to have_link(t("homeowners.components.app_download.download_app"), href: apple_link)
  end
end

When(/^I click do not show again$/) do
  within ".app-download-dialog" do
    click_on(t("homeowners.components.app_download.not_again"))
  end
end
