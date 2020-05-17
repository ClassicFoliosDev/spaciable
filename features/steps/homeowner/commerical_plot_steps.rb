Given(/^my plot has been marked as commercial$/) do
  development = Development.first
  development.construction = "commercial"
  development.construction_name = PlotFixture.commercial_name
  development.save!
  visit "/dashboard"
end

Then(/^I should not see any reference to my home on the dashboard$/) do
  expect(page).to_not have_content(t("construction_type.home"))
end

Then(/^I should see references to my commercial name$/) do
  within ".my-home" do
    # 'My Home.' title
    expect(page).to have_content(t("homeowners.dashboard.show.my_title",
                                   construction: "My #{PlotFixture.commercial_name}"))
    # 'View My Home' button
    expect(page).to have_content(t("homeowners.components.address.view_more",
                                   construction: "My #{PlotFixture.commercial_name}"))
  end

  within ".burger-navigation" do
    check_box = find(".burger")
    check_box.trigger(:click)
  end

  within ".navbar-menu" do
    # 'Home Designer' navigation
    expect(page).to have_content(t("layouts.homeowner.nav.home_designer",
                                   construction: PlotFixture.commercial_name))
  end
end

When(/^I navigate to my documents$/) do
  library = find(:xpath, "//a[contains(text(),'#{t("homeowner.dashboard.cards.library.view_more")}')]")
  library.click()
end

Then(/^I do not see the category my home$/) do
  within ".library-categories" do
    expect(page).to_not have_content(t("construction_type.home"))
  end
end

Then(/^I see a category named after my commercial name$/) do
  within ".library-categories" do
    expect(page).to have_content(t("homeowners.library.my_home", construction: PlotFixture.commercial_name))
  end
end
