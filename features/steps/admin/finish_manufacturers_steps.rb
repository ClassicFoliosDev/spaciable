# frozen_string_literal: true

When(/^I create a finish manufacturer$/) do
  visit "/finish_manufacturers"

  add_button = page.find("a", text: I18n.t("finish_manufacturers.collection.add"))
  add_button.click

  within ".finish_manufacturer" do
    fill_in "finish_manufacturer_name", with: FinishManufacturerFixture.name
  end

  click_on I18n.t("finish_manufacturers.form.submit")
end

Then(/^I should see the created finish manufacturer$/) do
  success_flash = t(
    "controller.success.create",
    name: FinishManufacturerFixture.name
  )
  expect(page).to have_content(success_flash)

  within ".record-list" do
    click_on FinishManufacturerFixture.name
  end

  within ".finish_manufacturer" do
    expect(page).to have_content(CreateFixture.finish_type_name)
  end
end

When(/^I update the finish manufacturer$/) do
  visit "/finish_manufacturers"

  within find(:xpath, ".//tr[td//text()[contains(., '#{FinishManufacturerFixture.name}')]]") do
    find("[data-action='edit']").click
  end

  within ".finish_manufacturer" do
    fill_in "finish_manufacturer_name", with: FinishManufacturerFixture.updated_name
  end

  click_on I18n.t("finish_manufacturers.form.submit")
end

Then(/^I should be required to enter a finish type$/) do
  expect(page).to have_content(I18n.t("activerecord.errors.models.finish_manufacturer.attributes.finish_types.too_short"))

  within ".finish_manufacturer" do
    select CreateFixture.finish_type_name, from: :finish_manufacturer_finish_type_ids
  end

  click_on I18n.t("finish_manufacturers.form.submit")
end

Then(/^I should see the updated finish manufacturer$/) do
  success_flash = t(
    "controller.success.update",
    name: FinishManufacturerFixture.updated_name
  )
  expect(page).to have_content(success_flash)

  within ".tabs" do
    click_on t("finishes.collection.finish_manufacturers")
  end

  within ".record-list" do
    expect(page).not_to have_content(FinishManufacturerFixture.name)
    expect(page).to have_content(FinishManufacturerFixture.updated_name)
  end
end

Then(/^I should see the finish manufacturer delete complete successfully$/) do
  success_flash = t(
    "controller.success.destroy",
    name: CreateFixture.finish_manufacturer_name
  )

  expect(page).to have_content(success_flash)
  expect(page).not_to have_content(".record-list")

  within ".empty" do
    expect(page).to have_content t("components.empty_list.add", type_name: FinishManufacturer.model_name.human.downcase)
  end
end

Then(/^I should not see finish manufacturers$/) do
  visit "/finish_manufacturers"

  expect(page).to have_content("You are not authorized to access this page")
end
