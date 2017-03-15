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

  expect(page).not_to have_content FinishFixture.finish_name
end

When(/^I create a finish$/) do
  fill_in "finish_name", with: FinishFixture.finish_name

  select_from_selectmenu :finish_finish_category, with: FinishFixture.category
  select_from_selectmenu :finish_finish_type, with: FinishFixture.type

  click_on t("appliances.form.submit")
end

Then(/^I should see the created finish$/) do
  success_flash = t(
    "finishes.create.success",
    name: FinishFixture.finish_name
  )

  expect(page).to have_content(success_flash)

  within ".record-list" do
    expect(page).to have_content(FinishFixture.finish_name)
  end
end

When(/^I update the finish$/) do
  find("[data-action='edit']").click

  fill_in "finish[name]", with: FinishFixture.updated_name

  select_from_selectmenu :finish_finish_category, with: FinishFixture.updated_category

  select_from_selectmenu :finish_finish_type, with: FinishFixture.updated_type

  select_from_selectmenu :finish_manufacturer, with: FinishFixture.manufacturer

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
end

When(/^I remove an image from a finish$/) do
  click_on t("finishes.show.back")

  find("[data-action='edit']").click

  within ".finish_picture" do
    remove_btn = find(".remove-btn", visible: false)
    remove_btn.click
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
    expect(page).to have_content t("components.empty_list.add", type_name: Finish.model_name.human)
  end
end
