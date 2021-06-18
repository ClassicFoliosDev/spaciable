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
  page.find("#dropdownMenu").click
  within ".links-list" do
    click_on t("components.homeowner.header.plots")
  end

  within ".plots" do
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
  page.find("#dropdownMenu").click
  within ".links-list" do
    click_on t("components.homeowner.header.plots")
  end
end

When(/^I switch to the second plot$/) do
  second_plot = Plot.find_by(number: PlotFixture.another_plot_number)

  stub_request(:get, "#{ENV['VABOO_APP_URL']}/api/v4/users/#{ENV['VABOO_ACCOUNT']}/#{ENV['VABOO_ACCESS']}?Email=#{RequestStore.store[:current_user].email}").
  with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
  to_return(status: 200, body: "", headers: {"Content-Type"=> "application/json"})

  stub_request(:get, "#{ENV['VABOO_APP_URL']}/api/v4/users/#{ENV['VABOO_ACCOUNT']}/#{ENV['VABOO_ACCESS']}?Email=#{RequestStore.store[:current_user].email}").
  with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
  to_return(status: 200, body: "", headers: {"Content-Type"=> "application/json"})

  within ".plots" do
    find(:xpath, "//a[@href='/homeowners/change_plot?id=#{second_plot.id}']").click
  end

  within ".my-home-address" do
    expect(page).to have_content second_plot.to_homeowner_s
  end
end
