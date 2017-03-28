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

  select_from_selectmenu :appliance_appliance_category, with: ApplianceFixture.category
  select_from_selectmenu :appliance_manufacturer, with: ApplianceFixture.manufacturer

  click_on t("appliances.form.submit")
end

Then(/^I should see the created appliance$/) do
  expect(page).to have_content(ApplianceFixture.full_name)

  click_on ApplianceFixture.full_name

  click_on t("appliances.edit.back")
end

When(/^I update the appliance$/) do
  find("[data-action='edit']").click

  sleep 0.1
  within ".appliance" do
    fill_in "appliance[model_num]", with: ApplianceFixture.updated_model_num
    fill_in "appliance[description]", with: ApplianceFixture.description

    select_from_selectmenu :appliance_appliance_category, with: ApplianceFixture.updated_category
    select_from_selectmenu :appliance_manufacturer, with: ApplianceFixture.updated_manufacturer

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

  click_on t("unit_types.form.submit")
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

  click_on t("unit_types.form.submit")
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

  click_on t("unit_types.form.submit")
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
  appliance_path = "/appliances"
  visit appliance_path

  delete_and_confirm!
end

Then(/^I should see the appliance deletion complete successfully$/) do
  success_flash = t(
    "appliances.destroy.success",
    name: CreateFixture.full_appliance_name
  )
  expect(page).to have_content(success_flash)

  within ".notice" do
    expect(page).to have_content(CreateFixture.full_appliance_name)
  end

  expect(page).not_to have_content(".record-list")

  within ".empty" do
    expect(page).to have_content t("components.empty_list.add", type_name: Appliance.model_name.human.downcase)
  end
end
