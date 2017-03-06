# frozen_string_literal: true
Given(/^I am a (\(\w+\) )?(\w+) Admin and I want to manage FAQs$/) do |parent_type, admin_type|
  FaqsFixture.setup

  admin = FaqsFixture.create_admin(admin_type, parent_type)
  login_as admin
  visit "/"
end

When(/^I create a FAQ for a (\(\w+\) )?(\w+)$/) do |parent, resource|
  goto_resource_show_page(parent, resource)

  click_on t("developers.collection.faqs")
  click_on t("faqs.collection.add")

  attrs = FaqsFixture.faq_attrs(:created, parent, under: resource)

  fill_in :faq_question, with: attrs[:question]
  fill_in_ckeditor(:faq_answer, with: attrs[:answer])

  category = FaqsFixture.t_category(attrs[:category])
  select_from_selectmenu :faq_category, with: category

  sleep 0.3
  click_on t("faqs.form.submit")
end

Then(/^I should see the (created|updated) (\(\w+\) )?(\w+) FAQ$/) do |action, parent, resource|
  attrs = FaqsFixture.faq_attrs(action, parent, under: resource)
  category = FaqsFixture.t_category(attrs[:category])
  notice = t("faqs.#{action.gsub(/d\Z/, '')}.success", title: attrs[:question])

  expect(page).to have_content(notice)
  expect(page).to have_content(attrs[:question])
  expect(page).to have_content(category)

  within ".breadcrumbs" do
    expect(page).to have_content(CreateFixture.get(resource, parent))
  end

  within ".record-list" do
    click_on attrs[:question]
  end

  expect(page).to have_content(attrs[:question])
  expect(page).to have_content(attrs[:answer])
  expect(page).to have_content(category)

  click_on t("faqs.show.back")
end

When(/^I update the (\(\w+\) )?(\w+) FAQ$/) do |parent, resource|
  faq_id = FaqsFixture.faq_id(parent, under: resource)

  within "[data-faq='#{faq_id}']" do
    find("[data-action='edit']").trigger("click")
  end

  attrs = FaqsFixture.faq_attrs(:updated, parent, under: resource)

  fill_in :faq_question, with: attrs[:question]
  fill_in_ckeditor(:faq_answer, with: attrs[:answer])

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

Given(/^my .+ (\w+) has FAQs$/) do |resource|
  FaqsFixture.create_faqs_for(resource)
end

Then(/^I should only be able to see the (\w+) FAQs for my .+$/) do |parent_resource|
  attrs = FaqsFixture.faq_attrs(:created, under: parent_resource)

  goto_resource_show_page(nil, parent_resource)

  click_on t("developers.collection.faqs")

  expect(page).not_to have_link(t("faqs.collection.add"))

  within ".record-list" do
    expect(page).not_to have_selector("[data-action='edit']")
    expect(page).not_to have_selector("[data-action='delete']")

    click_on attrs[:question]
  end

  expect(page).to have_content(attrs[:question])
  expect(page).to have_content(attrs[:answer])
  category = FaqsFixture.t_category(attrs[:category])
  expect(page).to have_content(category)
end
