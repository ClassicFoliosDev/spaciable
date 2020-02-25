# frozen_string_literal: true

Given(/^I have a I have a developer with a development and a unit type$/) do
  CreateFixture.create_developer_with_development_and_unit_type
end

When(/^I create a (restricted )*unit type for the development$/) do |restricted|
  navigate_to_unit_type

  click_on t("unit_types.collection.add")

  fill_in "unit_type_name", with: CreateFixture.unit_type_name
  find("#unit_type_restricted").set true if restricted.present?

  click_on t("unit_types.form.submit")
end

Then(/^I should see the created unit type$/) do
  expect(page).to have_content(CreateFixture.developer_name)

  click_on CreateFixture.unit_type_name

  click_on t("unit_types.edit.back")
end

When(/^I update the unit type$/) do
  within ".record-list" do
    find("[data-action='edit']").click
  end

  find("#unit_type_name")
  fill_in "unit_type[name]", with: UnitTypeFixture.updated_unit_type_name
  fill_in "unit_type_external_link", with: UnitTypeFixture.external_url

  click_on t("unit_types.form.submit")
end

Then(/^I should see the updated unit type$/) do
  # On the index page
  within ".record-list" do
    expect(page).to have_content(UnitTypeFixture.updated_unit_type_name)
  end

  # and on the show page
  click_on UnitTypeFixture.updated_unit_type_name

  UnitTypeFixture.update_attrs.each do |_attr, value|
    expect(page).to have_content(value)
  end
end

And(/^I have created a unit type$/) do
  CreateFixture.create_developer_with_development
  CreateFixture.create_unit_type
end

When(/^I delete the unit type$/) do
  goto_development_show_page

  within ".tabs" do
    click_on t("developments.collection.unit_types")
  end

  within ".unit-types" do
    expect(page).to have_content CreateFixture.unit_type_name
  end

  delete_and_confirm!
end

Then(/^I should see the deletion complete successfully$/) do
  success_flash = t("controller.success.destroy", name: CreateFixture.unit_type_name)
  expect(page).to have_content(success_flash)

  within ".breadcrumbs" do
    expect(page).to have_content(CreateFixture.development_name)
  end

  expect(page).not_to have_content(".record-list")

  within ".empty" do
    expect(page).to have_content %r{#{t("components.empty_list.add", type_name: UnitType.model_name.human)}}i
  end
end

When(/^I navigate to the development$/) do
  visit "/"
  goto_development_show_page
  within ".tabs" do
    click_on t("developments.collection.unit_types")
  end
end

Then(/^I should not be able to create a unit type$/) do
  expect(page).not_to have_content(".record-list")

  within ".empty" do
    expect(page).to have_content t("components.empty_list.request_add", type_names: UnitType.model_name.human.downcase.pluralize)
    expect(page).not_to have_content t("components.empty_list.add", type_name: UnitType.model_name.human.downcase)
  end
end

When(/^I navigate to the division development$/) do
  visit "/"
  goto_division_development_show_page
  within ".tabs" do
    click_on t("developments.collection.unit_types")
  end
end

When(/^I clone the unit type$/) do
  within ".unit-types" do
    links = page.all(".clone")
    links.first.click
  end
end

Then(/^I should see a duplicate unit type created successfully$/) do
  new_name = CreateFixture.unit_type_name + " 1"

  within ".record-list" do
    expect(page).to have_content(new_name)
  end
end

Then(/^I should see another duplicate unit type created successfully$/) do
  new_name = CreateFixture.unit_type_name + " 2"

  within ".record-list" do
    expect(page).to have_content(new_name)
  end
end

Given(/^there is a unit type room with (CAS )*finish and appliance$/) do |cas|
  MyLibraryFixture.create_room_appliance_and_finish(cas.present? ? CreateFixture.developer : nil)
  MyLibraryFixture.create_documents
end

Then(/^I should see a duplicate unit type with finish and appliance created successfully$/) do
  new_name = CreateFixture.unit_type_name + " 1"

  within ".unit-types" do
    click_on new_name
  end

  within ".rooms" do
    click_on CreateFixture.room_name
  end

  within ".room" do
    expect(page).to have_content(CreateFixture.finish_name)
    click_on t("rooms.collection.appliances")
  end

  within ".record-list" do
    expect(page).to have_content(CreateFixture.full_appliance_name)
  end
end

When(/^I clone a unit type twice$/) do
  within ".record-list" do
    links = page.all(".clone")
    links.first.click
  end
end

Then(/^I should see a duplicate name error$/) do
  error_flash = t("activerecord.errors.messages.clone_not_possible", name: CreateFixture.unit_type_name + " 1")
  expect(page).to have_content(error_flash)
end

Then(/^I should not be able to clone a unit type$/) do
  within ".tabs" do
    click_on t("developments.collection.unit_types")
  end

  within ".record-list" do
    expect(page).to have_no_css(".clone")
  end
end

Then(/^I should see a duplicate unit type without finish and appliance created successfully$/) do
  new_name = CreateFixture.unit_type_name + " 2"

  within ".unit-types" do
    click_on new_name
  end

  within ".tabs" do
    click_on t("unit_types.collection.rooms")
  end

  within ".record-list" do
    click_on CreateFixture.room_name
  end

  within ".record-list" do
    expect(page).not_to have_content(CreateFixture.finish_name)
  end

  within ".tabs" do
    click_on t("rooms.collection.appliances")
  end

  within ".record-list" do
    expect(page).not_to have_content(CreateFixture.full_appliance_name)
  end
end

Then(/^the document has not been cloned$/) do
  cloned_unit_type_name = CreateFixture.unit_type_name + " 1"
  within ".breadcrumbs" do
    click_on cloned_unit_type_name
  end

  click_on t('unit_types.collection.documents')

  within ".unit-type" do
    expect(page).not_to have_content DocumentFixture.document_name
    expect(page).to have_content t("components.empty_list.empty", type_names: "documents")
  end
end

When(/^the unit type associated with a plot has an information button$/) do
  visit "/developers/#{PhasePlotFixture.developer_id}/developments/#{PhasePlotFixture.development_id}?active_tab=unit_types"
  btn = find(:xpath,"//button[@data-id=#{PhasePlotFixture.unit_type_id}]")
  expect(btn[:title]).to eq(t("buttons.info.title"))
end

When(/^I press the information button for the unit type associated with a plot$/) do
  visit "/developers/#{PhasePlotFixture.developer_id}/developments/#{PhasePlotFixture.development_id}?active_tab=unit_types"
  btn = find(:xpath,"//button[@data-id=#{PhasePlotFixture.unit_type_id}]")
  sleep 0.1
  btn.trigger(:click)
end

Then(/^I should see dialog warning of the associated phase and plot$/) do
  expect(page).to have_content("This unit type cannot be deleted because it is in use. Please reassign the following plots to other unit types before deleting")
end

Then(/^I view the unit type$/) do
  click_on CreateFixture.unit_type_name
end

Then(/^I view a unit type room$/) do
  click_on CreateFixture.room_name
end

Then(/^I cannot edit or delete the unit types$/) do
  no_edit_or_delete
end

Then(/^I cannot edit or delete the rooms$/) do
  no_edit_or_delete
end

Then(/^I cannot edit or delete the finishes or appliances$/) do
  no_edit_or_delete
  click_on "Appliances"
  no_edit_or_delete
end

def no_edit_or_delete
  expect(page).not_to have_selector(".archive-btn")
  expect(page).not_to have_selector("[data-action='edit']")
end



