# frozen_string_literal: true
Given(/^I am a (\w+) Admin and I want to manage FAQs$/) do |admin_type|
  FaqsFixture.setup

  admin = FaqsFixture.create_admin(admin_type)
  login_as admin
  visit "/"
end

When(/^I create a FAQ for a Developer$/) do
  click_on t("components.navigation.developers")
  click_on FaqsFixture.developer
  click_on t("developers.collection.faqs")
  click_on t("faqs.collection.add")

  attrs = FaqsFixture.faq_attrs(:created, under: :developer)

  fill_in :faq_question, with: attrs[:question]
  fill_in :faq_answer, with: attrs[:answer]

  category = FaqsFixture.t_category(attrs[:category])
  select_from_selectmenu :faq_category, with: category

  click_on t("faqs.form.submit")
end

Then(/^I should see the (created|updated) Developer FAQ$/) do |action|
  attrs = FaqsFixture.faq_attrs(action, under: :developer)
  notice = t("faqs.#{action.gsub(/d\Z/, '')}.success", title: attrs[:question])

  expect(page).to have_content(notice)

  expect(page).to have_content(attrs[:question])
  category = FaqsFixture.t_category(attrs[:category])
  expect(page).to have_content(category)

  within ".breadcrumbs" do
    expect(page).to have_content(FaqsFixture.developer)
  end

  click_on attrs[:question]
  expect(page).to have_content(attrs[:question])
  expect(page).to have_content(attrs[:answer])
  category = FaqsFixture.t_category(attrs[:category])
  expect(page).to have_content(category)

  click_on t("faqs.show.back")
end

When(/^I update the Developer FAQ$/) do
  faq_id = FaqsFixture.faq_id(under: :developer)

  within "[data-faq='#{faq_id}']" do
    find("[data-action='edit']").trigger("click")
  end

  attrs = FaqsFixture.faq_attrs(:updated, under: :developer)

  fill_in :faq_question, with: attrs[:question]
  fill_in :faq_answer, with: attrs[:answer]

  category = FaqsFixture.t_category(attrs[:category])
  select_from_selectmenu :faq_category, with: category

  click_on t("faqs.form.submit")
end

When(/^I delete the Developer FAQ$/) do
  faq_id = FaqsFixture.faq_id(under: :developer, updated: true)

  delete_and_confirm!(scope: "[data-faq='#{faq_id}']")
end

Then(/^I should no longer see the Developer FAQ$/) do
  attrs = FaqsFixture.faq_attrs(:updated, under: :developer)
  notice = t("faqs.destroy.success", title: attrs[:subject])

  expect(page).to have_content(notice)

  within ".record-list" do
    expect(page).not_to have_content(attrs[:question])
  end

  within ".breadcrumbs" do
    expect(page).to have_link(FaqsFixture.developer)
  end
end

Given(/^my Divisions Developer has FAQs$/) do
  FaqsFixture.create_faqs
end

Then(/^I should only be able to see the Developers FAQs for my Division$/) do
  click_on t("components.navigation.developers")
  click_on FaqsFixture.developer
  click_on t("developers.collection.faqs")

  expect(page).not_to have_link(t("faqs.collection.add"))

  attrs = FaqsFixture.faq_attrs(:created, under: :developer)

  within ".record-list" do
    click_on attrs[:question]
  end

  expect(page).to have_content(attrs[:question])
  expect(page).to have_content(attrs[:answer])
  category = FaqsFixture.t_category(attrs[:category])
  expect(page).to have_content(category)
end

Given(/^my Developments Developer has FAQs$/) do
  pending # Write code here that turns the phrase above into concrete actions
end

Then(/^I should be able to see the Developers FAQs for my Development$/) do
  pending # Write code here that turns the phrase above into concrete actions
end

Given(/^I am a \(Division\) Development Admin and I want to manage FAQs$/) do
  pending # Write code here that turns the phrase above into concrete actions
end

Given(/^my \(Division\) Developments Developer has FAQs$/) do
  pending # Write code here that turns the phrase above into concrete actions
end

Then(/^I should be able to see the Developers FAQs for my \(Division\) Development$/) do
  pending # Write code here that turns the phrase above into concrete actions
end
