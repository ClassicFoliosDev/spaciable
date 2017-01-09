# frozen_string_literal: true
When(/^I create an appliance$/) do
  visit "/"

  within ".navbar" do
    click_on t("components.navigation.appliances")
  end

  click_on t("appliances.index.add")

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

  select ApplianceFixture.warranty_len, from: "appliance_warranty_length"
  select ApplianceFixture.e_rating, from: "appliance_e_rating"

  click_on t("appliances.form.submit")
end

Then(/^I should see the updated appliance$/) do
  # On the index page
  within ".record-list" do
    expect(page).to have_content(ApplianceFixture.updated_name)
  end

  # and on the edit page
  click_on ApplianceFixture.updated_name

  ApplianceFixture.update_attrs.each do |attr, value|
    screen_value = find("[name='appliance[#{attr}]']").value
    expect(screen_value).to eq(value)
  end

  descr_display = ApplianceFixture.description_display
  descr_value = page.find("[name='appliance[description]']").value
  expect(descr_value).to eq(descr_display)

  within ".appliance_warranty_length" do
    expect(page).to have_select("appliance_warranty_length",
                                selected: ApplianceFixture.warranty_len)
  end

  within ".appliance_e_rating" do
    expect(page).to have_select("appliance_e_rating", selected: ApplianceFixture.e_rating)
  end
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
    # Select of item 5 should always give the same result,
    # because the DB contents are populated by seeds.rb
    category_list[5].click
  end

  manufacturer = page.find(".manufacturer")

  within manufacturer do
    finish_arrow = page.find ".ui-icon"
    finish_arrow.click

    manuf_ul = page.find ".ui-menu"

    manuf_list = manuf_ul.all("li")
    # Select of item 3 should always give the same result,
    # because the DB contents are populated by seeds.rb
    manuf_list[3].click
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
    expect(page).to have_no_content CreateFixture.appliance_name
  end
end
