# frozen_string_literal: true

Given(/^I update the development to have maintenance$/) do
  click_on CreateFixture.development_name

  within ".section-data" do
    find("[data-action='edit']").click
  end
end

Given(/^I do not enter an account type$/) do
  fill_in :development_maintenance_attributes_path, with: "https://demo.fixflo.com/issue/plugin"

  within ".form-actions-footer" do
    click_on "Submit"
  end
end

Then(/^I see an error that I need to enter an account type$/) do
  within ".submission-errors" do
    notice = "Maintenance account type #{I18n.t("activerecord.errors.messages.blank")}"
    expect(page).to have_content(notice)
  end
end

When(/^I enter an account type$/) do
  select_from_selectmenu :development_maintenance_account_type,
                         with: I18n.t("activerecord.attributes.maintenance.account_types.full_works")

  within ".form-actions-footer" do
    click_on "Submit"
  end
end

Then(/^I see the maintenance record has been created$/) do
  sleep 0.5
  within ".section-title" do
    expect(page).to have_content CreateFixture.development_name
  end
  development = CreateFixture.development
  maintenance = Maintenance.find_by(development_id: development.id)
  expect(maintenance.path).to eq "https://demo.fixflo.com/issue/plugin"
  expect(maintenance.account_type).to eq "full_works"
  expect(maintenance.populate).to eq true
end

Given(/^I update the maintenance for the development$/) do
  within ".section-data" do
    find("[data-action='edit']").click
  end

  select_from_selectmenu :development_maintenance_account_type,
                           with: I18n.t("activerecord.attributes.maintenance.account_types.standard")

  within ".form-actions-footer" do
    click_on "Submit"
  end
end

Then(/^I see the maintenance record has been updated$/) do
  sleep 0.5
  within ".section-title" do
    expect(page).to have_content CreateFixture.development_name
  end
  development = CreateFixture.development
  expect(Maintenance.all.count).to eq 1  # check that no additional records were created
  maintenance = Maintenance.find_by(development_id: development.id)
  expect(maintenance.path).to eq "https://demo.fixflo.com/issue/plugin"
  expect(maintenance.populate).to eq true
  expect(maintenance.account_type).to eq "standard"
end
