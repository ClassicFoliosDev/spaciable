# frozen_string_literal: true

Given(/^I am logged in as a homeowner with multiple plots$/) do
  HomeownerUserFixture.create
  HomeownerUserFixture.create_more_plot_residencies
end

When(/^I log in as homeowner$/) do
  homeowner = Resident.find_by(email: HomeownerUserFixture.email)
  login_as homeowner
  visit "/"
end

Then(/^I see all the plots I own$/) do
  within ".session-inner .full-menu" do
    plot_list_button = page.find(".my-plots")
    plot_list_button.trigger(:click)
  end

  within ".plot-list" do
    plots = page.all(".plot-summary")
    expect(plots.count).to eq 5
    Plot.all.each do |plot|
      expect(page).to have_content plot.to_homeowner_s
    end

    expect(page).to have_content HomeownerUserFixture.development_name
    expect(page).to have_content HomeownerUserFixture.developer_name
    # Summary does not show division name, even if there is a division
    expect(page).not_to have_content HomeownerUserFixture.division_name
  end
end

Given(/^there is another phase plot$/) do
  second_plot = FactoryGirl.create(:plot, phase: CreateFixture.phase, number: PlotFixture.another_plot_number)

  FactoryGirl.create(:plot_residency, plot_id: second_plot.id, resident_id: CreateFixture.resident.id, role: :homeowner)
end

Given(/^there is another division phase plot$/) do
  new_plot = FactoryGirl.create(:plot, phase: CreateFixture.division_phase, number: PlotFixture.different_plot_number)
  FactoryGirl.create(:plot_residency, plot_id: new_plot.id, resident_id: CreateFixture.resident.id)
end

When(/^I show the plots$/) do
  within ".session-inner .full-menu" do
    plot_list_button = page.find(".my-plots")
    plot_list_button.trigger(:click)

    # Wait for the javascript to trigger
    sleep 0.3

    plot_lists = page.all(".plot-list")
    if plot_lists.count < 1
      plot_list_button = page.find(".my-plots")
      plot_list_button.trigger(:click)
    end
  end
end

When(/^I switch to the second plot$/) do
  second_plot = Plot.find_by(number: PlotFixture.another_plot_number)

  within ".session-inner" do
    plot_link = page.find_link(second_plot.to_homeowner_s)
    plot_link.trigger(:click)
  end

  within ".my-home-address" do
    expect(page).to have_content second_plot.to_homeowner_s
  end
end
