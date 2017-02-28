# frozen_string_literal: true

When(/^I visit the contacts page$/) do
  visit "/"

  within ".navbar-menu" do
    click_on t("layouts.homeowner.nav.contacts")
  end
end

Then(/^I should see the contacts for my plot$/) do
  # Didn't create any contacts in Sales category, so there will be no contacts to see
  within ".full-contacts" do
    expect(page).not_to have_content(".contact")
  end

  within ".hero-links" do
    click_on(t("activerecord.attributes.contact.categories.management"))
  end

  # Created two contacts in Management category
  within ".full-contacts" do
    contacts = page.all(".contact")
    expect(contacts.count).to eq(2)
  end

  within ".hero-links" do
    click_on(t("activerecord.attributes.contact.categories.customer_care"))
  end

  # Created one contact in Management category
  within ".full-contacts" do
    page.find(".contact")
  end
end
