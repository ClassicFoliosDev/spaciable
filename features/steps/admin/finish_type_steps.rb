# frozen_string_literal: true
When(/^I create a finish_type$/) do
  visit "/finish_types"

  within ".empty" do
    click_on I18n.t("finish_types.collection.add")
  end

  within ".finish_type" do
    fill_in "finish_type_name", with: FinishTypeFixture.name
    select_from_selectmenu "finish-type-finish-category", with: CreateFixture.finish_category_name
  end

  click_on I18n.t("finish_types.form.submit")
end

Then(/^I should see the created finish_type$/) do
  success_flash = t(
    "controller.success.create",
    name: FinishTypeFixture.name
  )
  expect(page).to have_content(success_flash)

  within ".record-list" do
    expect(page).to have_content(FinishTypeFixture.name)
  end
end

When(/^I update the finish_type$/) do
  finish_type = FinishType.find_by(name: FinishTypeFixture.name)
  within "[data-finish_type=\"#{finish_type.id}\"]" do
    find("[data-action='edit']").click
  end

  within ".finish_type" do
    fill_in "finish_type_name", with: FinishTypeFixture.updated_name
  end

  click_on I18n.t("finish_types.form.submit")
end

Then(/^I should see the updated finish_type$/) do
  success_flash = t(
    "controller.success.update",
    name: FinishTypeFixture.updated_name
  )
  expect(page).to have_content(success_flash)

  within ".record-list" do
    expect(page).not_to have_content(FinishTypeFixture.name)
    expect(page).to have_content(FinishTypeFixture.updated_name)
  end
end

When(/^I create a finish with the new finish_type$/) do
  visit "/finishes"
  click_on I18n.t("finishes.collection.create")

  within ".finish" do
    fill_in "finish_name", with: FinishFixture.name

    select_from_selectmenu :finish_finish_category, with: CreateFixture.finish_category_name
    select_from_selectmenu :finish_finish_type, with: FinishTypeFixture.updated_name
  end

  click_on I18n.t("finishes.form.submit")
end

Then(/^I should see the finish created successfully$/) do
  success_flash = t(
    "controller.success.create",
    name: FinishFixture.name
  )
  expect(page).to have_content(success_flash)

  within ".record-list" do
    click_on FinishFixture.name
  end

  expect(page).to have_content(FinishTypeFixture.updated_name)
  expect(page).to have_content(CreateFixture.finish_category_name)
end

When(/^I delete the finish_type$/) do
  visit "/finish_types"
  delete_and_confirm!
end

Then(/^I should see the finish_type delete complete successfully$/) do
  success_flash = t(
    "controller.success.destroy",
    name: CreateFixture.finish_type_name
  )

  expect(page).to have_content(success_flash)
  expect(page).not_to have_content(".record-list")

  within ".empty" do
    expect(page).to have_content t("components.empty_list.add", type_name: FinishType.model_name.human.downcase)
  end
end

Then(/^I should not see finish_types$/) do
  visit "/finish_types"

  expect(page).to have_content("You are not authorized to access this page")
end
