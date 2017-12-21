# frozen_string_literal: true

Given(/^I am a Development Admin wanting to assign a new resident to a plot$/) do
  PlotResidencyFixture.setup

  login_as PlotResidencyFixture.create_development_admin
  visit "/"
end

# First resident, with original_email
When(/^I assign a new resident to a plot$/) do
  plot = CreateFixture.phase_plot
  visit "/plots/#{plot.id}?active_tab=residents"

  within ".plot" do
    click_on t("residents.collection.add")
  end

  within ".new_resident" do
    fill_in_resident_details(PlotResidencyFixture.attrs)
  end
end

Then(/^I should see the (created|updated) plot residency$/) do |action|
  attrs = PlotResidencyFixture.attrs(action)

  within ".residents" do
    expect(page).to have_content(attrs[:first_name])
    expect(page).to have_content(attrs[:last_name])
    expect(page).to have_content(attrs[:email])
  end

  recipient_email = ActionMailer::Base.deliveries.last

  message = t("devise.mailer.invitation_instructions.someone_invited_you", developer: PlotResidencyFixture.plot.developer)
  expect(recipient_email.parts.first.body.raw_source).to include message
  expect(recipient_email.parts.second.body.raw_source).to include "assets/logo-"

  resident = Resident.find_by(email: PlotResidencyFixture.original_email)

  if resident&.invitation_accepted_at.nil?
    expect(recipient_email.subject).to eq t("last_reminder_title", ordinal: "Third")
  elsif resident
    expect(recipient_email.subject).to eq t("new_plot_title")
  end
end

When(/^I update the plot residency$/) do
  within ".residents" do
    find("[data-action='edit']").click
  end

  attrs = PlotResidencyFixture.attrs(:updated)

  within ".edit_resident" do
    fill_in_resident_details(attrs)
  end
end

When(/^I delete a plot residency$/) do
  resident = Resident.find_by(email: PlotResidencyFixture.second_email)
  plot_resident = PlotResidency.find_by(resident_id: resident.id)

  delete_scope = "[data-plot-resident='#{plot_resident.id}']"
  delete_and_confirm!(scope: delete_scope)
end

Then(/^I should not see the plot residency$/) do
  attrs = PlotResidencyFixture.attrs(:updated)
  second_attrs = PlotResidencyFixture.second_attrs

  within ".residents" do
    expect(page).not_to have_content("#{second_attrs[:first_name]} #{second_attrs[:last_name]}")
    expect(page).not_to have_content(second_attrs[:email])

    expect(page).to have_content("#{attrs[:first_name]} #{attrs[:last_name]}")
    expect(page).to have_content(attrs[:email])
  end
end

# A different resident with second_email, added to the original plot
When(/^I create another plot resident$/) do
  within ".section-actions" do
    click_on t("residents.collection.add")
  end

  within ".new_resident" do
    fill_in_resident_details(PlotResidencyFixture.second_attrs)
  end
end

Then(/^I should see two residents for the plot$/) do
  within ".residents" do
    expect(page).to have_content PlotResidencyFixture.second_email
    expect(page).to have_content PlotResidencyFixture.updated_email
  end
end

When(/^The resident subscribes to emails$/) do
  resident = Resident.find_by(email: PlotResidencyFixture.original_email)

  resident.invitation_accepted_at = Time.zone.now
  resident.hoozzi_email_updates = 1
  resident.developer_email_updates = 1
  resident.save!
end

Then(/^the resident should no longer receive notifications$/) do
  resident = Resident.find_by(email: PlotResidencyFixture.second_email)

  expect(resident.plots.length).to be_zero

  expect(resident.developer_email_updates).to be_zero
  expect(resident.hoozzi_email_updates).to be_zero
  expect(resident.telephone_updates).to be_zero
  expect(resident.post_updates).to be_zero
end

When(/^I assign the same resident to the second plot$/) do
  second_plot = Plot.find_by(number: PhasePlotFixture.another_plot_number)

  visit "/plots/#{second_plot.id}?active_tab=residents"

  within ".plot" do
    click_on t("residents.collection.add")
  end

  within ".new_resident" do
    fill_in_resident_details(PlotResidencyFixture.attrs)
  end
end

When(/^I delete the second plot residency$/) do
  resident = Resident.find_by(email: PlotResidencyFixture.original_email)

  delete_scope = "[data-plot-resident='#{resident.id}']"
  delete_and_confirm!(scope: delete_scope)
end

Then(/^the resident should still be associated to the first plot$/) do
  attrs = PlotResidencyFixture.attrs

  expect(page).not_to have_content(".residents")

  first_plot = Plot.find_by(number: CreateFixture.phase_plot_name)
  visit "/plots/#{first_plot.id}?active_tab=residents"

  within ".residents" do
    expect(page).to have_content("#{attrs[:first_name]} #{attrs[:last_name]}")
    expect(page).to have_content(attrs[:email])
  end
end

Then(/^the resident should still receive notifications$/) do
  resident = Resident.find_by(email: PlotResidencyFixture.original_email)

  expect(resident.plots.length).to eq 1

  expect(resident.developer_email_updates).to eq 1
  expect(resident.hoozzi_email_updates).to eq 1
  expect(resident.telephone_updates).to be_nil
  expect(resident.post_updates).to be_nil
end

Given(/^there is a plot in another phase$/) do
  unit_type = FactoryGirl.create(:unit_type)
  phase = FactoryGirl.create(:phase, development: CreateFixture.development)
  FactoryGirl.create(:plot, unit_type: unit_type, phase: phase, number: PhasePlotFixture.another_plot_number)
end

def fill_in_resident_details(attrs)
  select_from_selectmenu :resident_title, with: attrs[:title]
  fill_in :resident_first_name, with: attrs[:first_name]
  fill_in :resident_last_name, with: attrs[:last_name]
  fill_in :resident_email, with: attrs[:email]
  fill_in :resident_phone_number, with: attrs[:phone]

  click_on t("residents.form.submit")
end

Then(/^I should see a duplicate resident notice$/) do
  plot = Plot.find_by(number: CreateFixture.phase_plot_name)

  within ".notice" do
    expect(page).to have_content t("residents.create.plot_residency_already_exists",
                                   email: PlotResidencyFixture.original_email,
                                   plot: plot)
  end
end

When(/^I view the phase$/) do
  phase = Phase.find_by(name: CreateFixture.phase_name)
  visit "/developments/#{phase.development.id}/phases/#{phase.id}"
end

Then(/^I should see no activated residents$/) do
  within ".plots" do
    expect(page).to have_content "0 of 2"
  end
end

Then(/^I should see one activated resident$/) do
  within ".plots" do
    expect(page).to have_content "1 of 1"
  end
end

When(/^I view the plot$/) do
  plot = Plot.find_by(number: CreateFixture.phase_plot_name)
  visit "/plots/#{plot.id}?active_tab=residents"
end

Then(/^I should see the activated resident$/) do
  within ".residents" do
    expect(page).to have_content t("residents.collection.activated")
  end
end

Then(/^I should see the resident is not activated$/) do
  within ".residents" do
    expect(page).not_to have_content t("residents.collection.activated")
  end
end
