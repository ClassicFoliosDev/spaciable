# frozen_string_literal: true

When(/^I create an appliance category$/) do
  visit "/appliance_categories"

  within ".section-actions" do
    click_on I18n.t("appliance_categories.collection.add")
  end

  within ".appliance_category" do
    fill_in "appliance_category_name", with: ApplianceCategoryFixture.name
  end

  click_on I18n.t("appliance_categories.form.submit")
end

Then(/^I should see the created appliance category$/) do
  success_flash = t(
    "controller.success.create",
    name: ApplianceCategoryFixture.name
  )
  expect(page).to have_content(success_flash)

  within ".record-list" do
    click_on ApplianceCategoryFixture.name
  end

  within ".appliance_category" do
    expect(page).to have_content(I18n.t("appliance_categories.appliance_category.manufacturers"))
    expect(page).to have_content(CreateFixture.appliance_manufacturer_name)
  end

  click_on I18n.t("appliance_manufacturers.show.back")
end

When(/^I update the appliance category$/) do
  appliance_category = ApplianceCategory.find_by(name: ApplianceCategoryFixture.name)
  within "[data-appliance-category=\"#{appliance_category.id}\"]" do
    find("[data-action='edit']").click
  end

  within ".appliance_category" do
    fill_in "appliance_category_name", with: ApplianceCategoryFixture.updated_name
  end

  click_on I18n.t("appliance_categories.form.submit")
end

Then(/^I should see the updated appliance category$/) do
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

Then(/^I should see the appliance category delete complete successfully$/) do
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

Then(/^I should not see appliance categories$/) do
  visit "/appliance_categories"

  expect(page).to have_content("You are not authorized to access this page")
end
