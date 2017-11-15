Given(/^I am logged in as a homeowner with populated content$/) do
  MyLibraryFixture.setup

  login_as CreateFixture.resident
  visit "/"
end

When(/^I search for a finish$/) do
  search_for(CreateFixture.finish_name)
end

Then(/^I see the matching finish$/) do
  within ".search-results" do
    expect(page).to have_link("Finish", href: "/homeowners/my_home")
  end
end

When(/^I search for a room$/) do
  search_for(CreateFixture.room_name)
end

Then(/^I see the matching room$/) do
  within ".search-results" do
    expect(page).to have_link("Room", href: "/homeowners/my_home")
  end
end

When(/^I search for a contact$/) do
  search_for(CreateFixture.contact_name)
end

Then(/^I see the matching contact$/) do
  within ".search-results" do
    expect(page).to have_link("Contact", href: "/homeowners/contacts/emergency")
  end
end

When(/^I search for a contact for another division$/) do
  search_for(CreateFixture.division_contact_name)
end

When(/^I search for an FAQ$/) do
  search_for(CreateFixture.faq_name)
end

Then(/^I see the matching FAQ$/) do
  faq = Faq.all.first
  within ".search-results" do
    expect(page).to have_link("Faq", href: "/homeowners/faqs/#{faq.category}")
  end
end

When(/^I search for a notification$/) do
  search_for(CreateFixture.notification_name)
end

Then(/^I see the matching notification$/) do
  within ".search-results" do
    expect(page).to have_link("Notification", href: "/homeowners/notifications")
  end
end

When(/^I search for a how\-to$/) do
  search_for(CreateFixture.how_to_name)
end

Then(/^I see the matching how\-to$/) do
  within ".search-results" do
    expect(page).to have_link("HowTo", href: "/homeowners/how_tos/category/diy")
  end
end

When(/^I search for an appliance$/) do
  search_for(CreateFixture.appliance_name)
end

Then(/^I see the matching appliance$/) do
  within ".search-results" do
    expect(page).to have_link("Appliance", href: "/homeowners/my_appliances")
  end
end

Then(/^I see the matching appliance manual$/) do
  within ".search-results" do
    expect(page).to have_link("Manual", href: "/homeowners/library/appliance_manuals")
  end
end

When(/^I search for a document$/) do
  search_for("Unit")
end

Then(/^I see the matching document$/) do
  within ".search-results" do
    expect(page).to have_link("Document", href: "/homeowners/library/legal_and_warranty")
  end
end

When(/^I search for something that is not matched$/) do
  search_for("Foo")
end

Then(/^I see no matches$/) do
  within ".search-results" do
    expect(page).to have_content I18n.t("admin.search.new.no_match")
  end
end

def search_for(search_term)
  within ".search-container" do
    fill_in :search_search_text, with: search_term
    find(".search-btn").click
  end
end
