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

  DeveloperFixture.update_attrs.each do |attr, value|
    fill_in "developer_#{attr}", with: value
  end

  click_on t("developers.form.submit")
end

Then(/^I should see the updated developer$/) do
  # On the index page
  within ".record-list" do
    expect(page).to have_content(DeveloperFixture.updated_company_name)
  end

  # and on the edit page
  click_on DeveloperFixture.updated_company_name

  DeveloperFixture.update_attrs.each do |attr, value|
    screen_value = find("[name='developer[#{attr}]']").value
    expect(screen_value).to eq(value)
  end
end

When(/^I delete the developer$/) do
  click_on t("developers.edit.back")

  delete_and_confirm!
end

Then(/^I should see the delete complete successfully$/) do
  success_flash = t(
    "developers.archive.success",
    developer_name: DeveloperFixture.updated_company_name
  )
  expect(page).to have_content(success_flash)

  within ".record-list" do
    expect(page).to have_no_content DeveloperFixture.updated_company_name
  end
end
