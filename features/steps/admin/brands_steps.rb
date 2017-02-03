# frozen_string_literal: true
When(/^I create a brand$/) do
  visit "/"

  within ".navbar" do
    click_on t("components.navigation.developers")
  end

  click_on CreateFixture.developer_name

  click_on t("developers.collection.brands")

  click_on t("brands.collection.create")

  click_on t("brands.form.submit")
end

Then(/^I should see the created (\w+) brand$/) do |parent_type|
  parent_name = CreateFixture.send("#{parent_type}_name")
  name = t("activerecord.attributes.brand.for", name: parent_name)

  success_flash = t(
    "controller.success.create",
    name: name
  )

  expect(page).to have_content(success_flash)

  within ".brands" do
    expect(page).to have_content(name)
  end
end

When(/^I update the brand$/) do
  within ".brands" do
    find("[data-action='edit']").click
  end

  logo_full_path = FileFixture.file_path + FileFixture.logo_name
  within ".brand_logo" do
    attach_file("brand_logo",
                File.absolute_path(logo_full_path),
                visible: false)
  end

  banner_full_path = FileFixture.file_path + FileFixture.banner_name
  within ".brand_banner" do
    attach_file("brand_banner",
                File.absolute_path(banner_full_path),
                visible: false)
  end

  fill_in "brand[bg_color]", with: BrandFixture.bg_color
  fill_in "brand[button_text_color]", with: BrandFixture.button_text_color

  click_on t("rooms.form.submit")
end

Then(/^I should see the updated (\w+) brand$/) do |parent_type|
  parent_name = CreateFixture.send("#{parent_type}_name")
  name = t("activerecord.attributes.brand.for", name: parent_name)

  success_flash = t(
    "controller.success.update",
    name: name
  )

  expect(page).to have_content(success_flash)

  within ".brands" do
    click_on name
  end

  # On show page
  within ".section-header" do
    expect(page).to have_content(name)
  end

  within ".colors" do
    spans = page.all("span")

    expect(spans[0]["title"]).to have_content(BrandFixture.bg_color)
    expect(spans[5]["title"]).to have_content(BrandFixture.button_text_color)
  end

  within ".brand" do
    images = page.all("img")

    expect(images[0]["src"]).to have_content(FileFixture.logo_name)
    expect(images[0]["alt"]).to have_content(FileFixture.logo_alt)

    expect(images[1]["src"]).to have_content(FileFixture.banner_name)
    expect(images[1]["alt"]).to have_content(FileFixture.banner_alt)
  end
end

When(/^I remove an image from a brand$/) do
  click_on t("brands.show.back")

  within ".brands" do
    find("[data-action='edit']").click
  end

  within ".brand_banner" do
    remove_btn = find(".remove-btn", visible: false)
    remove_btn.click
  end

  click_on t("unit_types.form.submit")
end

Then(/^I should see the updated (\w+) brand without the image$/) do |parent_type|
  parent_name = CreateFixture.send("#{parent_type}_name")
  name = t("activerecord.attributes.brand.for", name: parent_name)

  success_flash = t(
    "controller.success.update",
    name: name
  )

  expect(page).to have_content(success_flash)

  within ".brands" do
    click_on name
  end

  # On the show page
  within ".brand_logo" do
    image = page.find("img")

    expect(image["src"]).to have_content(FileFixture.logo_name)
    expect(image["alt"]).to have_content(FileFixture.logo_alt)
  end

  within ".brand_banner" do
    expect(page).not_to have_content("img")
  end
end

When(/^I delete the developer brand$/) do
  visit "/developers"

  click_on CreateFixture.developer_name

  click_on t("developers.collection.brands")

  delete_and_confirm!
end

Then(/^I should see the (\w+) brand deletion complete successfully$/) do |parent_type|
  parent_name = CreateFixture.send("#{parent_type}_name")
  name = t("activerecord.attributes.brand.for", name: parent_name)

  success_flash = t(
    "controller.success.destroy",
    name: name
  )
  expect(page).to have_content(success_flash)

  within ".record-list" do
    expect(page).not_to have_content name
  end
end

When(/^I create a division brand$/) do
  visit "/"

  within ".navbar" do
    click_on t("components.navigation.developers")
  end

  click_on CreateFixture.developer_name
  click_on t("developers.collection.divisions")

  click_on CreateFixture.division_name
  click_on t("developers.collection.brands")

  click_on t("brands.collection.create")
  click_on t("brands.form.submit")
end

When(/^I delete the division brand$/) do
  visit "/developers"

  click_on CreateFixture.developer_name
  click_on t("developers.collection.divisions")

  click_on CreateFixture.division_name
  click_on t("developers.collection.brands")

  delete_and_confirm!
end

When(/^I create a development brand$/) do
  visit "/"

  within ".navbar" do
    click_on t("components.navigation.developers")
  end

  click_on CreateFixture.developer_name
  click_on t("developers.collection.developments")

  click_on CreateFixture.development_name
  click_on t("developers.collection.brands")

  click_on t("brands.collection.create")
  click_on t("brands.form.submit")
end

When(/^I delete the development brand$/) do
  visit "/developers"

  click_on CreateFixture.developer_name
  click_on t("developers.collection.developments")

  click_on CreateFixture.development_name
  click_on t("developers.collection.brands")

  delete_and_confirm!
end

Given(/^I am a Developer Admin$/) do
  CreateFixture.create_developer
  developer_admin = CreateFixture.create_developer_admin
  login_as developer_admin
end

Then(/^I should not be able to see developer brands$/) do
  visit "/"

  within ".navbar" do
    click_on t("components.navigation.developers")
  end

  click_on CreateFixture.developer_name

  expect(page).not_to have_content(t("developers.collection.brands"))
end

Given(/^I am a Division Admin$/) do
  CreateFixture.create_developer
  CreateFixture.create_division
  division_admin = CreateFixture.create_division_admin

  login_as division_admin
end

Then(/^I should not be able to see division brands$/) do
  visit "/"

  within ".navbar" do
    click_on t("components.navigation.developers")
  end

  click_on CreateFixture.developer_name
  click_on t("developers.collection.divisions")

  expect(page).not_to have_content(t("developers.collection.brands"))
end

Given(/^I am a Development Admin$/) do
  CreateFixture.create_developer
  CreateFixture.create_development
  development_admin = CreateFixture.create_developer_admin

  login_as development_admin
end

Then(/^I should not be able to see development brands$/) do
  visit "/"

  within ".navbar" do
    click_on t("components.navigation.developers")
  end

  click_on CreateFixture.developer_name
  click_on t("developers.collection.developments")

  expect(page).not_to have_content(t("developers.collection.brands"))
end
