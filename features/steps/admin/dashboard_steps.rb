# frozen_string_literal: true

When(/^I navigate to the dashboard$/) do
  visit "/"
end

Then(/^I see blank recent contents$/) do
  within ".notifications" do
    expect(page).to have_content(t("admin.dashboard.components.no_recent.no_recent", type_names: Notification.model_name.human.pluralize))
  end
  within ".faqs" do
    expect(page).to have_content(t("admin.dashboard.components.no_recent.no_recent", type_names: Faq.model_name.human.pluralize))
  end
  within ".documents" do
    expect(page).to have_content(t("admin.dashboard.components.no_recent.no_recent", type_names: Document.model_name.human.pluralize))
  end
end

Then(/^I see the recent contents$/) do
  within ".notifications" do
    expect(page).to have_content(t("admin.notifications.collection.add"))
  end
  within ".faqs" do
    expect(page).to have_content(FaqsFixture.settling_name)
  end
  within ".documents" do
    expect(page).to have_content(t("activerecord.attributes.document.categories.legal_and_warranty"))
    expect(page).to have_content(t(".guide"))
    expect(page).to have_content("Development Document")
  end
end

When(/^I navigate to the help page$/) do
  visit "/"
  click_on t("components.navigation.help")
end

Then(/^I see a link to the PDF help file$/) do
  within ".help-file" do
    help_link = page.find_link(t("admin.help.show.help_file"))
    expect(help_link[:href]).to include FileFixture.help_document_name
  end
end

Given(/^there are documents$/) do
  MyLibraryFixture.create_documents
end

When(/^I upload a help file$/) do
  within ".global-option" do
    click_on(t("admin.settings.show.uploads_btn"))
  end

  within ".section-data" do
    find("[data-action='edit']").click
  end

  help_document_full_path = FileFixture.file_path + FileFixture.help_document_name
  within ".help-file" do
    attach_file(:setting_help,
                File.absolute_path(help_document_full_path),
                visible: false)
  end

  within ".form-actions-footer" do
    click_on t("admin.settings.edit.submit")
  end
end

Then(/^I see the help file has been uploaded$/) do
  click_on t("admin.settings.show.uploads")
  find(".help")

  within ".help" do
    expect(page).to have_content FileFixture.help_document_name
  end
end
