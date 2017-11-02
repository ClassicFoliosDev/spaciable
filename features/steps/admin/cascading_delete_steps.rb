# frozen_string_literal: true

Then(/^I should see most of the children have been removed from the database$/) do
  # Most children should be removed

  sleep 0.4
  expect(Developer.count).to eq(0)
  expect(Development.count).to eq(0)

  expect(Plot.count).to eq(0)
  expect(UnitType.count).to eq(0)

  expect(Room.count).to eq(0)
  expect(Contact.count).to eq(0)

  # Finishes and appliances and how_tos should not be removed
  expect(Finish.count).to eq(1)
  expect(Appliance.count).to eq(1)
  expect(HowTo.count).to eq(3)
end
