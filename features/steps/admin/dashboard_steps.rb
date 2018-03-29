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
    expect(page).to have_content(t("activerecord.attributes.faq.categories.settling"))
  end

  within ".documents" do
    expect(page).to have_content(t("activerecord.attributes.document.categories.legal_and_warranty"))
    expect(page).to have_content(t(".manual"))
    expect(page).to have_content(t(".guide"))
  end
end

When(/^I navigate to the Hoozzi help page$/) do
  visit "/"
  click_on t("components.navigation.help")
end

Then(/^I see a link to the PDF help file$/) do
  within ".help-file" do
    help_link = page.find_link(t("admin.help.show.help_file"))
    expect(help_link[:href]).to include("HoozziAdminInterfaceUserGuide")
  end
end

Given(/^there are documents$/) do
  MyLibraryFixture.create_documents
end
