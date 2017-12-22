# frozen_string_literal: true

When(/^I visit the ts_and_cs page$/) do
  visit "/"

  within ".footer" do
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
