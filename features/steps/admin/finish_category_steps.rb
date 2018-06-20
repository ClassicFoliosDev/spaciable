# frozen_string_literal: true

When(/^I create a finish category$/) do
  visit "/finish_categories"

  within ".section-actions" do
    click_on I18n.t("finish_categories.collection.add")
  end

  within ".finish_category" do
    fill_in "finish_category_name", with: FinishCategoryFixture.name
  end

  click_on I18n.t("finish_categories.form.submit")
end

Then(/^I should see the created finish category$/) do
  success_flash = t(
    "controller.success.create",
    name: FinishCategoryFixture.name
  )
  expect(page).to have_content(success_flash)

  within ".record-list" do
    expect(page).to have_content(FinishCategoryFixture.name)
  end
end

When(/^I update the finish category$/) do
  finish_category = FinishCategory.find_by(name: FinishCategoryFixture.name)
  within "[data-finish-category=\"#{finish_category.id}\"]" do
    find("[data-action='edit']").click
  end

  within ".finish_category" do
    fill_in "finish_category_name", with: FinishCategoryFixture.updated_name
  end

  click_on I18n.t("finish_categories.form.submit")
end

Then(/^I should see the updated finish category$/) do
  success_flash = t(
    "controller.success.update",
    name: FinishCategoryFixture.updated_name
  )
  expect(page).to have_content(success_flash)

  within ".record-list" do
    expect(page).not_to have_content(FinishCategoryFixture.name)
    expect(page).to have_content(FinishCategoryFixture.updated_name)
  end
end

Then(/^I should see the finish category delete complete successfully$/) do
  success_flash = t(
    "controller.success.destroy",
    name: CreateFixture.finish_category_name
  )

  expect(page).to have_content(success_flash)
  expect(page).not_to have_content(".record-list")

  within ".empty" do
    expect(page).to have_content %r{#{t("components.empty_list.add", type_name: FinishCategory.model_name.human)}}i
  end
end

Then(/^I should not see finish categories$/) do
  visit "/finish_categories"

  expect(page).to have_content("You are not authorized to access this page")
end
