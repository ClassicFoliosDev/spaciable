# frozen_string_literal: true

Given(/^I am a CF admin and there are many releasable plots$/) do
  ResidentNotificationsFixture.create_permission_resources
  login_as CreateFixture.create_cf_admin
  FactoryGirl.create(:unit_type, name: "Another", development: CreateFixture.development)

  FactoryGirl.create(:plot, phase: CreateFixture.phase, number: 180, road_name: "Bulk Edit Road A", prefix: "Apartment", postcode: "AA 1AB")
  FactoryGirl.create(:plot, phase: CreateFixture.phase, number: 185, road_name: "Bulk Edit Road B", prefix: "Flat")
  FactoryGirl.create(:plot, phase: CreateFixture.phase, number: 186, road_name: "Bulk Edit Road A", prefix: "Apartment", postcode: "AA 1AB")
  FactoryGirl.create(:plot, phase: CreateFixture.phase, number: 187, road_name: "Bulk Edit Road B", prefix: "Flat")
  FactoryGirl.create(:plot, phase: CreateFixture.phase, number: 'A1', road_name: "Bulk Edit Road A", prefix: "Apartment", postcode: "AA 1AB")
  FactoryGirl.create(:plot, phase: CreateFixture.phase, number: 'A3', road_name: "Bulk Edit Road B", prefix: "Flat")
  FactoryGirl.create(:plot, phase: CreateFixture.phase, number: 'A4', road_name: "Bulk Edit Road A", prefix: "Apartment", postcode: "AA 1AB")
  FactoryGirl.create(:plot, phase: CreateFixture.phase, number: 'A8', road_name: "Bulk Edit Road B", prefix: "Flat")
  FactoryGirl.create(:plot, phase: CreateFixture.phase, number: 'C1', road_name: "Bulk Edit Road A", prefix: "Apartment", postcode: "AA 1AB")
  FactoryGirl.create(:plot, phase: CreateFixture.phase, number: 'D 102', road_name: "Bulk Edit Road B", prefix: "Flat")
  FactoryGirl.create(:plot, unit_type: CreateFixture.unit_type, phase: CreateFixture.phase, number: 188, road_name: "Bulk Edit Road C", prefix: "Flat", house_number: "18A", postcode: "AA 1AB")
end

Then(/^I add some released plots$/) do
  FactoryGirl.create(:plot, phase: CreateFixture.phase, number: 181, road_name: "Bulk Edit Road A", prefix: "Apartment", postcode: "AA 1AB", reservation_release_date: '2019/2/2')
  FactoryGirl.create(:plot, phase: CreateFixture.phase, number: 'A2', road_name: "Bulk Edit Road A", prefix: "Apartment", postcode: "AA 1AB", reservation_release_date: '2019/3/2')
end

Then(/^I add some completed plots$/) do
  FactoryGirl.create(:plot, phase: CreateFixture.phase, number: 182, road_name: "Bulk Edit Road A", prefix: "Apartment", postcode: "AA 1AB", completion_release_date: '2019/2/2')
  FactoryGirl.create(:plot, phase: CreateFixture.phase, number: 'A 5', road_name: "Bulk Edit Road A", prefix: "Apartment", postcode: "AA 1AB", completion_release_date: '2019/3/2')
end

When(/^I visit the release plots page$/) do
  phase = CreateFixture.phase
  visit "/developments/#{phase.development.id}/phases/#{phase.id}"

  within ".tabs" do
    click_on t("phases.collection.release_plots")
  end
end

When(/^I submit with no parameters$/) do
  within ".form-actions-footer" do
    click_on "Submit"
  end
end

Then(/^there is a message to telling me to populate the data$/) do
  within ".alert" do
    expect(page).to have_content 'Please populate plots and date'
  end
end

When(/^I add all plots and set a reservation release date$/) do
  page.evaluate_script 'window.location.reload()'

  sleep 2

  within ".bulk-edit" do
    click_on "Add All Plots"
    fill_in :phase_release_plots_release_date, with: (Time.zone.today - 10.days)
  end

  within ".form-actions-footer" do
    click_on "Submit"
  end
end

When(/^I press Submit/) do
  within ".form-actions-footer" do
    click_on "Submit"
  end
end

Then(/^there is a message telling me the released pots$/) do
  sleep 0.5
  within ".alert" do
    expect(page).to have_content 'Plots 181,A2 already have a reservation release date'
  end
end

When(/^I set a completion date$/) do
  within ".bulk-edit" do
    select "Completion", :from => :release_type, visible: false
    fill_in :phase_release_plots_release_date, with: (Time.zone.today - 10.days)
  end
end

Then(/^there is a message telling me the completed pots$/) do
  sleep 0.5
  within ".alert" do
    expect(page).to have_content 'Plots 182,A 5 already have a completion release date'
  end
end

When(/^I enter a range of non-existent plots$/) do
  phase = CreateFixture.phase

  within ".bulk-edit" do
   fill_in :phase_release_plots_mixed_list, with: "187, D1,D2"
  end
end

Then(/^there is a message telling me the plots dont match this phase$/) do
  within ".alert" do
    expect(page).to have_content 'Plot(s) D1,D2 do not match plots on this phase. Please review and update list or range of plots.'
  end
end

When(/^I enter a range of existent plots$/) do
  phase = CreateFixture.phase

  within ".bulk-edit" do
   fill_in :phase_release_plots_mixed_list, with: "185~187"
  end
end

Then(/^I get a completion confirmation dialog$/) do
  within(:xpath, '//div[@id="dialog"]') do
    now = (Time.zone.today - 10.days).strftime("%d/%m/%y")
    expect(page).to have_content "Are you sure you want to send the completion email and update release date to #{now}"
    expect(page).to have_content "Number of plots: 3"
  end
end

When(/^I cancel the dialog/) do
  click_on "Cancel"
end

Then(/^the dialog disappears and the release plot page remains populated/) do
  expect(page).to have_no_css('.feedback-dialog')
  expect(find_field(:phase_release_plots_mixed_list).value).to eq '185~187'
end

Then(/^there is a warning that some plots are already have reservation release dates$/) do
  message = I18n.t("activerecord.errors.models.plot.attributes.base.missing")
  within ".alert" do
    expect(page).to have_content 'Please populate fields'
  end
end

When(/^I set a reservation date and extended period/) do
  within ".bulk-edit" do
    select "Reservation", :from => :release_type, visible: false
    fill_in :phase_release_plots_extended_access, with: "24"
  end
end

Then(/^I get a reservation confirmation dialog$/) do
  within(:xpath, '//div[@id="dialog"]') do
    date = (Time.zone.today - 10.days).strftime("%d/%m/%y")
    expect(page).to have_content "Are you sure you want to send the reservation email and update release date to #{date}"
    expect(page).to have_content "Number of plots: 3"
    expect(page).to have_content "Extended: 24"
  end
end

When(/^I confirm the dialog$/) do
  click_on "Confirm"
end

Then(/^I am returned to the phases page with a confirmation message$/) do
  within ".notice" do
    expect(page).to have_content 'Successfully updated plots 185, 186, and 187'
  end
  expect(page).to have_current_path "/developments/#{CreateFixture.development.id}/phases/#{CreateFixture.phase.id}"
end

Then(/^the plot release data has been updated$/) do
  (185..187).each do |number|
    plot = Plot.find_by(number: number)
    expect plot.extended_access == 24 && plot.validity == 27 && plot.reservation_release_date.to_s == '2019-03-18'
  end
end

Then(/^the plot completion data has been updated$/) do
  (185..187).each do |number| 
    plot = Plot.find_by(number: number)
    expect plot.validity == 27 && plot.completion_release_date.to_s == '2019-03-18'
  end
end

When(/^I enter an existent plot and a date beyond today$/) do
  within ".bulk-edit" do
   fill_in :phase_release_plots_mixed_list, with: "D 102"
   fill_in :phase_release_plots_release_date, with: (Time.zone.today + 10.days)
  end
end

When(/^I set the date to today and a validity value$/) do
  within ".bulk-edit" do
    fill_in :phase_release_plots_validity, with: "12"
    fill_in :phase_release_plots_release_date, with: (Time.zone.today)
  end
end

Then(/^there is a message to telling me the date is incorrect$/) do
  within ".alert" do
    expect(page).to have_content 'Date must be before or equal to today'
  end
end

Then(/^I get a reservation and validity confirmation dialog$/) do
  within(:xpath, '//div[@id="dialog"]') do
    date = (Time.zone.today).strftime("%d/%m/%y")
    expect(page).to have_content "Are you sure you want to send the reservation email and update release date to #{date}"
    expect(page).to have_content "Number of plots: 1"
    expect(page).to have_content "Validity: 12"
  end
end

Then(/^I am returned to the phases page$/) do
  expect(page).to have_current_path "/developments/#{CreateFixture.development.id}/phases/#{CreateFixture.phase.id}"
end

Then(/^I am returned to the release plots page$/) do
  expect(page).to have_current_path "/phases/#{CreateFixture.phase.id}/release_plots"
end

When(/^I enter Validity and Extended periods/) do
  within ".bulk-edit" do
    fill_in :phase_release_plots_validity, with: "14"
    fill_in :phase_release_plots_extended_access, with: "24"
  end
end

When(/^I get a reservation, validity and extended confirmation dialog$/) do
  within(:xpath, '//div[@id="dialog"]') do
    date = (Time.zone.today).strftime("%d/%m/%y")
    expect(page).to have_content "Are you sure you want to send the reservation email and update release date to #{date}"
    expect(page).to have_content "Number of plots: 1"
    expect(page).to have_content "Validity: 14"
    expect(page).to have_content "Extended: 24"
  end
end

Then(/^I am returned to the phases page with a single plot confirmation message$/) do
  within ".notice" do
    expect(page).to have_content 'Successfully updated plot D 102'
  end
  expect(page).to have_current_path "/developments/#{CreateFixture.development.id}/phases/#{CreateFixture.phase.id}"
end

Then(/^the plot validity and extended data has been updated$/) do
  plot = Plot.find_by(number: 'D 102')
  unless  plot.validity == 14 && plot.extended_access == 24
    raise "Plot #{plot.number} not updated"
  end
end

