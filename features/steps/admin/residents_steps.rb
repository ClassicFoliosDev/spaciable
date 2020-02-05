# frozen_string_literal: true
When(/^I navigate to the residents view$/) do
  visit "/admin/residents"
end

Then(/^I see a list of residents$/) do
  within ".record-list" do
    expect(page).to have_content CreateFixture.resident_email
  end
end
