# frozen_string_literal: true

When(/^I visit the contacts page$/) do
  visit "/"

  within ".contacts-component" do
    click_on(t("homeowners.dashboard.contacts.contacts_view_more"))
  end
end

Then(/^I should see the contacts for my plot$/) do
  # There are no contacts in the sales category. Created one contact in the Customer Care category
  within ".full-contacts" do
    contacts = page.all(".contact")
    expect(contacts.count).to eq(1)
  end

  within ".sub-navigation-container" do
    click_on(t("activerecord.attributes.contact.categories.management"))
  end

  find(:xpath,"//a[@class='active']/li[contains(text(),'Management')]")

  # Created two contacts in Management category
  within ".full-contacts" do
    contacts = page.all(".contact")
    expect(contacts.count).to eq(2)
  end

  within ".sub-navigation-container" do
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

Then(/^the pinned contact should display first$/) do
  within ".sub-navigation-container" do
    click_on(t("activerecord.attributes.contact.categories.management"))
  end
  sleep 0.5
  within ".full-contacts" do
    contact = page.first(".contact")
    expect(contact).to have_content(ContactFixture.second_email)
  end
end

Then(/^the pinned contact should list first$/) do
  within ".contact-list" do
    contact = page.first(".contact")
    expect(contact).to have_content(ContactFixture.second_email)
  end
end
