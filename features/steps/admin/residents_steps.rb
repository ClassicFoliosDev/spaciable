# frozen_string_literal: true
When(/^I navigate to the residents view$/) do
  visit "/admin/residents"
end

Then(/^I see a list of residents$/) do
  within ".record-list" do
    expect(page).to have_content CreateFixture.resident_email
  end
end

Then(/^I can see an invidividual resident$/) do
  resident = CreateFixture.resident

  within ".record-list" do
    click_on resident.to_s
  end

  within ".resident" do
    expect(page).to have_content resident.plot.developer
    expect(page).to have_content resident.plot.division
    expect(page).to have_content resident.plot.development
    expect(page).to have_content resident.plot.unit_type
  end
end
