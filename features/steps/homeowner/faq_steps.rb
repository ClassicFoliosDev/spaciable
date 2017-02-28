# frozen_string_literal: true
Given(/^I am logged in as a homeowner wanting to read FAQs$/) do
  MyHomeFaqsFixture.setup

  login_as MyHomeFaqsFixture.resident
  visit "/"
end

When(/^I go to read the FAQs for my home$/) do
  within ".navbar" do
    click_on t("layouts.homeowner.nav.my_home")
  end

  click_on t("layouts.homeowner.sub_nav.faqs")
end

Then(/^I should see the FAQs related to settling in$/) do
  MyHomeFaqsFixture.default_filtered_faqs.each do |question, answer|
    expect(page).to have_content(question)
    expect(page).to have_content(answer)
  end

  MyHomeFaqsFixture.default_filtered_out_faqs.each do |question, answer|
    expect(page).not_to have_content(question)
    expect(page).not_to have_content(answer)
  end

  active_category = find(".categories .active").text
  expect(active_category).to eq(MyHomeFaqsFixture.default_category_name)
end

When(/^I filter my FAQs by a different category$/) do
  click_on MyHomeFaqsFixture.other_category_name
end

Then(/^I should only see the FAQs in the other category$/) do
  MyHomeFaqsFixture.filtered_faqs.each do |question, answer|
    expect(page).to have_content(question)
    expect(page).to have_content(answer)
  end

  MyHomeFaqsFixture.filtered_out_faqs.each do |question, answer|
    expect(page).not_to have_content(question)
    expect(page).not_to have_content(answer)
  end

  active_category = find(".categories .active").text
  expect(active_category).to eq(MyHomeFaqsFixture.other_category_name)
end
