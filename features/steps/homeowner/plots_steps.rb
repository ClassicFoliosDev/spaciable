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
  within ".session-inner" do
    plot_list_button = page.find(".my-plots")
    plot_list_button.trigger(:click)
  end

  within ".plot-list" do
    plots = page.all(".plot-summary")
    expect(plots.count).to eq 5

    expect(page).to have_content HomeownerUserFixture.development_name
    expect(page).to have_content HomeownerUserFixture.developer_name
    # Summary does not show division name, even if there is a division
    expect(page).not_to have_content HomeownerUserFixture.division_name
  end
end

Given(/^there is a second plot$/) do
  second_plot = FactoryGirl.create(:plot, development: CreateFixture.division_development, prefix: "", number: "222")
  FactoryGirl.create(:plot_residency, plot_id: second_plot.id, resident_id: CreateFixture.resident.id)
end

When(/^I show the plots$/) do
  within ".session-inner" do
    plot_list_button = page.find(".my-plots")
    plot_list_button.trigger(:click)
  end
end

When(/^I switch to the second plot$/) do
  within ".plot-list" do
    plot_link = page.find_link("222")
    plot_link.trigger(:click)
  end
end
