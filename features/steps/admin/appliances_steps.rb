# frozen_string_literal: true

When(/^I create an appliance with no name$/) do
  visit "/"

  within ".navbar" do
    click_on t("components.navigation.appliances")
  end

  click_on t("appliances.collection.create")

  click_on t("appliances.form.submit")
end

Then(/^I should see the appliance model num error$/) do
  failure_flash_appliance_category = Appliance.human_attribute_name(:model_num) +
                                     t("activerecord.errors.messages.blank")

  expect(page).to have_content(failure_flash_appliance_category)
end

When(/^I create an appliance with no category$/) do
  fill_in "appliance_model_num", with: ApplianceFixture.model_num

  click_on t("appliances.form.submit")
end

Then(/^I should see the appliance category error$/) do
  failure_flash_appliance_category = Appliance.human_attribute_name(:appliance_category) +
                                     t("activerecord.errors.messages.required")

  expect(page).to have_content(failure_flash_appliance_category)

  expect(page).not_to have_content FinishFixture.finish_name
end

When(/^I create an appliance$/) do
  visit "/"

  within ".navbar" do
    click_on t("components.navigation.appliances")
  end

  click_on t("appliances.collection.create")

  fill_in "appliance_model_num", with: ApplianceFixture.model_num

  select_from_selectmenu :appliance_appliance_category, with: CreateFixture.appliance_category_name
  select_from_selectmenu :appliance_appliance_manufacturer, with: CreateFixture.appliance_manufacturer_name

  click_on t("appliances.form.submit")
end

Then(/^I should see the ([^ ]*) appliance category$/) do |category|
  visit "/appliance_categories"
  expect(page).to have_content(eval(category))

  click_on eval(category)

  click_on t("appliances.edit.back")
end

Then(/^I should see the new ([^ ]*) appliance$/) do |appliance|
  visit "/appliances"
  expect(page).to have_content(eval(appliance))

  click_on eval(appliance)

  click_on t("appliances.edit.back")
end

Then(/^I cannot delete the ([^ ]*) appliance category$/) do |category|
  visit "/appliance_categories"
  expect(page).to have_content(eval(category))
  # he category name may be duplicated in the database - find the row by name
  appliance_row  = find(:xpath, "//a[text()='#{eval(category)}']/parent::td/parent::tr")
  expect(appliance_row).not_to have_selector("#archive-btn")
end

When(/^I update the appliance$/) do
  visit "/appliances"

  find("[data-action='edit']").click

  sleep 0.1
  within ".appliance" do
    fill_in "appliance[model_num]", with: ApplianceFixture.updated_model_num
    fill_in "appliance[description]", with: ApplianceFixture.description

    select_from_selectmenu :appliance_appliance_category, with: ApplianceFixture.updated_category
    select_from_selectmenu :appliance_appliance_manufacturer, with: ApplianceFixture.updated_manufacturer

    select_from_selectmenu :warranty, with: ApplianceFixture.warranty_len
    select_from_selectmenu :e_rating, with: ApplianceFixture.e_rating

    primary_picture_full_path = FileFixture.file_path + FileFixture.appliance_primary_picture_name
    within ".appliance_primary_image" do
      attach_file("appliance_primary_image",
                  File.absolute_path(primary_picture_full_path),
                  visible: false)
    end

    secondary_picture_full_path = FileFixture.file_path + FileFixture.appliance_secondary_picture_name
    within ".appliance_secondary_image" do
      attach_file("appliance_secondary_image",
                  File.absolute_path(secondary_picture_full_path),
                  visible: false)
    end

    manual_full_path = FileFixture.file_path + FileFixture.manual_name
    within ".manual-container" do
      attach_file("appliance_manual",
                  File.absolute_path(manual_full_path),
                  visible: false)
    end

    guide_full_path = FileFixture.file_path + FileFixture.document_name
    within ".guide-container" do
      attach_file("appliance_guide",
                  File.absolute_path(guide_full_path),
                  visible: false)
    end
  end

  submit_confirm
end

Then(/^I should see the updated appliance$/) do

  success_flash = t(
    "appliances.update.success",
    name: ApplianceFixture.updated_full_name
  )

  expect(page).to have_content(success_flash)

  click_on ApplianceFixture.updated_full_name

  within ".section-title" do
    expect(page).to have_content(ApplianceFixture.updated_full_name)
  end

  within ".appliance" do
    ApplianceFixture.updated_attrs.each do |_attr, value|
      expect(page).to have_content(value)
    end
  end

  within ".appliance_primary_image" do
    image = page.find("img")
    expect(image["src"]).to have_content(FileFixture.appliance_primary_picture_name)
    expect(image["alt"]).to have_content(FileFixture.appliance_primary_picture_alt)
  end

  within ".appliance_secondary_image" do
    image = page.find("img")
    expect(image["src"]).to have_content(FileFixture.appliance_secondary_picture_name)
    expect(image["alt"]).to have_content(FileFixture.appliance_secondary_picture_alt)
  end

  within ".manual" do
    expect(page).to have_content(FileFixture.manual_name)
  end

  within ".guide" do
    expect(page).to have_content(FileFixture.document_name)
  end
end

When(/^I remove an image$/) do
  click_on t("appliances.show.back")

  find("[data-action='edit']").click

  within ".appliance_secondary_image" do
    remove_btn = find(".remove-btn", visible: false)
    remove_btn.click
  end

  submit_confirm
end

Then(/^I should see the updated appliance without the image$/) do
  success_flash = t(
    "appliances.update.success",
    name: ApplianceFixture.updated_full_name
  )

  expect(page).to have_content(success_flash)

  click_on ApplianceFixture.updated_full_name

  # Make sure primary image has not been affected, we only deleted the second one
  within ".appliance_primary_image" do
    image = page.find("img")
    expect(image["src"]).to have_content(FileFixture.appliance_primary_picture_name)
    expect(image["alt"]).to have_content(FileFixture.appliance_primary_picture_alt)
  end

  within ".appliance" do
    expect(page).not_to have_content(".appliance_secondary_image")
  end
end

When(/^I remove a file$/) do
  find("[data-action='edit']").click

  within ".guide-container" do
    remove_btn = find(".remove-btn", visible: false)
    remove_btn.click
  end

  submit_confirm
 end

Then(/^I should see the updated appliance without the file$/) do
  success_flash = t(
    "appliances.update.success",
    name: ApplianceFixture.updated_full_name
  )

  expect(page).to have_content(success_flash)

  click_on ApplianceFixture.updated_full_name

  # Manual should still exist, we only deleted the guide
  within ".manual" do
    expect(page).to have_content(FileFixture.manual_name)
  end

  within ".appliance" do
    expect(page).not_to have_content(FileFixture.document_name)
  end
end

When(/^I delete the appliance$/) do
  visit "/appliances"
  delete_scope = find(:xpath, "//a[contains(text(),'#{CreateFixture.appliance_name}')]/parent::td/parent::tr")
  delete_and_confirm!(scope: delete_scope)
end

When(/^I cannot delete the appliance$/) do
  visit "/appliances"
  appliance_scope = find(:xpath, "//a[contains(text(),'#{CreateFixture.appliance_name}')]/parent::td/parent::tr")
  within appliance_scope do
    find(".info-btn").trigger(:click)
  end
  expect(page).to have_content(t("appliances.collection.cannot_delete", appliance: CreateFixture.appliance_name))
  click_on t("back")
end

Then(/^I should see the ([^ ]*) appliance category delete complete successfully$/) do |category|
  success_flash = t(
    "appliances.destroy.success",
    name: eval(category)
  )
  expect(page).to have_content(success_flash)

  within ".notice" do
    expect(page).to have_content(eval(category))
  end

end

When(/^I delete the ([^ ]*) appliance category$/) do |category|
  visit "./appliance_categories"
  delete_scope = find(:xpath, "//a[text()='#{eval(category)}']/parent::td/parent::tr")
  delete_and_confirm!(scope: delete_scope)
end

Then(/^I should see the ([^ ]*) appliance deletion complete successfully$/) do |appliance|
  success_flash = t(
    "appliances.destroy.success",
    name: eval(appliance)
  )
  expect(page).to have_content(success_flash)

  within ".notice" do
    expect(page).to have_content(eval(appliance))
  end
end

Then(/^I delete the ([^ ]*) appliance manufacturer$/) do |manufacturer|
  visit "./appliance_manufacturers"
  delete_scope  = find(:xpath, "//a[text()='#{eval(manufacturer)}']/parent::td/parent::tr")
  delete_and_confirm!(scope: delete_scope)
end

Then(/^I cannot delete the ([^ ]*) appliance manufacturer$/) do |manufacturer|
  visit "/appliance_manufacturers"
  expect(page).to have_content(eval(manufacturer))
  # the category name may be duplicated in the database - find the row by name
  manufacturer_row  = find(:xpath, "//a[text()='#{eval(manufacturer)}']/parent::td/parent::tr")
  expect(manufacturer_row).not_to have_selector("#archive-btn")
end

Then(/^I cannot delete the ([^ ]*) appliance$/) do |appliance|
  visit "/appliances"
  expect(page).to have_content(eval(appliance))
  # the category name may be duplicated in the database - find the row by name
  appliance_row  = find(:xpath, "//a[contains(text(),'#{eval(appliance)}')]/parent::td/parent::tr")
  expect(appliance_row).not_to have_selector("#archive-btn")
end

def submit_confirm
  click_on t("unit_types.form.submit")
  click_on t("buttons.confirm_dialog.title")
end
