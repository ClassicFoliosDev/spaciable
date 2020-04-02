# frozen_string_literal: true

When(/^I create a developer$/) do
  visit "/"

  CreateFixture.create_countries
  within ".navbar" do
    click_on t("components.navigation.developers")
  end

  click_on t("developers.index.add")
  fill_in "developer_company_name", with: CreateFixture.developer_name

  click_on t("developers.form.submit")
end

Then(/^I should see the created developer$/) do
  visit "/developers"
  within ".developers" do
    click_on CreateFixture.developer_name
  end
end

When(/^I update the developer$/) do
  find("[data-action='edit']").click

  fill_in "developer_company_name", with: DeveloperFixture.updated_company_name
  fill_in "developer_about", with: DeveloperFixture.about

  DeveloperFixture.update_attrs.each do |attr, value|
    fill_in "developer_#{attr}", with: value
  end

  DeveloperFixture.developer_address_attrs.each do |attr, value|
    fill_in "developer_address_attributes_#{attr}", with: value
  end

  check "developer_house_search"
  check "developer_enable_services"
  check "developer_enable_development_messages"
  uncheck "developer_enable_roomsketcher"
  check "developer_cas"

  click_on t("developers.form.submit")
end

Then(/^I should see the updated developer$/) do
  success_flash = t(
    "developers.update.success",
    developer_name: DeveloperFixture.updated_company_name
  )
  expect(page).to have_content(success_flash)

  within ".section-data" do
    DeveloperFixture.update_attrs.each do |_attr, value|
      expect(page).to have_content(value)
    end

    DeveloperFixture.developer_address_attrs.each do |_attr, value|
      expect(page).to have_content(value)
    end

    expect(page).not_to have_content(CreateFixture.developer_name)
  end

  expect(page).to have_content(DeveloperFixture.about)
end

When(/^I try to delete the developer with an incorrect password$/) do
  visit "/developers"

  within ".actions" do
    find(".destroy-permissable").click
  end

  fill_in "password", with: "123456"
  click_on(t("admin_permissable_destroy.confirm"))
end

Then(/^I see an alert and the developer is not deleted$/) do
  within ".alert" do
    expect(page).to have_content(t("admin_permissable_destroy.incorrect_password",
                                 record: DeveloperFixture.updated_company_name))
  end

  within ".record-list" do
    expect(page).to have_content(DeveloperFixture.updated_company_name)
  end
end

When(/^I delete the developer$/) do
  visit "/developers"

  within ".actions" do
    find(".destroy-permissable").click
  end

  fill_in "password", with: CreateFixture.admin_password
  click_on(t("admin_permissable_destroy.confirm"))
end

Then(/^I should see the delete complete successfully$/) do
  success_flash = t(
    "developers.destroy.success",
    developer_name: DeveloperFixture.updated_company_name
  )
  expect(page).to have_content(success_flash)

  expect(page).not_to have_content(".record-list")

  within ".empty" do
    expect(page).to have_content %r{#{t("components.empty_list.add", type_name: Developer.model_name.human)}}i
  end
end

Given(/^default FAQs exist$/) do
  DeveloperFixture.create_default_faqs
end

Then(/^I should see default faqs for the developer$/) do
  click_on CreateFixture.developer_name

  within ".tabs" do
    click_on t("developers.collection.faqs")
  end

  DeveloperFixture.default_faqs.each do |question, category|
    expect(page).to have_content(question)
    expect(page).to have_content(category)
  end
end

When(/^I open the new developer page$/) do
  visit "/"

  CreateFixture.create_countries
  within ".navbar" do
    click_on t("components.navigation.developers")
  end

  click_on t("developers.index.add")

end

Then(/^I should see UK address format$/) do
  
  find_field(:developer_address_attributes_postal_number).should be_visible
  find_field(:developer_address_attributes_road_name).should be_visible
  find_field(:developer_address_attributes_building_name).should be_visible
  find_field(:developer_address_attributes_locality).should be_visible
  find_field(:developer_address_attributes_city).should be_visible
  find_field(:developer_address_attributes_county).should be_visible
  find_field(:developer_address_attributes_postcode).should be_visible

end

When(/^I create a new spanish developer and edit it$/) do
  CreateFixture.create_spanish_developer
end

Then(/^I should see Spanish address format$/) do

  developer = Developer.find_by(company_name: CreateFixture.spanish_developer_name)
  visit "/developers/#{developer.id}/edit"

  ignore = Capybara.ignore_hidden_elements
  Capybara.ignore_hidden_elements = false

  find_field(:developer_address_attributes_postal_number).should_not be_visible
  find_field(:developer_address_attributes_road_name).should_not be_visible
  find_field(:developer_address_attributes_building_name).should_not be_visible
  find_field(:developer_address_attributes_locality).should be_visible
  find_field(:developer_address_attributes_city).should be_visible
  find_field(:developer_address_attributes_county).should_not be_visible
  find_field(:developer_address_attributes_postcode).should be_visible

  Capybara.ignore_hidden_elements = ignore
end

Then(/^I should (not )*see CAS visable and enabled at the development$/) do |not_visible|
  visit "/developers/1/developments/1/edit"
  expect(page).not_to have_content(t("developments.form.cas_description")) if not_visible.present?
  expect(page).to have_content(t("developments.form.cas_description")) unless not_visible.present?
end







