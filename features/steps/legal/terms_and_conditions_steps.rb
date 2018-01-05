# frozen_string_literal: true

When(/^I visit the ts_and_cs page$/) do
  visit "/"

  within ".footer" do
    click_on t("components.homeowner.footer.ts_and_cs")
  end
end

When(/^I visit the admin ts_and_cs page$/) do
  visit "/"

  within ".copyright-footer" do
    click_on t("components.homeowner.footer.ts_and_cs")
  end
end

Then(/^I should see the terms and conditions for using Hoozzi$/) do
  within ".policy" do
    expect(page).to have_content(t("legal.ts_and_cs_homeowner.title"))
    expect(page).to have_content(t("legal.ts_and_cs_homeowner.about_us"))
    expect(page).to have_content(t("legal.ts_and_cs_homeowner.ip"))
    expect(page).to have_content(t("legal.ts_and_cs_homeowner.law"))
    expect(page).to have_content(t("legal.ts_and_cs_homeowner.limitation"))
    expect(page).to have_content(t("legal.ts_and_cs_homeowner.viruses"))
    expect(page).to have_content(t("legal.ts_and_cs_homeowner.welcome").first(30))
    expect(page).to have_content(t("legal.ts_and_cs_homeowner.changes"))
    expect(page).to have_content(t("legal.ts_and_cs_homeowner.severance"))
    expect(page).to have_content(t("legal.ts_and_cs_homeowner.third_party"))
  end
end

When(/^I visit the privacy page$/) do
  visit "/"

  within ".footer" do
    click_on t("components.homeowner.footer.privacy")
  end
end

When(/^I visit the admin privacy page$/) do
  visit "/"

  within ".copyright-footer" do
    click_on t("components.homeowner.footer.privacy")
  end
end

Then(/^I should see the privacy information for using Hoozzi$/) do
  within ".policy" do
    expect(page).to have_content(t("legal.data_policy.title"))
    expect(page).to have_content(t("legal.data_policy.information"))
    expect(page).to have_content(t("legal.data_policy.links"))
    expect(page).to have_content(t("legal.data_policy.what_we_do"))
    expect(page).to have_content(t("legal.data_policy.where_we_store"))
    expect(page).to have_content(t("legal.data_policy.who_we_are"))
    expect(page).to have_content(t("legal.data_policy.your_rights"))
  end
end

When(/^I visit the admin ts_and_cs page directly$/) do
  visit "/ts_and_cs_admin"
end

When(/^I visit the ts_and_cs page directly$/) do
  visit "/ts_and_cs_homeowner"
end

When(/^I visit the privacy page directly$/) do
  visit "/data_policy"
end

Then(/^I should see the terms and conditions for administrators using Hoozzi$/) do
  within ".policy" do
    expect(page).to have_content(t("legal.ts_and_cs_admin.title"))
    expect(page).to have_content(t("legal.ts_and_cs_admin.about_us"))
    expect(page).to have_content(t("legal.ts_and_cs_admin.ip"))
    expect(page).to have_content(t("legal.ts_and_cs_admin.accuracy"))
    expect(page).to have_content(t("legal.ts_and_cs_admin.law"))
    expect(page).to have_content(t("legal.ts_and_cs_admin.limitation"))
    expect(page).to have_content(t("legal.ts_and_cs_admin.security"))
    expect(page).to have_content(t("legal.ts_and_cs_admin.viruses"))
    expect(page).to have_content(t("legal.ts_and_cs_admin.welcome").first(80))
  end
end

Then(/^I should not be recorded as accepting ts and cs$/) do
  resident = Resident.find_by(email: PlotResidencyFixture.original_email)

  expect(resident.ts_and_cs_accepted_at).to be_nil
end

Then(/^I should have been recorded as accepting ts and cs$/) do
  resident = Resident.find_by(email: PlotResidencyFixture.original_email)

  expect(resident.ts_and_cs_accepted_at).not_to be_nil
end

When(/^the ts and cs are reset$/) do
  require 'rake'

  rake = Rake::Application.new
  Rake.application = rake
  Rake::Task.define_task(:environment)
  load Rails.root.join("lib", "tasks", "reset_ts_and_cs.rake")
  rake["ts_and_cs:reset"].invoke
end

When(/^I accept the ts and cs$/) do
  within ".sign-in" do
    fill_in :resident_email, with: PlotResidencyFixture.original_email
    fill_in :resident_password, with: HomeownerUserFixture.updated_password

    check_box = find(".accept-ts-and-cs")
    check_box.trigger(:click)

    click_on t("residents.sessions.new.login_cta")
  end
end

Then(/^I should not be prompted for ts and cs$/) do
  expect(page).not_to have_content("[disabled]")
end

Then(/^I should be prompted for ts and cs$/) do
  visit "/"

  within ".sign-in" do
    expect(page).to have_selector ".accept-ts-and-cs"

    disabled_btn = page.find("[disabled]")
    expect(disabled_btn.value).to eq t("residents.sessions.new.login_cta")
  end
end

Then(/^I should be prompted for ts and cs on next action$/) do
  within ".navbar-menu" do
    click_on t("layouts.homeowner.nav.how_to")
  end

  within ".sign-in" do
    expect(page).to have_selector ".accept-ts-and-cs"

    disabled_btn = page.find("[disabled]")
    expect(disabled_btn.value).to eq t("residents.sessions.new.login_cta")
  end
end

Given(/^there is a second homeowner$/) do
  plot = CreateFixture.phase_plot
  FactoryGirl.create(:resident, :with_residency,
                     plot: plot,
                     email: TermsAndConditionsFixture.email,
                     password: TermsAndConditionsFixture.password)
end

When(/^I log in as the second homeowner$/) do
  visit "/"

  within ".sign-in" do
    fill_in :resident_email, with: TermsAndConditionsFixture.email
    fill_in :resident_password, with: TermsAndConditionsFixture.password

    click_on t("residents.sessions.new.login_cta")
  end
end
