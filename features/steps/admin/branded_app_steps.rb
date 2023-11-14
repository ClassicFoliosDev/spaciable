# frozen_string_literal: true

Then(/^I cannot see the branded app tab$/) do
  within ".tabs" do
    expect(page).to_not have_content(t("developers.collection.branded_apps"))
  end
end

Then(/^no branded app record should be created$/) do
  branded_app_count = BrandedApp.all.count
  expect(branded_app_count == 0)
end

When(/^I update the branded app developer$/) do
  find("[data-action='edit']").click

  check "developer_personal_app"

  click_on t("developers.form.submit")
end

Then(/^I can see the branded app tab$/) do
  within ".tabs" do
    expect(page).to have_content(t("developers.collection.branded_apps"))
  end
end

Then(/^the branded app record has been created$/) do
  branded_app = BrandedApp.first
  expect(branded_app.app_owner_id == CreateFixture.developer.id)
end

When(/^I update the branded app with invalid data$/) do
  within ".tabs" do
    click_on(t("developers.collection.branded_apps"))
  end

  fill_in "branded_app[android_link]", with: "12345"
  fill_in "branded_app[apple_link]", with: BrandFixture.apple_link

  within ".form-actions-footer" do
    click_on(t("branded_apps.form.submit"))
  end
end

Then(/^I see an error that I cannot update the branded app$/) do
  within ".error" do
    expect(page).to have_content(t("activerecord.errors.messages.url_format"))
  end
end

When(/^I update the branded app with valid data$/) do
  picture_full_path = FileFixture.file_path + FileFixture.avatar_name
  within ".branded_app_app_icon" do
    attach_file("branded_app_app_icon",
                File.absolute_path(picture_full_path),
                visible: false)
  end

  fill_in "branded_app[android_link]", with: BrandFixture.android_link
  fill_in "branded_app[apple_link]", with: BrandFixture.apple_link

  within ".form-actions-footer" do
    click_on(t("branded_apps.form.submit"))
  end
end

Then(/^I see the branded app data has been updated$/) do
  within ".notice" do
    expect(page).to have_content(t("controller.success.update", name: "#{CreateFixture.developer_name} Branded App"))
  end

  image = page.find(".image-preview")
  expect(image["src"]).to have_content(FileFixture.avatar_name)

  expect(find_field("branded_app[android_link]").value).to eq BrandFixture.android_link
  expect(find_field("branded_app[apple_link]").value).to eq BrandFixture.apple_link
end

Then(/^the branded app record has been updated$/) do
  branded_app = BrandedApp.find_by(app_owner_id: CreateFixture.developer.id)

  expect(branded_app.android_link == BrandFixture.android_link)
  expect(branded_app.apple_link == BrandFixture.apple_link)
  expect(branded_app.app_icon == FileFixture.avatar_name)
end

When(/^I update the branded app developer and uncheck branded app$/) do
  find("[data-action='edit']").click

  uncheck "developer_personal_app"

  click_on t("developers.form.submit")
end

Then(/^the branded app record has been deleted$/) do
  branded_app = BrandedApp.find_by(app_owner_id: CreateFixture.developer.id)
  expect(branded_app == nil)
end
