# frozen_string_literal: true

When(/^I create an appliance manufacturer$/) do
  visit "/appliance_manufacturers"

  add_button = page.find("a", text: I18n.t("appliance_manufacturers.collection.add"))
  add_button.click

  within ".appliance_manufacturer" do
    fill_in "appliance_manufacturer_name", with: ApplianceManufacturerFixture.name
  end

  click_on I18n.t("appliance_manufacturers.form.submit")
end

Then(/^I should see the created appliance manufacturer$/) do
  success_flash = t(
    "controller.success.create",
    name: ApplianceManufacturerFixture.name
  )
  expect(page).to have_content(success_flash)

  within ".record-list" do
    click_on ApplianceManufacturerFixture.name
  end

  within ".appliance_manufacturer" do
    expect(page).to have_content(I18n.t("appliance_manufacturers.appliance_manufacturer.appliance_categories"))
    expect(page).to have_content(CreateFixture.appliance_category_name)
  end

  click_on I18n.t("appliance_manufacturers.show.back")
end

When(/^I create an appliance with the new appliance manufacturer$/) do
  visit "/appliances"
  click_on I18n.t("appliances.collection.create")

  within ".appliance" do
    fill_in "appliance_model_num", with: ApplianceFixture.model_num

    select_from_selectmenu :appliance_appliance_category, with: CreateFixture.appliance_category_name
    select_from_selectmenu :appliance_appliance_manufacturer, with: ApplianceManufacturerFixture.name
  end

  click_on I18n.t("appliances.form.submit")
end

When(/^I update the appliance manufacturer$/) do
  visit "/appliance_manufacturers"

  within ".record-list" do
    find("[data-action='edit']").click
  end

  within ".appliance_manufacturer" do
    fill_in "appliance_manufacturer_name", with: ApplianceManufacturerFixture.updated_name
  end

  click_on I18n.t("appliance_manufacturers.form.submit")
end

Then(/^I should see the appliance with manufacturer created successfully$/) do
  name = "#{ApplianceManufacturerFixture.name} #{ApplianceFixture.model_num}"

  success_flash = t(
    "appliances.create.success",
    name: name
  )
  expect(page).to have_content(success_flash)

  within ".record-list" do
    expect(page).to have_content(ApplianceManufacturerFixture.name)
  end
end

Then(/^I should see the updated appliance manufacturer$/) do
  success_flash = t(
    "controller.success.update",
    name: ApplianceManufacturerFixture.updated_name
  )
  expect(page).to have_content(success_flash)

  within ".tabs" do
    click_on t("appliances.collection.appliance_manufacturers")
  end

  within ".record-list" do
    expect(page).not_to have_content(ApplianceManufacturerFixture.name)
    expect(page).to have_content(ApplianceManufacturerFixture.updated_name)
  end
end

Then(/^I should see the appliance that uses it has been updated$/) do
  visit "/appliances"

  within ".record-list" do
    expect(page).not_to have_content(ApplianceManufacturerFixture.name)
    expect(page).to have_content(ApplianceManufacturerFixture.updated_name)
  end
end

Then(/^I should see the appliance manufacturer delete complete successfully$/) do
  success_flash = t(
    "controller.success.destroy",
    name: CreateFixture.appliance_manufacturer_name
  )

  expect(page).to have_content(success_flash)
  expect(page).not_to have_content(".record-list")

  within ".empty" do
    expect(page).to have_content %r{#{t("components.empty_list.add", type_name: ApplianceManufacturer.model_name.human)}}i
  end
end

Then(/^I should not see appliance manufacturers$/) do
  visit "/appliance_manufacturers"

  expect(page).to have_content("You are not authorized to access this page")
end

Then(/^I should see the appliance manufacturer delete fail$/) do
  notice = t("activerecord.errors.messages.delete_not_possible",
             name: ApplianceManufacturerFixture.name,
             types: "appliances")

  expect(page).to have_content(notice)
end
