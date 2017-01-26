# frozen_string_literal: true
When(/^I create an appliance$/) do
  visit "/"

  within ".navbar" do
    click_on t("components.navigation.appliances")
  end

  click_on t("appliances.collection.create")

  fill_in "appliance_name", with: ApplianceFixture.name
  click_on t("appliances.form.submit")
end

Then(/^I should see the created appliance$/) do
  expect(page).to have_content(ApplianceFixture.name)

  click_on ApplianceFixture.name

  click_on t("appliances.edit.back")
end

When(/^I update the appliance$/) do
  find("[data-action='edit']").click

  sleep 0.2 # these fields are not found without the sleep :(
  fill_in "appliance[name]", with: ApplianceFixture.updated_name

  ApplianceFixture.update_attrs.each do |attr, value|
    fill_in "appliance_#{attr}", with: value
  end

  fill_in "appliance[description]", with: ApplianceFixture.description

  within ".warranty" do
    warranty_arrow = page.find ".ui-icon"
    warranty_arrow.click

    warranty_ul = page.find ".ui-menu"

    warranty_list = warranty_ul.all("li")
    warranty_list.find { |node| node.text == ApplianceFixture.warranty_len }.click
    # sleep 0.3
  end

  within ".e-rating" do
    e_rating_arrow = page.find ".ui-icon"
    e_rating_arrow.click

    e_rating_ul = page.find ".ui-menu"

    e_rating_list = e_rating_ul.all("li")
    e_rating_list.find { |node| node.text == ApplianceFixture.e_rating }.click
  end

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

  click_on t("appliances.form.submit")
end

When(/^I update the dropdown$/) do
  appliance_path = "/appliances"
  visit appliance_path

  find("[data-action='edit']").click

  category = page.find(".appliance-category")

  within category do
    finish_arrow = page.find ".ui-icon"
    finish_arrow.click

    category_ul = page.find ".ui-menu"

    category_list = category_ul.all("li")
    category_list.find { |node| node.text == ApplianceFixture.category }.click
    sleep 0.3
  end

  manufacturer = page.find(".appliance-manufacturer")

  within manufacturer do
    finish_arrow = page.find ".ui-icon"
    finish_arrow.click

    manuf_ul = page.find ".ui-menu"

    manuf_list = manuf_ul.all("li")
    manuf_list.find { |node| node.text == ApplianceFixture.manufacturer }.click
  end

  click_on t("unit_types.form.submit")
end

Then(/^I should see the updated appliance with selects$/) do
  find("[data-action='edit']").click

  sleep(0.2)
  finish_fields = page.all("fieldset")
  second_col = finish_fields[1]

  within second_col do
    ApplianceFixture.dropdown_attrs.each do |_attr, value|
      expect(page).to have_content(value)
    end
  end
end

When(/^I remove an image$/) do
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
  # TODO: after show pages updated in HOOZ-171
  # expect(page).to have_content("fridgefreezers160x160-aeg.png")
  expect(page).not_to have_content("bosch_wab.jpg")
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
