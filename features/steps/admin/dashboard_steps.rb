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
  end
end
