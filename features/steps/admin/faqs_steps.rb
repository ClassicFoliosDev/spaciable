# frozen_string_literal: true
Given(/^FAQ metadata is available$/) do
  FaqsFixture.create_faq_ref
end

Given(/^I am a (\(\w+\) )?(\w+) Admin and I want to manage FAQs$/) do |parent_type, admin_type|
  CreateFixture.create_countries
  FaqsFixture.create_developer_division_development_divdevelopment

  admin = FaqsFixture.create_admin(admin_type, parent_type)
  login_as admin
  visit "/"
end

When(/^I create a FAQ for a (\(\w+\) )?(\w+)$/) do |parent, resource|
  goto_resource_show_page(parent, resource)
  sleep 0.4

  attrs = FaqsFixture.attrs(:created, parent, under: resource)
  find(:xpath,"//a[contains(., '#{attrs[:faq_type].name}')]", visible: all).trigger('click')

  within ".main-container" do
    click_on t("faqs.collection.add", type: attrs[:faq_type].name)
  end

  within ".new_faq" do
    fill_in :faq_question, with: attrs[:question]
    fill_in_ckeditor(:faq_answer, with: attrs[:answer])

    select_from_selectmenu :faq_faq_category, with: attrs[:faq_category].name
    check :faq_notify
    click_on t("faqs.form.submit")
  end
end

Then(/^I should see the (created|updated) (\(\w+\) )?(\w+) FAQ$/) do |action, parent, resource|
  attrs = FaqsFixture.attrs(action, parent, under: resource)
  notice = t("controller.success.#{action.gsub(/d\Z/, '')}", name: attrs[:question])
  notice << t("resident_notification_mailer.notify.update_sent", count: Resident.all.count) if action == "updated"

  sleep 0.3
  within ".notice" do
    expect(page).to have_content(notice)
  end

  within ".faqs" do
    expect(page).to have_content(attrs[:question])
    expect(page).to have_content(attrs[:faq_category].name)
  end

  within ".breadcrumbs" do
    expect(page).to have_content(CreateFixture.get(resource, parent))
  end

  within ".record-list" do
    click_on attrs[:question]
  end

  within ".section-title" do
    expect(page).to have_content(attrs[:question])
  end

  within ".faq" do
    expect(page).to have_content(attrs[:answer])
    expect(page).to have_content(attrs[:faq_category].name)
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

  attrs = FaqsFixture.attrs(:updated, parent, under: resource)

  within ".faq" do
    fill_in :faq_question, with: attrs[:question]
    fill_in_ckeditor(:faq_answer, with: attrs[:answer])
    select_from_selectmenu :faq_faq_category, with: attrs[:faq_category].name
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
  attrs = FaqsFixture.attrs(:updated, under: :developer)
  notice = t("controller.success.destroy", name: attrs[:subject])

  expect(page).to have_content(notice)

  within ".breadcrumbs" do
    expect(page).to have_link(FaqsFixture.developer)
  end

  expect(page).not_to have_content(".record-list")

  within ".empty" do
    expect(page).to have_content %r{#{t("components.empty_list.add", action: "Add", type_name: attrs[:faq_type].name)}}i
  end
end

Given(/^my .+ (\w+) has FAQs$/) do |resource|
  FaqsFixture.create_faqs_for(resource)
end

Then(/^I should only be able to see the (\w+) FAQs for my .+$/) do |parent_resource|
  attrs = FaqsFixture.attrs(:created, under: parent_resource)

  goto_resource_show_page(nil, parent_resource)

  sleep 0.2
  find(:xpath,"//a[contains(., '#{attrs[:faq_type].name}')]", visible: all).trigger('click')

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

  email = ActionMailer::Base.deliveries.first
  question = FaqsFixture.attrs(:created, under: :division)[:question]
  expect(email).to have_body_text("The following FAQ has been added to your home's online portal:")
  expect(email).to have_body_text("#{question}")

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

  CreateFixture.developer.faq_types.each do |faq_type|
    find(:xpath,"//a[contains(., '#{faq_type.name}')]", visible: all).trigger('click')

    within ".empty" do
      expect(page).to have_content t("faqs.collection.empty_list", type: faq_type.name)
    end
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

  CreateFixture.developer.faq_types.each do |faq_type|
    find(:xpath,"//a[contains(., '#{faq_type.name}')]", visible: all).trigger('click')

    DeveloperFixture.default_faqs.select {|faq| faq[:faq_type] == faq_type }.each do |faq|
      expect(page).to have_content(faq[:question])
      expect(page).to have_content(faq[:faq_category].name)
    end
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

  find(:xpath,"//a[contains(., '#{faq_params[:faq_type].name}')]", visible: all).trigger('click')

  within "[data-faq='#{faq.id}']" do
    find("[data-action='edit']").trigger("click")
  end

  within ".faq" do
    fill_in :faq_question, with: FaqsFixture.edited_question
  end

  click_on t("faqs.form.submit")
end

Then(/^I should see no faqs for the development$/) do

  CreateFixture.development.faq_types.each do |faq_type|
    find(:xpath,"//a[contains(., '#{faq_type.name}')]", visible: all).trigger('click')

    within ".empty" do
      expect(page).to have_content t("faqs.collection.empty_list", type: faq_type.name)
    end
  end
end

Then(/^I should not see the edited faq in the development faqs$/) do

  CreateFixture.development.faq_types.each do |faq_type|
    find(:xpath,"//a[contains(., '#{faq_type.name}')]", visible: all).trigger('click')

    within ".faqs" do
      expect(page).not_to have_content FaqsFixture.edited_question
      DeveloperFixture.default_faqs.select {|faq| faq[:faq_type] == faq_type }.each do |faq|
        expect(page).to have_content(faq[:question])
        expect(page).to have_content(faq[:faq_category].name)
      end
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

When(/^I sync the FAQs$/) do
  within ".main-container" do
    click_on I18n.t(".faqs.collection.import", type: "Tenant")
  end
end

When(/^I edit a developer tenant faq$/) do
  faq_params = DeveloperFixture.default_faqs.last
  faq = Faq.find_by(question: faq_params.first)

  within "[data-faq='#{faq.id}']" do
    find("[data-action='edit']").trigger("click")
  end

  within ".faq" do
    fill_in_ckeditor(:faq_answer, with: FaqsFixture.edited_answer)
  end

  click_on t("faqs.form.submit")
end

Then(/^I see the edited FAQ$/) do
  faq_params = DeveloperFixture.default_faqs.last
  faq = Faq.find_by(question: faq_params.first)

  within ".faq-collection" do
    page.find(".answer_updated") do
      expect(page).to have_content faq.question
    end
  end
end

Then(/^I see the identical FAQ$/) do
  within ".faq-collection" do
    page.find(".exact_match")
  end
end

Then(/^I can add a development tenant FAQ$/) do
  within ".lower" do
    click_on I18n.t(".faqs.collection.add", type: "Tenant")
  end

  within ".faq" do
    fill_in :faq_question, with: "Can I leave in 6 months?"
    fill_in_ckeditor(:faq_answer, with: FaqsFixture.edited_answer)
    select_from_selectmenu :faq_faq_category, with: "General"
  end

  click_on t("faqs.form.submit")
end

Then(/^I see the altered FAQ$/) do
  faq = Faq.last

  within ".faq-collection" do
    page.find(".answer_legacy") do
      expect(page).to have_content faq.question
    end
  end
end

Then(/^I see the new FAQ$/) do
  within ".faq-collection" do
    page.find(".no_match")
  end
end

When(/^I select the FAQs to sync$/) do
  within ".sync-faqs-select-buttons" do
    click_on I18n.t(".sync_faqs.index.select", type: "Tenant")
  end

  within ".form-actions-footer" do
    click_on I18n.t(".sync_faqs.index.submit")
  end

  within ".ui-dialog-buttonpane" do
    click_on "Confirm"
  end
end

Then(/^the edited FAQ is updated$/) do
  faq_params = DeveloperFixture.default_faqs.last
  faq = Faq.find_by(question: faq_params.first)

  within ".record-list" do
    click_on faq.question
  end

  expect(page).to have_content faq.answer
  expect(page).to_not have_content FaqsFixture.edited_answer

  within ".form-actions-footer" do
    click_on "Back"
  end
end

Then(/^the new FAQ has been created$/) do
  faq = DefaultFaq.find_by(question: "When can I leave?")

  within ".record-list" do
    click_on faq.question
  end
  expect(page).to have_content faq.answer
end
