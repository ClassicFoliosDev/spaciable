# frozen_string_literal: true

When(/^I create a finish type$/) do
  visit "/finish_types"

  click_on I18n.t("finish_types.collection.add")

  Capybara.ignore_hidden_elements = false
  within ".finish_type" do
    fill_in "finish_type_name", with: FinishTypeFixture.name
    select CreateFixture.finish_category_name, from: :finish_type_finish_category_ids
  end

  click_on I18n.t("finish_types.form.submit")
end

Then(/^I should see the created finish type$/) do
  success_flash = t(
    "controller.success.create",
    name: FinishTypeFixture.name
  )
  expect(page).to have_content(success_flash)

  within ".record-list" do
    expect(page).to have_content(FinishTypeFixture.name)
  end
end

When(/^I update the finish type$/) do
  finish_type = FinishType.find_by(name: FinishTypeFixture.name)
  within "[data-finish-type=\"#{finish_type.id}\"]" do
    find("[data-action='edit']").click
  end

  within ".finish_type" do
    fill_in "finish_type_name", with: FinishTypeFixture.updated_name
  end

  click_on I18n.t("finish_types.form.submit")
end

Then(/^I should see the updated finish type$/) do
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

When(/^I create a finish with the new finish type$/) do
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

When(/^I delete the finish type$/) do
  visit "./finish_types"
  finish_type = FinishType.find_by(name: CreateFixture.finish_type_name)

  delete_scope = "[data-finish-type='#{finish_type.id}']"
  delete_and_confirm!(scope: delete_scope)
end

When(/^I delete the (.*) finish type$/) do |type|
  visit "./finish_types"
  finish_type = FinishType.find_by(name: eval(type))

  delete_scope = "[data-finish-type='#{finish_type.id}']"
  delete_and_confirm!(scope: delete_scope)
end

Then(/^I should see the (.*) finish type delete complete successfully$/) do |type|
  success_flash = t(
    "controller.success.destroy",
    name: eval(type)
  )

  expect(page).to have_content(success_flash)
  expect(page).not_to have_content(".record-list")
end

Then(/^I should not see finish types$/) do
  visit "/finish_types"

  expect(page).to have_content("You are not authorized to access this page")
end
