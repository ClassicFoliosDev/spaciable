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
    check :faq_notify
    click_on t("faqs.form.submit")
  end
end

Then(/^I should see the (created|updated) (\(\w+\) )?(\w+) FAQ$/) do |action, parent, resource|
  attrs = FaqsFixture.faq_attrs(action, parent, under: resource)
  category = FaqsFixture.t_category(attrs[:category])
  notice = t("controller.success.#{action.gsub(/d\Z/, '')}", name: attrs[:question])
  notice << t("resident_notification_mailer.notify.update_sent", count: Resident.all.count) if action == "updated"

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
    expect(page).to have_content(attrs[:question])
  end
end

Then(/^I should see the faq resident has been notified$/) do
  in_app_notification = Notification.all.last
  expect(in_app_notification.residents.count).to eq 1
  expect(in_app_notification.residents.first.email).to eq CreateFixture.resident.email

  email_notification = ActionMailer::Base.deliveries.first
  question = FaqsFixture.faq_attrs(:created, under: :division)[:question]
  message = "FAQ #{question} has been added to your home"
  expect(email_notification.parts.first.body.raw_source).to include message

  ActionMailer::Base.deliveries.clear
end

When(/^I select development level FAQs$/) do
  developer = CreateFixture.developer

  visit "/developers/#{developer.id}/edit"

  within ".edit_developer" do
    check :developer_development_faqs

    click_on t("developers.form.submit")
  end

  development = CreateFixture.development
  visit "/developers/#{developer.id}/developments/#{development.id}"
end

When(/^I deselect development level FAQs$/) do
  developer = CreateFixture.developer

  visit "/developers/#{developer.id}/edit"

  within ".edit_developer" do
    uncheck :developer_development_faqs

    click_on t("developers.form.submit")
  end

  development = CreateFixture.development
  visit "/developers/#{developer.id}/developments/#{development.id}"
end


Then(/^I should not see default faqs for the developer$/) do
  click_on CreateFixture.developer_name

  within ".tabs" do
    click_on t("developers.collection.faqs")
  end

  within ".empty" do
    expect(page).to have_content "You have no FAQs"
  end
end

When(/^I create a development$/) do
  developer = CreateFixture.developer

  visit "/developers/#{developer.id}/developments/new"

  within ".development_name" do
    fill_in :development_name, with: CreateFixture.development_name
  end

  within ".form-actions-footer" do
    click_on t("developments.form.submit")
  end

  within ".developments" do
    click_on CreateFixture.development_name
  end
end

Then(/^I should see default faqs for the development$/) do
  within ".developments" do
    click_on CreateFixture.development_name
  end

  within ".tabs" do
    click_on t("developments.collection.faqs")
  end

  DeveloperFixture.default_faqs.each do |question, category|
    expect(page).to have_content(question)
    expect(page).to have_content(category)
  end

end

When(/^I create a developer with development level FAQs$/) do
  visit "/developers/new"

  within ".new_developer" do
    fill_in :developer_company_name, with: CreateFixture.developer_name
    check "developer_development_faqs"

    click_on t("developers.form.submit")
  end
end

When(/^I edit a developer faq$/) do

  faq_params = DeveloperFixture.default_faqs.first
  faq = Faq.find_by(question: faq_params.first)

  within "[data-faq='#{faq.id}']" do
    find("[data-action='edit']").trigger("click")
  end

  within ".faq" do
    fill_in :faq_question, with: FaqsFixture.edited_question
  end

  click_on t("faqs.form.submit")
end

Then(/^I should see no faqs for the development$/) do
  within ".tabs" do
    click_on t("developments.collection.faqs")
  end

  within ".empty" do
    expect(page).to have_content "You have no FAQs"
  end
end

Then(/^I should not see the edited faq in the development faqs$/) do
  within ".tabs" do
    click_on t("developments.collection.faqs")
  end

  within ".faqs" do
    expect(page).not_to have_content FaqsFixture.edited_question
    DeveloperFixture.default_faqs.each do |question, category|
      expect(page).to have_content(question)
      expect(page).to have_content(category)
    end
  end
end

When(/^I create a second development$/) do
  developer = CreateFixture.developer

  visit "/developers/#{developer.id}/developments/new"

  within ".development_name" do
    fill_in :development_name, with: FaqsFixture.development2_name
  end

  within ".form-actions-footer" do
    click_on t("developments.form.submit")
  end

  within ".developments" do
    click_on FaqsFixture.development2_name
  end
end

When(/^I create a third development$/) do
  developer = CreateFixture.developer

  visit "/developers/#{developer.id}/developments/new"

  within ".development_name" do
    fill_in :development_name, with: FaqsFixture.development3_name
  end

  within ".form-actions-footer" do
    click_on t("developments.form.submit")
  end

  within ".developments" do
    click_on FaqsFixture.development3_name
  end
end
