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

  expect(page).to have_content(attrs[:first_name])
  expect(page).to have_content(attrs[:last_name])
  expect(page).to have_content(attrs[:email])

  within ".record-list" do
    click_on attrs.values_at(:first_name, :last_name).join(" ")
  end

  expect(page).to have_content(attrs[:completion_date])

  recipient_email = ActionMailer::Base.deliveries.last

  message = t("devise.mailer.invitation_instructions.someone_invited_you", developer: PlotResidencyFixture.plot.developer)
  expect(recipient_email.parts.first.body.raw_source).to include message

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
  resident = Resident.find_by(email: PlotResidencyFixture.second_email)
  plot_resident = PlotResidency.find_by(resident_id: resident.id)
  delete_scope = "[data-plot-resident='#{plot_resident.id}']"

  delete_and_confirm!(scope: delete_scope)
end

Then(/^I should not see the plot residency$/) do
  attrs = PlotResidencyFixture.attrs(:updated)
  second_attrs = PlotResidencyFixture.second_attrs

  within ".record-list" do
    expect(page).not_to have_content("#{second_attrs[:first_name]} #{second_attrs[:last_name]}")
    expect(page).not_to have_content(second_attrs[:email])

    expect(page).to have_content("#{attrs[:first_name]} #{attrs[:last_name]}")
    expect(page).to have_content(attrs[:email])
  end
end

When(/^I create another plot resident$/) do
  within ".section-actions" do
    click_on t("plot_residencies.collection.add")
  end

  attrs = PlotResidencyFixture.second_attrs

  within ".row" do
    fill_in :plot_residency_first_name, with: attrs[:first_name]
    fill_in :plot_residency_last_name, with: attrs[:last_name]
    fill_in :plot_residency_email, with: attrs[:email]
  end

  click_on t("plot_residencies.form.submit")
end

Then(/^I should see the second plot residency created$/) do
  attrs = PlotResidencyFixture.second_attrs

  within ".record-list" do
    expect(page).to have_content(attrs[:first_name])
    expect(page).to have_content(attrs[:last_name])
    expect(page).to have_content(attrs[:email])
  end
end
