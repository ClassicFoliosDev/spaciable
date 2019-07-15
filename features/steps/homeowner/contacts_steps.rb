# frozen_string_literal: true

When(/^I visit the contacts page$/) do
  visit "/"

  within ".navbar-menu" do
    click_on t("layouts.homeowner.nav.contacts")
  end
end

Then(/^I should see the contacts for my plot$/) do
  # There are no contacts in the sales category. Created one contact in the Customer Care category
  within ".full-contacts" do
    contacts = page.all(".contact")
    expect(contacts.count).to eq(1)
  end

  within ".hero-links" do
    click_on(t("activerecord.attributes.contact.categories.management"))
  end

  sleep 0.3
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

And(/^I should see contacts on the dashboard$/) do
  visit "/"

  within ".contact-list" do
    contacts = page.all(".contact")
    expect(contacts.count).to eq(3)
  end
end
