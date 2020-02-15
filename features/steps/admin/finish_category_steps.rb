# frozen_string_literal: true

When(/^I create a finish category$/) do
  visit "/finish_categories"

  click_on I18n.t("finish_categories.collection.add")

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

Then(/^I should see the updated finish category delete complete successfully$/) do
  success_flash = t(
    "controller.success.destroy",
    name: FinishCategoryFixture.updated_name
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

Then(/^I should see an empty list of finish categories$/) do
  visit "/finish_categories"

  expect(page).to have_content("You have no finish categories")
  expect(page).not_to have_content("You are not authorized to access this page")
end

When(/^I CRUD finish categories as a (.*)$/) do |role|
  many_steps(<<-GHERKIN)
    Given I am logged in as a #{role} with CAS
    Then I should see an empty list of finish categories
    When I create a finish category
    Then I should see the created finish category
    When I update the finish category
    Then I should see the updated finish category
    When I delete the updated finish category
    Then I should see the updated finish category delete complete successfully
  GHERKIN
end
