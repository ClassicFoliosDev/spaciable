# frozen_string_literal: true

Given(/^I am a (\(\w+\) )?(\w+) Admin and I want to manage FAQs$/) do |parent_type, admin_type|
  FaqsFixture.setup

  admin = FaqsFixture.create_admin(admin_type, parent_type)
  login_as admin
  visit "/"
end

When(/^I create a FAQ for a (\(\w+\) )?(\w+)$/) do |parent, resource|
  goto_resource_show_page(parent, resource)
  sleep 0.4

  within ".tabs" do
    click_on t("developers.collection.faqs")
  end

  within ".main-container" do
    click_on t("faqs.collection.add")
  end

  attrs = FaqsFixture.faq_attrs(:created, parent, under: resource)
  category = FaqsFixture.t_category(attrs[:category])

  within ".new_faq" do
    fill_in :faq_question, with: attrs[:question]
    fill_in_ckeditor(:faq_answer, with: attrs[:answer])

    select_from_selectmenu :faq_category, with: category
    click_on t("faqs.form.submit")
  end
end

Then(/^I should see the (created|updated) (\(\w+\) )?(\w+) FAQ$/) do |action, parent, resource|
  attrs = FaqsFixture.faq_attrs(action, parent, under: resource)
  category = FaqsFixture.t_category(attrs[:category])
  notice = t("controller.success.#{action.gsub(/d\Z/, '')}", name: attrs[:question])
  notice << t("resident_notification_mailer.notify.update_sent", count: 0) if action == "updated"

  within ".notice" do
    expect(page).to have_content(notice)
  end

  within ".faqs" do
    expect(page).to have_content(attrs[:question])
    expect(page).to have_content(category)
  end

  within ".breadcrumbs" do
    expect(page).to have_content(CreateFixture.get(resource, parent))
  end

  within ".record-list" do
    click_on attrs[:question]
  end

  within ".faq" do
    expect(page).to have_content(attrs[:question])
    expect(page).to have_content(attrs[:answer])
    expect(page).to have_content(category)
  end

  within ".form-actions-footer-container" do
    click_on t("faqs.show.back")
  end
end

When(/^I update the (\(\w+\) )?(\w+) FAQ$/) do |parent, resource|
  faq_id = FaqsFixture.faq_id(parent, under: resource)

  within "[data-faq='#{faq_id}']" do
    find("[data-action='edit']").trigger("click")
  end

  attrs = FaqsFixture.faq_attrs(:updated, parent, under: resource)
  category = FaqsFixture.t_category(attrs[:category])

  within ".faq" do
    fill_in :faq_question, with: attrs[:question]
    fill_in_ckeditor(:faq_answer, with: attrs[:answer])
    select_from_selectmenu :faq_category, with: category
  end

  within ".form-actions-footer-container" do
    check :faq_notify
    click_on t("faqs.form.submit")
  end
end

When(/^I delete the Developer FAQ$/) do
  faq_id = FaqsFixture.faq_id(under: :developer, updated: true)

  delete_and_confirm!(scope: "[data-faq='#{faq_id}']")
end

Then(/^I should no longer see the Developer FAQ$/) do
  attrs = FaqsFixture.faq_attrs(:updated, under: :developer)
  notice = t("controller.success.destroy", name: attrs[:subject])

  expect(page).to have_content(notice)

  within ".breadcrumbs" do
    expect(page).to have_link(FaqsFixture.developer)
  end

  expect(page).not_to have_content(".record-list")

  within ".empty" do
    expect(page).to have_content t("components.empty_list.add", type_name: Faq.model_name.human)
  end
end

Given(/^my .+ (\w+) has FAQs$/) do |resource|
  FaqsFixture.create_faqs_for(resource)
end

Then(/^I should only be able to see the (\w+) FAQs for my .+$/) do |parent_resource|
  attrs = FaqsFixture.faq_attrs(:created, under: parent_resource)

  goto_resource_show_page(nil, parent_resource)

  sleep 0.2
  within ".tabs" do
    click_on t("developers.collection.faqs")
  end

  within ".main-container" do
    expect(page).not_to have_link(t("faqs.collection.add"))
  end

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
