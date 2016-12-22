# frozen_string_literal: true
When(/^I create a unit type for the development$/) do
  visit "/"

  within ".navbar" do
    click_on t("components.navigation.developers")
  end

  within "[data-developer='#{UnitTypeFixture.developer_id}']" do
    click_on t(".developers.index.developments")
  end

  within "[data-development='#{UnitTypeFixture.development_id}']" do
    click_on t(".developments.developments.unit_types")
  end

  click_on t("unit_types.index.add")

  fill_in "unit_type_name", with: UnitTypeFixture.unit_type_name
  click_on t("unit_types.form.submit")
end

Then(/^I should see the created unit type$/) do
  expect(page).to have_content(UnitTypeFixture.developer_name)

  click_on UnitTypeFixture.unit_type_name

  click_on t("unit_types.edit.back")
end

When(/^I update the unit type$/) do
  find("[data-action='edit']").click

  sleep 0.3 # these fields are not found without the sleep :(
  fill_in "unit_type[name]", with: UnitTypeFixture.updated_unit_type_name

  select t("activerecord.attributes.unit_type.build_types.house_detached"),
         from: "unit_type[build_type]"

  click_on t("unit_types.form.submit")
end

Then(/^I should see the updated unit type$/) do
  # On the index page
  within ".record-list" do
    expect(page).to have_content(UnitTypeFixture.updated_unit_type_name)
  end

  # and on the edit page
  click_on UnitTypeFixture.updated_unit_type_name

  UnitTypeFixture.update_attrs.each do |attr, value|
    screen_value = find("[name='unit_type[#{attr}]']").value
    expect(screen_value).to eq(value)
    expect(page).to have_content(
      t("activerecord.attributes.unit_type.build_types.house_detached")
    )
  end
end

And(/^I have created a unit type$/) do
  UnitTypeFixture.create_unit_type
end

When(/^I delete the unit type$/) do
  unit_type_path = "/developments/#{UnitTypeFixture.development_id}/unit_types"
  visit unit_type_path

  delete_and_confirm!
end

Then(/^I should see the deletion complete successfully$/) do
  success_flash = t(
    "unit_types.destroy.archive.success",
    unit_type_name: UnitTypeFixture.unit_type_name
  )
  expect(page).to have_content(success_flash)

  within ".breadcrumbs" do
    expect(page).to have_content(UnitTypeFixture.development_name)
  end

  within ".record-list" do
    expect(page).to have_no_content UnitTypeFixture.unit_type_name
  end
end
