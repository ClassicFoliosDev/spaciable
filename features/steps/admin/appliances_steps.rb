# frozen_string_literal: true
When(/^I create an appliance with no name$/) do
  visit "/"

  within ".navbar" do
    click_on t("components.navigation.appliances")
  end

  click_on t("appliances.collection.create")

  click_on t("appliances.form.submit")
end

Then(/^I should see the appliance name error$/) do
  failure_flash_appliance_category = Appliance.human_attribute_name(:name) +
                                     t("activerecord.errors.messages.blank")

  expect(page).to have_content(failure_flash_appliance_category)
end

When(/^I create an appliance with no category$/) do
  fill_in "appliance_name", with: ApplianceFixture.name

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

  fill_in "appliance_name", with: ApplianceFixture.name

  select_from_selectmenu :appliance_appliance_category, with: ApplianceFixture.category
  select_from_selectmenu :appliance_manufacturer, with: ApplianceFixture.manufacturer

  click_on t("appliances.form.submit")
end

Then(/^I should see the created appliance$/) do
  expect(page).to have_content(ApplianceFixture.name)

  click_on ApplianceFixture.name

  click_on t("appliances.edit.back")
end

When(/^I update the appliance$/) do
  find("[data-action='edit']").click

  sleep 0.1
  within ".appliance" do
    fill_in "appliance[name]", with: ApplianceFixture.updated_name
    fill_in "appliance[description]", with: ApplianceFixture.description

    select_from_selectmenu :appliance_appliance_category, with: ApplianceFixture.updated_category
    select_from_selectmenu :appliance_manufacturer, with: ApplianceFixture.updated_manufacturer

    select_from_selectmenu :warranty, with: ApplianceFixture.warranty_len
    select_from_selectmenu :e_rating, with: ApplianceFixture.e_rating

    within ".appliance_primary_image" do
      attach_file("appliance_primary_image",
                  File.absolute_path("./features/support/files/bosch_wab.jpg"),
                  visible: false)
    end

    within ".appliance_secondary_image" do
      attach_file("appliance_secondary_image",
                  File.absolute_path("./features/support/files/fridgefreezers160x160-aeg.png"),
                  visible: false)
    end
  end

  click_on t("unit_types.form.submit")
end

Then(/^I should see the updated appliance$/) do
  success_flash = t(
    "appliances.update.success",
    name: ApplianceFixture.updated_name
  )

  expect(page).to have_content(success_flash)

  click_on ApplianceFixture.updated_name

  within ".section-title" do
    expect(page).to have_content(ApplianceFixture.updated_name)
  end

  within ".appliance" do
    ApplianceFixture.updated_attrs.each do |_attr, value|
      expect(page).to have_content(value)
    end
  end

  within ".appliance_primary_image" do
    image = page.find("img")
    expect(image["src"]).to have_content("bosch_wab.jpg")
    expect(image["alt"]).to have_content("Bosch wab")
  end

  within ".secondary_image" do
    image = page.find("img")
    expect(image["src"]).to have_content("fridgefreezers160x160-aeg.png")
    expect(image["alt"]).to have_content("Fridgefreezers")
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
    name: ApplianceFixture.updated_name
  )

  expect(page).to have_content(success_flash)

  click_on ApplianceFixture.updated_name

  # Make sure primary image has not been affected, we only deleted the second one
  within ".appliance_primary_image" do
    image = page.find("img")
    expect(image["src"]).to have_content("bosch_wab.jpg")
    expect(image["alt"]).to have_content("Bosch wab")
  end

  within ".secondary_image" do
    expect(page).not_to have_content("img")
  end
end

And(/^I have created an appliance$/) do
  CreateFixture.create_appliance
end

When(/^I delete the appliance$/) do
  appliance_path = "/appliances"
  visit appliance_path

  delete_and_confirm!
end

Then(/^I should see the appliance deletion complete successfully$/) do
  success_flash = t(
    "appliances.destroy.success",
    name: CreateFixture.appliance_name
  )
  expect(page).to have_content(success_flash)

  within ".notice" do
    expect(page).to have_content(CreateFixture.appliance_name)
  end

  within ".record-list" do
    expect(page).not_to have_content CreateFixture.appliance_name
  end
end
