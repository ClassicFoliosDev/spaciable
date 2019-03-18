# frozen_string_literal: true

Given(/^there is a developer with divisions$/) do
  CreateFixture.create_developer
end

When(/^I create a division for the developer$/) do
  visit "/developers"

  within "[data-developer='#{CreateFixture.developer_id}']" do
    click_on t("developers.index.divisions")
  end

  within ".divisions" do
    click_on t("divisions.collection.add")
  end

  within ".new_division" do
    fill_in "division_division_name", with: CreateFixture.division_name
    click_on t("divisions.form.submit")
  end
end

Then(/^I should see the created developer division$/) do
  expect(page).to have_content(CreateFixture.developer_name)
end

When(/^I update the developer's division$/) do

  within ".divisions" do
    find("[data-action='edit']").click
  end

  within ".edit_division" do
    fill_in "division_division_name", with: DeveloperDivisionFixture.updated_division_name

    DeveloperDivisionFixture.update_attrs.each do |attr, value|
      fill_in "division_#{attr}", with: value
    end

    DeveloperDivisionFixture.division_address_attrs.each do |attr, value|
      fill_in "division_address_attributes_#{attr}", with: value
    end

    click_on t("developers.form.submit")
  end
end

Then(/^I should see the updated developer division$/) do
  success_flash = t(
    "divisions.update.success",
    division_name: DeveloperDivisionFixture.updated_division_name
  )

  within ".notice" do
    expect(page).to have_content(success_flash)
  end

  within ".divisions" do
    click_on DeveloperDivisionFixture.updated_division_name
  end

  # On the show page
  within ".section-header" do
    expect(page).to have_content(DeveloperDivisionFixture.updated_division_name)
    expect(page).not_to have_content CreateFixture.division_name

    DeveloperDivisionFixture.update_attrs.each do |_attr, value|
      expect(page).to have_content(value)
    end

    DeveloperDivisionFixture.division_address_attrs.each do |_attr, value|
      expect(page).to have_content(value)
    end
  end
end

When(/^I create another division/) do
  visit "/developers"

  within ".developers" do
    click_on t("developers.collection.divisions")
  end

  within ".divisions" do
    click_on t("divisions.collection.add")
  end

  within ".new_division" do
    fill_in "division_division_name", with: DeveloperDivisionFixture.second_division_name
    click_on t("developments.form.submit")
  end
end

Then(/^I should see the divisions list$/) do
  within ".divisions" do
    expect(page).to have_content DeveloperDivisionFixture.updated_division_name
    expect(page).to have_content DeveloperDivisionFixture.second_division_name
  end
end

When(/^I delete the division$/) do
  visit "/developers"

  within ".developers" do
    click_on t("developers.collection.divisions")
  end

  delete_and_confirm!(finder_options: { match: :first }, scope: ".divisions")
end

Then(/^I should see that the deletion was successful for the division$/) do
  success_flash = t(
    "divisions.destroy.success",
    division_name: DeveloperDivisionFixture.updated_division_name
  )
  expect(page).to have_content(success_flash)

  within ".breadcrumbs" do
    expect(page).to have_content(CreateFixture.developer_name)
  end

  within ".divisions" do
    expect(page).not_to have_content DeveloperDivisionFixture.updated_division_name
    expect(page).to have_content(DeveloperDivisionFixture.second_division_name)
  end
end

When(/^I create a division for the spanish developer$/) do
  visit "/developers"

  within "[data-developer='#{CreateFixture.spanish_developer_id}']" do
    click_on t("developers.index.divisions")
  end

  within ".divisions" do
    click_on t("divisions.collection.add")
  end

  within ".new_division" do
    fill_in "division_division_name", with: CreateFixture.spanish_division_name
  end
end
