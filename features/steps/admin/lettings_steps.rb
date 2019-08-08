When(/^I create a phase for the division development$/) do
  within ".tabs" do
    click_on t("developments.collection.phases")
  end

  within ".empty" do
    click_on t("phases.collection.add")
  end

  within ".row" do
    fill_in "phase_name", with: CreateFixture.phase_name
  end

  within ".form-actions-footer" do
    click_on t("phases.form.submit")
  end

  within ".record-list" do
    click_on CreateFixture.phase_name
  end
end

Then(/^lettings is enabled by default$/) do
  within ".section-title" do
    expect(page).to have_content("#{t("phases.phase.lettings")}true")
  end
end

Given(/^there is a unit type for the development$/) do
  CreateFixture.create_division_development_unit_type
end


When(/^I create a plot under the phase$/) do
  within ".section-actions" do
    click_on t("plots.collection.add")
  end

  within ".plot_unit_type" do
    select CreateFixture.unit_type_name, visible: false
  end

  fill_in "plot_list", with: PhasePlotFixture.plot_number
  click_on t("plots.form.submit")

  within ".record-list" do
    click_on "Plot #{PhasePlotFixture.plot_number}"
  end
end

Then(/^the plot is letable$/) do
  within ".section-title" do
    expect(page).to have_content("#{t("plots.plot.letable")}true")
  end
end

When(/^I edit the phase to be unletable$/) do
  within ".breadcrumbs" do
    click_on CreateFixture.phase_name
  end

  sleep 0.3

  within ".section-data" do
    find("[data-action='edit']").click
  end

  uncheck "phase_lettings"

  within ".form-actions-footer" do
    click_on t("phases.form.submit")
  end

  within ".record-list" do
    click_on CreateFixture.phase_name
  end
end

Then(/^the phase is unletable$/) do
  within ".section-title" do
    expect(page).to have_content("#{t("phases.phase.lettings")}false")
  end
end

Then(/^the plot becomes unletable$/) do
  within ".record-list" do
    click_on "Plot #{PhasePlotFixture.plot_number}"
  end

  within ".section-title" do
    expect(page).to have_content("#{t("phases.phase.lettings")}false")
  end
end

Then(/^I can update the plot to be letable$/) do
  sleep 0.3

  within ".section-data" do
    find("[data-action='edit']").click
  end

  check "plot_letable"

  within ".form-actions-footer" do
    click_on t("plots.form.submit")
  end
end

When(/^I create an unletable phase for the division development$/) do
  within ".tabs" do
    click_on t("developments.collection.phases")
  end

  within ".empty" do
    click_on t("phases.collection.add")
  end

  within ".row" do
    fill_in "phase_name", with: CreateFixture.phase_name
    uncheck "phase_lettings"
  end

  within ".form-actions-footer" do
    click_on t("phases.form.submit")
  end

  within ".record-list" do
    click_on CreateFixture.phase_name
  end
end

Then(/^lettings is disabled$/) do
  within ".section-title" do
    expect(page).to have_content("#{t("phases.phase.lettings")}false")
  end
end

Then(/^the plot is unletable$/) do
  within ".section-title" do
    expect(page).to have_content("#{t("plots.plot.letable")}false")
  end
end