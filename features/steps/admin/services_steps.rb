# frozen_string_literal: true

When(/^I create a service$/) do
  goto_development_show_page

  within ".tabs" do
    click_on t("developments.collection.services")
  end

  within ".empty" do
    click_on t("components.empty_list.add", type_name: Service.model_name.human.downcase)
  end

  within ".row" do
    fill_in "service_name", with: ServiceFixture.name
    fill_in "service_description", with: ServiceFixture.description
  end

  click_on t("rooms.form.submit")
end

When(/^I create a service for the division development$/) do
  goto_division_development_show_page

  within ".tabs" do
    click_on t("developments.collection.services")
  end

  within ".empty" do
    click_on t("components.empty_list.add", type_name: Service.model_name.human.downcase)
  end

  within ".row" do
    fill_in "service_name", with: ServiceFixture.name
    fill_in "service_description", with: ServiceFixture.description
  end

  click_on t("rooms.form.submit")
end

Then(/^I should see the created service$/) do
  success_flash = t(
    "controller.success.create",
    name: ServiceFixture.name
  )

  expect(page).to have_content(success_flash)

  within ".record-list" do
    expect(page).to have_content(ServiceFixture.name)
    expect(page).to have_content(ServiceFixture.description)
  end
end

When(/^I update the service$/) do
  within ".record-list" do
    find("[data-action='edit']").click
  end

  within ".row" do
    fill_in "service_name", with: ServiceFixture.updated_name
    fill_in "service_description", with: ServiceFixture.updated_description
  end

  click_on t("rooms.form.submit")
end

Then(/^I should see the updated service$/) do
  success_flash = t(
    "controller.success.update",
    name: ServiceFixture.updated_name
  )

  expect(page).to have_content(success_flash)

  within ".record-list" do
    expect(page).to have_content(ServiceFixture.updated_name)
    expect(page).to have_content(ServiceFixture.updated_description)
  end
end

When(/^I delete the service$/) do
  delete_and_confirm!
end

Then(/^I should no longer see the service$/) do
  success_flash = t(
    "controller.success.destroy",
    name: ServiceFixture.updated_name
  )
  expect(page).to have_content(success_flash)

  expect(page).not_to have_content(".record-list")

  within ".empty" do
    expect(page).to have_content t("components.empty_list.add", type_name: Service.model_name.human.downcase)
  end
end

Then(/^I should not see the services tab$/) do
  goto_development_show_page

  within ".tabs" do
    expect(page).not_to have_content(t("developments.collection.services"))
  end
end

Then(/^I should not see the division development services tab$/) do
  goto_division_development_show_page

  within ".tabs" do
    expect(page).not_to have_content(t("developments.collection.services"))
  end
end
