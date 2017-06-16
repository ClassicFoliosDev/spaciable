# frozen_string_literal: true
When(/^I create an appliance_category$/) do
  visit "/appliance_categories"

  within ".section-actions" do
    click_on I18n.t("appliance_categories.collection.add")
  end

  within ".appliance_category" do
    fill_in "appliance_category_name", with: ApplianceCategoryFixture.name
  end

  click_on I18n.t("appliance_categories.form.submit")
end

Then(/^I should see the created appliance_category$/) do
  success_flash = t(
    "controller.success.create",
    name: ApplianceCategoryFixture.name
  )
  expect(page).to have_content(success_flash)

  within ".record-list" do
    expect(page).to have_content(ApplianceCategoryFixture.name)
  end
end

When(/^I update the appliance_category$/) do
  appliance_category = ApplianceCategory.find_by(name: ApplianceCategoryFixture.name)
  within "[data-appliance_category=\"#{appliance_category.id}\"]" do
    find("[data-action='edit']").click
  end

  within ".appliance_category" do
    fill_in "appliance_category_name", with: ApplianceCategoryFixture.updated_name
  end

  click_on I18n.t("appliance_categories.form.submit")
end

Then(/^I should see the updated appliance_category$/) do
  success_flash = t(
    "controller.success.update",
    name: ApplianceCategoryFixture.updated_name
  )
  expect(page).to have_content(success_flash)

  within ".record-list" do
    expect(page).not_to have_content(ApplianceCategoryFixture.name)
    expect(page).to have_content(ApplianceCategoryFixture.updated_name)
  end
end

When(/^I create an appliance with the new appliance_category$/) do
  visit "/appliances"
  click_on I18n.t("appliances.collection.create")

  within ".appliance" do
    fill_in "appliance_model_num", with: ApplianceFixture.model_num

    select_from_selectmenu :appliance_appliance_category, with: ApplianceCategoryFixture.updated_name
    select_from_selectmenu :appliance_manufacturer, with: CreateFixture.appliance_manufacturer_name
  end

  click_on I18n.t("appliances.form.submit")
end

Then(/^I should see the appliance created successfully$/) do
  name = "#{CreateFixture.appliance_manufacturer_name} #{ApplianceFixture.model_num}"

  success_flash = t(
    "controller.success.create",
    name: name
  )
  expect(page).to have_content(success_flash)

  within ".record-list" do
    click_on name
  end

  expect(page).to have_content(ApplianceCategoryFixture.updated_name)
end

When(/^I delete the appliance_category$/) do
  visit "/appliance_categories"
  delete_and_confirm!
end

Then(/^I should see the appliance_category delete complete successfully$/) do
  success_flash = t(
    "controller.success.destroy",
    name: CreateFixture.appliance_category_name
  )

  expect(page).to have_content(success_flash)
  expect(page).not_to have_content(".record-list")

  within ".empty" do
    expect(page).to have_content t("components.empty_list.add", type_name: ApplianceCategory.model_name.human.downcase)
  end
end

Then(/^I should not see appliance_categories$/) do
  visit "/appliance_categories"

  expect(page).to have_content("You are not authorized to access this page")
end
