# frozen_string_literal: true

Given(/^there are admins$/) do
  CreateFixture.create_developer_admin
  CreateFixture.create_development_admin
end

Then(/^I should see most of the children have been removed from the database$/) do
  # Most children should be removed

  sleep 0.7
  expect(Developer.count).to eq(0)
  expect(Development.count).to eq(0)

  expect(Plot.count).to eq(0)
  expect(UnitType.count).to eq(0)

  expect(Room.count).to eq(0)
  expect(Contact.count).to eq(0)

  expect(Faq.count).to eq(0)

  # The Developer and Development admins should have been deleted,
  # with only the CF Admin remaining
  expect(User.count).to eq(1)

  # Finishes and appliances and how_tos should not be removed
  expect(Finish.count).to eq(1)
  expect(Appliance.count).to eq(1)
  expect(HowTo.count).to eq(4)
end
