# frozen_string_literal: true
When(/^I create a developer$/) do
  visit "/"

  within ".navbar" do
    click_on t("components.navigation.developers")
  end

  click_on t("developers.index.add")

  fill_in "developer_company_name", with: DeveloperFixture.company_name
  click_on t("developers.form.submit")
end

Then(/^I should see the created developer$/) do
  expect(page).to have_content(DeveloperFixture.company_name)
end

When(/^I update the developer$/) do
  find("[data-action='edit']").click

  fill_in "developer_company_name", with: DeveloperFixture.updated_company_name
  fill_in "developer_postal_name", with: DeveloperFixture.postal_name
  fill_in "developer_building_name", with: DeveloperFixture.building_name
  fill_in "developer_road_name", with: DeveloperFixture.road_name
  fill_in "developer_city", with: DeveloperFixture.city
  fill_in "developer_county", with: DeveloperFixture.county
  fill_in "developer_postcode", with: DeveloperFixture.postcode
  fill_in "developer_email", with: DeveloperFixture.email
  fill_in "developer_contact_number", with: DeveloperFixture.contact_number
  fill_in "developer_about", with: DeveloperFixture.about
  click_on t("developers.form.submit")
end

Then(/^I should see the updated developer$/) do
  # On the index page
  within ".record-list" do
    expect(page).to have_content(DeveloperFixture.updated_company_name)
  end

  # and on the edit page
  click_on DeveloperFixture.updated_company_name

  [
    :postal_name,
    :building_name,
    :road_name,
    :city,
    :county,
    :postcode,
    :email,
    :contact_number,
    :about
  ].each do |attr|
    value = find("[name='developer[#{attr}]']").value
    expect(value).to eq(DeveloperFixture.send(attr))
  end
end

When(/^I delete the developer$/) do
  click_on t("developers.edit.back")

  # Launches the confirmation dialog
  btn = find(".archive-btn")
  # HACK! Can't get around needing this sleep :(
  sleep 0.5
  btn.click

  # Click the "real" delete in the confirmation dialog
  find(".btn-delete").trigger("click")
end

Then(/^I should see the delete complete successfully$/) do
  success_flash = t(
    "developers.archive.success",
    developer_name: DeveloperFixture.updated_company_name
  )
  expect(page).to have_content(success_flash)

  within ".record-list" do
    expect(page).to have_no_content DeveloperFixture.company_name
  end
end
