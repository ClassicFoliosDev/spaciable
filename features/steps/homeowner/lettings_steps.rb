Given(/^I have no letable plots$/) do
  plot = Plot.find_by(number: HomeownerUserFixture.plot_number)
  plot.update_attributes(letable: false)
end

Then(/^I cannot see the lettings link$/) do
  visit "/"
  within ".full-menu" do
    expect(page).to_not have_content(t("components.homeowner.welcome.lettings"))
  end
end

Given(/^I have letable and unletable plots$/) do
  LettingsFixture.create_unletable_plot
end

When(/^I navigate to the lettings page$/) do
  within ".full-menu" do
    click_on t("components.homeowner.welcome.lettings")
  end
end

Then(/^I can see my letable plot$/) do
  within ".letable" do
    expect(page).to have_content("Plot #{HomeownerUserFixture.plot_number}")
  end

  within ".unlet-plot" do
    expect(page).to have_content("Plot #{HomeownerUserFixture.plot_number}")
    expect(page).to have_content t("homeowners.components.lettings.managing")
    expect(page).to have_content t("homeowners.components.lettings.self_manage")
  end
end

Then(/^I cannot see my unletable plot$/) do
  within ".letable" do
    expect(page).to_not have_content("Plot #{LettingsFixture.plot_number}")
  end
end

Given(/^one of my plots is let$/) do
  plot = Plot.find_by(number: HomeownerUserFixture.plot_number)
  plot.update_attributes(let: true)
end

Then(/^I can see that it is let$/) do
  within ".full-menu" do
    click_on t("components.homeowner.welcome.lettings")
  end

  within ".let-plot" do
    expect(page).to have_content("Plot #{HomeownerUserFixture.plot_number}")
    expect(page).to have_content t("homeowners.components.lettings.let_out")
    expect(page).to have_content t("homeowners.components.lettings.dashboard")
  end
end
