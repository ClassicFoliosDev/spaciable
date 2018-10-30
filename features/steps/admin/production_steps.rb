# frozen_string_literal: true

Given(/^there is another plot with completion and reservation release dates$/) do
  unit_type = FactoryGirl.create(:unit_type)
  FactoryGirl.create(:plot,
                     unit_type: unit_type,
                     phase: CreateFixture.phase,
                     number: PlotFixture.another_plot_number,
                     reservation_release_date: Time.zone.now.to_date,
                     completion_release_date: (Time.zone.now.to_date + 14.days),
                     road_name: "Plot road",
                     building_name: "Plot building",
                     postcode: "AB1 3ED")
end

When(/^I visit the production tab$/) do
  phase = CreateFixture.phase

  visit "/developers/#{phase.developer.id}/developments/#{phase.development.id}?active_tab=phases"

  within ".phases" do
    click_on I18n.t("phases.collection.production")
  end
end

Then(/^I should see the list of plots with address and release date fields$/) do
  plot1 = CreateFixture.phase_plot
  plot2 = Plot.find_by(number: PlotFixture.another_plot_number)

  within "[data-plot='#{plot1.id}']" do
    expect(page).to have_content plot1
    expect(page).to have_content plot1.house_number
    expect(page).to have_content plot1.road_name
    expect(page).to have_content plot1.building_name
    expect(page).to have_content plot1.postcode
    expect(page).to have_content plot1.unit_type

    unset_dates = page.all(".white")
    expect(unset_dates.length).to eq 2

    set_dates = page.all(".green")
    expect(set_dates.length).to eq 0
  end

  within "[data-plot='#{plot2.id}']" do
    expect(page).to have_content plot2
    expect(page).to have_content plot2.house_number
    expect(page).to have_content plot2.road_name
    expect(page).to have_content plot2.building_name
    expect(page).to have_content plot2.postcode
    expect(page).to have_content plot2.unit_type

    unset_dates = page.all(".white")
    expect(unset_dates.length).to eq 0

    set_dates = page.all(".green")
    expect(set_dates.length).to eq 2
  end
end

Then(/^I should not see the production tab$/) do
  within ".tabs" do
    expect(page).not_to have_content I18n.t("phases.collection.production")
  end
end
