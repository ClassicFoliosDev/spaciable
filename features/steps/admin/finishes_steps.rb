# frozen_string_literal: true

When(/^I create a finish without a category$/) do
  visit "/"

  within ".navbar" do
    click_on t("components.navigation.finishes")
  end

  click_on t("finishes.collection.create")

  fill_in "finish_name", with: FinishFixture.finish_name
  click_on t("appliances.form.submit")
end

Then(/^I should see the category failure message$/) do
  failure_flash_finish_category = Finish.human_attribute_name(:finish_category) +
                                  t("activerecord.errors.messages.required")

  expect(page).to have_content(failure_flash_finish_category)
end

When(/^I create a finish$/) do
  fill_in "finish_name", with: FinishFixture.finish_name

  select_from_selectmenu :finish_finish_category, with: CreateFixture.finish_category_name
  select_from_selectmenu :finish_finish_type, with: CreateFixture.finish_type_name

  click_on t("appliances.form.submit")
end

Then(/^I should see the created finish$/) do
  success_flash = t(
    "controller.success.create",
    name: FinishFixture.finish_name
  )

  expect(page).to have_content(success_flash)

  within ".record-list" do
    expect(page).to have_content(FinishFixture.finish_name)
  end
end

When(/^I update the finish$/) do
  visit "/finishes"

  within ".record-list" do
    find("[data-action='edit']").click
  end

  fill_in "finish[name]", with: FinishFixture.updated_name

  select_from_selectmenu :finish_finish_category, with: FinishFixture.updated_category
  select_from_selectmenu :finish_finish_type, with: FinishFixture.updated_type
  select_from_selectmenu :finish_finish_manufacturer, with: FinishFixture.updated_manufacturer

  picture_full_path = FileFixture.file_path + FileFixture.finish_picture_name
  within ".finish_picture" do
    attach_file("finish_picture",
                File.absolute_path(picture_full_path),
                visible: false)
  end

  click_on t("rooms.form.submit")
end

Then(/^I should see the updated finish$/) do
  success_flash = t(
    "finishes.update.success",
    name: FinishFixture.updated_name
  )

  expect(page).to have_content(success_flash)

  within ".section-header" do
    expect(page).to have_content(FinishFixture.updated_name)
  end

  within ".finish" do
    FinishFixture.updated_attrs.each do |_attr, value|
      expect(page).to have_content(value)
    end

    image = page.find("img")

    expect(image["src"]).to have_content(FileFixture.finish_picture_name)
    expect(image["alt"]).to have_content(FileFixture.finish_picture_alt)
  end

  within ".filename" do
    expect(page).to have_content(FileFixture.finish_picture_name)
  end
end

When(/^I remove an image from a finish$/) do
  visit "/finishes"

  find("[data-action='edit']").click

  within ".finish_picture" do
    remove_btn = find(".remove-btn", visible: false)
    remove_btn.trigger("click")
  end

  click_on t("unit_types.form.submit")
end

Then(/^I should see the updated finish without the image$/) do
  success_flash = t(
    "finishes.update.success",
    name: FinishFixture.updated_name
  )

  expect(page).to have_content(success_flash)

  within ".finish" do
    expect(page).not_to have_content("img")
  end
end

Given(/^I have created a finish$/) do
  CreateFixture.create_finish
end

When(/^I delete the finish$/) do
  finish_path = "/finishes"
  visit finish_path

  delete_and_confirm!
end

Then(/^I should see the finish deletion complete successfully$/) do
  success_flash = t(
    "finishes.destroy.success",
    name: CreateFixture.finish_name
  )
  expect(page).to have_content(success_flash)

  within ".notice" do
    expect(page).to have_content(CreateFixture.finish_name)
  end

  expect(page).not_to have_content(".record-list")

  within ".empty" do
    expect(page).to have_content t("components.empty_list.add", type_name: Finish.model_name.human.downcase)
  end
end

When(/^I delete the finish manufacturer$/) do
  visit "./finish_manufacturers"

  manufacturer = FinishManufacturer.find_by(name: CreateFixture.finish_manufacturer_name)
  delete_scope = "[data-finish-manufacturer='#{manufacturer.id}']"

  delete_and_confirm!(scope: delete_scope)
end

Then(/^I should see a failed to delete message$/) do
  error_flash = "It is not possible to delete"
  expect(page).to have_content(error_flash)
end

When(/^I delete the finish category$/) do
  visit "./finish_categories"
  finish_category = FinishCategory.find_by(name: CreateFixture.finish_category_name)

  delete_scope = "[data-finish-category='#{finish_category.id}']"
  delete_and_confirm!(scope: delete_scope)
end

When(/^I delete the finish type$/) do
  visit "./finish_types"
  finish_type = FinishType.find_by(name: CreateFixture.finish_type_name)

  delete_scope = "[data-finish-type='#{finish_type.id}']"
  delete_and_confirm!(scope: delete_scope)
end

When(/^I review the finish category$/) do
  visit "./finish_categories"
  click_on CreateFixture.finish_category_name
end

Then(/^I should see the finish type shown$/) do
  sleep 0.5
  within ".finish_category" do
    expect(page).to have_content(CreateFixture.finish_type_name)
  end
end

When(/^I review the finish type$/) do
  visit "./finish_types"
  click_on CreateFixture.finish_type_name
end

Then(/^I should see the finish manufacturer shown$/) do
  sleep 0.5
  within ".finish_type" do
    expect(page).to have_content("Victoria Carpets")
    expect(page).to have_content("Cormar Carpets")
  end
end
