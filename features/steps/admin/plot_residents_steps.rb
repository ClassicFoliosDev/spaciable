# frozen_string_literal: true
Given(/^I am a Development Admin wanting to assign a new resident to a plot$/) do
  PlotResidencyFixture.setup

  login_as PlotResidencyFixture.create_development_admin
  visit "/"
end

When(/^I assign a new resident to a plot$/) do
  attrs = PlotResidencyFixture.attrs

  goto_development_show_page
  click_on t("developments.collection.plots")
  within ".record-list" do
    click_on PlotResidencyFixture.plot
  end

  click_on t("plots.collection.plot_residency")
  click_on t("plot_residencies.collection.add")

  select_from_selectmenu :plot_residency_title, with: attrs[:title]
  fill_in :plot_residency_first_name, with: attrs[:first_name]
  fill_in :plot_residency_last_name, with: attrs[:last_name]
  fill_in :plot_residency_email, with: attrs[:email]
  fill_in :plot_residency_phone_number, with: attrs[:phone]
  fill_in :plot_residency_completion_date, with: attrs[:completion_date]

  click_on t("plot_residencies.form.submit")
end

Then(/^I should see the (created|updated) plot residency$/) do |action|
  attrs = PlotResidencyFixture.attrs(action)

  expect(page).not_to have_selector("[data-action='new']")

  expect(page).to have_content(attrs[:first_name])
  expect(page).to have_content(attrs[:last_name])
  expect(page).to have_content(attrs[:email])

  within ".record-list" do
    click_on attrs.values_at(:first_name, :last_name).join(" ")
  end

  expect(page).to have_content(attrs[:completion_date])

  click_on t("plot_residencies.show.back")
end

When(/^I update the plot resident's email$/) do
  within ".record-list" do
    find("[data-action='edit']").click
  end

  fill_in :plot_residency_email, with: PlotResidencyFixture.updated_email

  click_on t("plot_residencies.form.submit")
end

Then(/^I should see an error$/) do
  expect(page).to have_content(t("activerecord.errors.models.plot_residency.attributes.email.change_email"))
end

When(/^I update the plot residency$/) do
  attrs = PlotResidencyFixture.attrs(:updated)

  select_from_selectmenu :plot_residency_title, with: attrs[:title]
  fill_in :plot_residency_first_name, with: attrs[:first_name]
  fill_in :plot_residency_last_name, with: attrs[:last_name]
  fill_in :plot_residency_email, with: attrs[:email]
  fill_in :plot_residency_phone_number, with: attrs[:phone]
  fill_in :plot_residency_completion_date, with: attrs[:completion_date]

  click_on t("plot_residencies.form.submit")
end

When(/^I delete a plot residency$/) do
  delete_and_confirm!(scope: ".record-list")
end

Then(/^I should not see the plot residency$/) do
  attrs = PlotResidencyFixture.attrs(:updated)

  expect(page).not_to have_content("#{attrs[:first_name]} #{attrs[:last_name]}")
  expect(page).not_to have_content(attrs[:email])

  expect(page).not_to have_content(".record-list")

  within ".empty" do
    expect(page).to have_content t("components.empty_list.add", type_name: PlotResidency.model_name.human.downcase)
  end
end
