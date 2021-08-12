# frozen_string_literal: true

When(/^I create a brand$/) do
  visit "/"

  within ".navbar" do
    click_on t("components.navigation.developers")
  end

  click_on CreateFixture.developer_name
  click_on t("developers.collection.brands")

  click_on t("brands.collection.create")
  logo_full_path = FileFixture.file_path + FileFixture.logo_name
  within ".brand_logo" do
    attach_file("brand_logo",
                File.absolute_path(logo_full_path),
                visible: false)
  end

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

  within ".record-list" do
    expect(page).to have_content(name)
  end
end

When(/^I update the brand$/) do
  within ".record-list" do
    find("[data-action='edit']").click
  end

  banner_full_path = FileFixture.file_path + FileFixture.banner_name
  within ".brand_banner" do
    attach_file("brand_banner",
                File.absolute_path(banner_full_path),
                visible: false)
  end

  login_image_path = FileFixture.file_path + FileFixture.login_image_name
  within ".brand_login_image" do
    attach_file("brand_login_image",
                File.absolute_path(login_image_path),
                visible: false)
  end

  email_logo_path = FileFixture.file_path + FileFixture.email_logo_name
  within ".brand_email_logo" do
    attach_file("brand_email_logo",
                File.absolute_path(email_logo_path),
                visible: false)
  end

  fill_in "brand[bg_color]", with: BrandFixture.bg_color
  fill_in "brand[button_text_color]", with: BrandFixture.button_text_color
  fill_in "brand[header_color]", with: BrandFixture.header_color
end

Then(/^I should be able to preview the brand$/) do
  within ".preview-container" do
    click_on t("brands.form.preview")
  end
  # Header background color has been customised
  header = page.find(".header")
  expect(header[:style]).to have_content("background-color: rgb(137, 0, 51)")

  # Logo has been customised, expect it to have the customised alt tag
  within ".header" do
    image = page.find("img")
    expect(image["src"]).to have_content(FileFixture.logo_name)
    expect(image["alt"]).to have_content(t("brands.preview.logo"))

    button = page.find("button")
    expect(button[:style]).to have_content("background-color: rgb(24, 168, 149)")
    expect(button[:style]).to have_content("color: rgb(85, 106, 65)")
  end

  # Banner has not been customised, expect it to have the default alt tag
  within ".banner" do
    image = page.find("img")
    expect(image["src"]).to have_content(FileFixture.default_banner_name)
    expect(image["alt"]).to have_content(t("activerecord.attributes.brand.banner"))
  end

  within ".content" do
    div = page.first("div")
    expect(div[:style]).to have_content("background-color: rgb(255, 255, 255)")
    expect(div[:style]).to have_content("color: rgb(234, 234, 234)")

    button = page.find("button")
    expect(button[:style]).to have_content("background-color: rgb(85, 106, 65)")
    expect(button[:style]).to have_content("color: rgb(24, 168, 149)")
  end

  within ".ui-dialog-titlebar" do
    button = page.find("button")
    button.click
  end

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

  within ".record-list" do
    click_on name
  end

  # On show page
  within ".section-header" do
    expect(page).to have_content(name)
  end

  within ".internal-colors" do
    spans = page.all("span")

    expect(spans[0]["title"]).to have_content(BrandFixture.bg_color)
    expect(spans[5]["title"]).to have_content(BrandFixture.button_text_color)
    expect(spans[6]["title"]).to have_content(BrandFixture.header_color)
  end

  within ".brand" do
    images = page.all("img")

    expect(images[0]["src"]).to have_content(FileFixture.logo_name)
    expect(images[0]["alt"]).to have_content(FileFixture.logo_alt)

    expect(images[1]["src"]).to have_content(FileFixture.banner_name)
    expect(images[1]["alt"]).to have_content(FileFixture.banner_alt)

    expect(images[2]["src"]).to have_content(FileFixture.login_image_name)
    expect(images[2]["alt"]).to have_content(FileFixture.login_image_alt)

    expect(images[3]["src"]).to have_content(FileFixture.email_logo_name)
    expect(images[3]["alt"]).to have_content(FileFixture.email_logo_alt)
  end
end

When(/^I remove an image from a brand$/) do
  click_on t("brands.show.back")

  within ".record-list" do
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

  within ".record-list" do
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

When(/^I remove a login image from a brand$/) do
  within ".section-data" do
    find("[data-action='edit']").click
  end

  within ".brand_login_image" do
    remove_btn = find(".remove-btn", visible: false)
    find('.remove-btn').trigger('click')
  end

  click_on t("unit_types.form.submit")
end

Then(/^I should see the (\w+) login image is no longer present$/) do |parent_type|
  parent_name = CreateFixture.send("#{parent_type}_name")
  name = t("activerecord.attributes.brand.for", name: parent_name)

  success_flash = t(
    "controller.success.update",
    name: name
  )

  expect(page).to have_content(success_flash)

  within ".record-list" do
    click_on name
  end

  # On the show page
  within ".brand_logo" do
    image = page.find("img")

    expect(image["src"]).to have_content(FileFixture.logo_name)
    expect(image["alt"]).to have_content(FileFixture.logo_alt)
  end

  within ".brand_login_image" do
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

  expect(page).not_to have_content(".record-list")

  within ".empty" do
    expect(page).to have_content %r{#{t("components.empty_list.add", action: "Add", type_name: Brand.model_name.human)}}i
  end
end

When(/^I create a division brand$/) do
  division = CreateFixture.division
  visit "/divisions/#{division.id}/brands"

  within ".styling" do
    click_on t("brands.collection.create")
  end

  logo_full_path = FileFixture.file_path + FileFixture.logo_name
  within ".brand_logo" do
    attach_file("brand_logo",
                File.absolute_path(logo_full_path),
                visible: false)
  end

  within ".new_brand" do
    click_on t("brands.form.submit")
  end
end

When(/^I delete the division brand$/) do
  division = CreateFixture.division
  visit "/divisions/#{division.id}/brands"

  delete_and_confirm!
end

When(/^I create a development brand$/) do
  goto_development_show_page

  within ".tabs" do
    click_on t("developers.collection.brands")
  end

  click_on t("brands.collection.create")
  logo_full_path = FileFixture.file_path + FileFixture.logo_name
  within ".brand_logo" do
    attach_file("brand_logo",
                File.absolute_path(logo_full_path),
                visible: false)
  end

  click_on t("brands.form.submit")
end

When(/^there is a development phase$/) do
  CreateFixture.create_development_phase
end

When(/^I create a phase brand$/) do
  goto_development_phase_show_page

  within ".tabs" do
    click_on t("phases.collection.brands")
  end

  click_on t("brands.collection.create")
  logo_full_path = FileFixture.file_path + FileFixture.logo_name
  within ".brand_logo" do
    attach_file("brand_logo",
                File.absolute_path(logo_full_path),
                visible: false)
  end

  click_on t("brands.form.submit")
end

When(/^I delete the development brand$/) do
  goto_development_show_page

  within ".tabs" do
    click_on t("developers.collection.brands")
  end

  delete_and_confirm!(scope: ".styling")
end

When(/^I delete the phase brand$/) do
  goto_development_phase_show_page

  within ".tabs" do
    click_on t("phases.collection.brands")
  end

  delete_and_confirm!(scope: ".styling")
end

Then(/^I should not be able to see (.*)(d.*) brands$/) do |additional, noun|
  visit "/"
  sleep 0.5

  click_on t("components.navigation.my_area",
             area: AdditionalRoleFixture.additional?(additional) ? noun.capitalize().pluralize() : noun.capitalize())

  find(:xpath, "//a[@title='#{AdditionalRoleFixture::ADDITIONAL}']").trigger('click') if AdditionalRoleFixture.additional?(additional)
  expect(page).not_to have_content(t("#{noun}s.collection.brands"))
end
