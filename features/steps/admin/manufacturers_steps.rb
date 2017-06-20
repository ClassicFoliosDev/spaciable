# frozen_string_literal: true
When(/^I create a manufacturer$/) do
  visit "/manufacturers"

  add_button = page.find("a", text: I18n.t("manufacturers.collection.add"))
  add_button.click

  within ".manufacturer" do
    fill_in "manufacturer_name", with: ManufacturerFixture.name
  end

  click_on I18n.t("manufacturers.form.submit")
end

Then(/^I should see the created manufacturer$/) do
  success_flash = t(
    "controller.success.create",
    name: ManufacturerFixture.name
  )
  expect(page).to have_content(success_flash)

  within ".record-list" do
    expect(page).to have_content(ManufacturerFixture.name)
    expect(page).to have_content(I18n.t("manufacturers.collection.appliances"))
  end

  within ".record-list" do
    click_on(ManufacturerFixture.name)
  end

  within ".manufacturer" do
    expect(page).to have_content(I18n.t("manufacturers.manufacturer.appliance_categories"))
    expect(page).to have_content(CreateFixture.appliance_category_name)
  end

  click_on I18n.t("manufacturers.show.back")
end

When(/^I create an appliance with the new manufacturer$/) do
  visit "/appliances"
  click_on I18n.t("appliances.collection.create")

  within ".appliance" do
    fill_in "appliance_model_num", with: ApplianceFixture.model_num

    select_from_selectmenu :appliance_appliance_category, with: CreateFixture.appliance_category_name
    select_from_selectmenu :appliance_manufacturer, with: ManufacturerFixture.name
  end

  click_on I18n.t("appliances.form.submit")
end

Then(/^I should see the appliance with manufacturer created successfully$/) do
  name = "#{ManufacturerFixture.name} #{ApplianceFixture.model_num}"

  success_flash = t(
    "controller.success.create",
    name: name
  )
  expect(page).to have_content(success_flash)

  within ".record-list" do
    click_on name
  end

  expect(page).to have_content(ManufacturerFixture.name)
end

When(/^I update the manufacturer$/) do
  visit "/manufacturers"

  manufacturer = Manufacturer.find_by(name: ManufacturerFixture.name)
  within "[data-manufacturer=\"#{manufacturer.id}\"]" do
    find("[data-action='edit']").click
  end

  within ".manufacturer" do
    fill_in "manufacturer_name", with: ManufacturerFixture.updated_name
    page.find("#manufacturer_assign_to_appliances_false").set(true)
  end

  click_on I18n.t("manufacturers.form.submit")
end

Then(/^I should be required to enter a finish category$/) do
  expect(page).to have_content(I18n.t("activerecord.errors.models.manufacturer.attributes.finish_category_id.required_if_finish"))

  within ".manufacturer" do
    page.find("#manufacturer_assign_to_appliances_false").set(true)
    select CreateFixture.finish_category_name, from: :manufacturer_finish_category_id, visible: false
  end

  click_on I18n.t("manufacturers.form.submit")
end

Then(/^I should see the updated manufacturer$/) do
  success_flash = t(
    "controller.success.update",
    name: ManufacturerFixture.updated_name
  )
  expect(page).to have_content(success_flash)

  within ".tabs" do
    click_on t("finishes.collection.manufacturers")
  end

  within ".record-list" do
    expect(page).not_to have_content(ManufacturerFixture.name)

    expect(page).to have_content(CreateFixture.appliance_manufacturer_name)
    expect(page).to have_content(ManufacturerFixture.updated_name)
    expect(page).to have_content(I18n.t("manufacturers.collection.finishes"))
  end

  within ".record-list" do
    click_on(ManufacturerFixture.updated_name)
  end

  within ".manufacturer" do
    expect(page).to have_content(I18n.t("manufacturers.manufacturer.finish_types"))
    expect(page).to have_content(CreateFixture.finish_type_name)
  end
end

When(/^I delete the manufacturer$/) do
  visit "/manufacturers"
  delete_and_confirm!
end

When(/^I create a finish with the new manufacturer$/) do
  visit "/finishes"
  click_on I18n.t("finishes.collection.create")

  within ".finish" do
    fill_in "finish_name", with: FinishFixture.name

    select_from_selectmenu :finish_category, with: CreateFixture.finish_category_name
    select_from_selectmenu :finish_type, with: CreateFixture.finish_type_name
    select_from_selectmenu :manufacturer, with: ManufacturerFixture.updated_name
  end

  click_on I18n.t("finishes.form.submit")
end

Then(/^I should see the finish with manufacturer created successfully$/) do
  success_flash = t(
    "controller.success.create",
    name: FinishFixture.name
  )
  expect(page).to have_content(success_flash)

  within ".record-list" do
    click_on FinishFixture.name
  end

  expect(page).to have_content(ManufacturerFixture.updated_name)
end

Then(/^I should see the manufacturer delete complete successfully$/) do
  success_flash = t(
    "controller.success.destroy",
    name: CreateFixture.appliance_manufacturer_name
  )

  expect(page).to have_content(success_flash)
  expect(page).not_to have_content(".record-list")

  within ".empty" do
    expect(page).to have_content t("components.empty_list.add", type_name: Manufacturer.model_name.human.downcase)
  end
end

Then(/^I should not see manufacturers$/) do
  visit "/manufacturers"

  expect(page).to have_content("You are not authorized to access this page")
end
