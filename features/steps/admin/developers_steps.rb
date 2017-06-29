# frozen_string_literal: true
When(/^I create a developer$/) do
  visit "/"

  within ".navbar" do
    click_on t("components.navigation.developers")
  end

  click_on t("developers.index.add")
  fill_in "developer_company_name", with: CreateFixture.developer_name

  click_on t("developers.form.submit")
end

Then(/^I should see the created developer$/) do
  expect(page).to have_content(CreateFixture.developer_name)
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

  click_on t("developers.form.submit")
end

Then(/^I should see the updated developer$/) do
  success_flash = t(
    "developers.update.success",
    developer_name: DeveloperFixture.updated_company_name
  )
  expect(page).to have_content(success_flash)

  # On the show page
  within ".section-title" do
    expect(page).to have_content(DeveloperFixture.updated_company_name)
  end

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

When(/^I delete the developer$/) do
  visit "/developers"

  delete_and_confirm!
end

Then(/^I should see the delete complete successfully$/) do
  success_flash = t(
    "developers.destroy.success",
    developer_name: DeveloperFixture.updated_company_name
  )
  expect(page).to have_content(success_flash)

  expect(page).not_to have_content(".record-list")

  within ".empty" do
    expect(page).to have_content t("components.empty_list.add", type_name: Developer.model_name.human.downcase)
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
