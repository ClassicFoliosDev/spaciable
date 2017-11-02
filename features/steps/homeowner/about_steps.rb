# frozen_string_literal: true

When(/^I visit the About page$/) do
  visit "/homeowners/about"
end

Then(/^I should see the about page links$/) do
  within ".branded-body" do
    expect(page).to have_content(t("components.homeowner.sub_menu.rooms"))
    expect(page).to have_content(t("components.homeowner.sub_menu.appliances"))
    expect(page).to have_content(t("components.homeowner.sub_menu.library"))
    expect(page).to have_content(t("components.homeowner.sub_menu.faqs"))
  end
end

When(/^the plot build status is completed$/) do
  plot = Plot.find_by(number: CreateFixture.plot_name)
  plot.update(progress: "completed")
end

Then(/^I should no longer see build status on the about page$/) do
  visit "/homeowners/about"

  within ".branded-body" do
    expect(page).not_to have_content(t("activerecord.attributes.plot.progresses.completed"))
    expect(page).not_to have_content(t("homeowners.about.show.build_progress"))
  end
end
