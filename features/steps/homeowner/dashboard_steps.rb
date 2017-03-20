# frozen_string_literal: true
Then(/^I see the recent homeowner contents$/) do
  within ".my-home" do
    expect(page).to have_content(t("homeowners.dashboard.show.my_home_title"))
  end

  within ".faq-list" do
    faqs = page.all("li")
    expect(faqs.count).to eq(1)
  end

  within ".my-library" do
    expect(page).to have_content("Document")
  end

  within ".contacts-component" do
    contacts = page.all(".contact")
    expect(contacts.count).to eq(3)
  end

  howtos = page.all(".how-to")
  expect(howtos.count).to eq(5)
  expect(howtos[0]).to have_content("Changing Home Checklist")
  expect(howtos[4]).to have_content("Counter New Home Cracks")
end
