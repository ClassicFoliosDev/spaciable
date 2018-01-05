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
    plot = resident.plots.first
    expect(page).to have_content plot.developer
    expect(page).to have_content plot.division
    expect(page).to have_content plot.development
    expect(page).to have_content plot.unit_type
  end
end

