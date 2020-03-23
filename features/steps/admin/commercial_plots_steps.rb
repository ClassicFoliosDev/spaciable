When(/^I update the development to a commercial development and do not enter a my home replacement$/) do
  find("[data-action='edit']").click

  fill_in "development_name", with: CreateFixture.development_name
  select_from_selectmenu :development_construction, with: t(".activerecord.attributes.development.construction_labels.commercial")

  click_on t("developments.form.submit")
end

Then(/^I should see an error telling me to enter a my home replacement$/) do
  within ".submission-errors" do
    expect(page).to have_content("Construction name#{t("activerecord.errors.messages.blank")}")
  end
end

When(/^I enter a my home replacement$/) do
  fill_in "development_construction_name", with: PlotFixture.commercial_name

  click_on t("developments.form.submit")
end

When(/^I create a phase under the commercial development$/) do
  within ".lower" do
    click_on(t("phases.collection.add"))
  end
end

Then(/^the business is commercial and I cannot change it$/) do
  within ".phase_business" do
    within ".ui-selectmenu-text" do
      expect(page).to have_content(t("activerecord.attributes.phase.businesses.commercial"))
    end
  end
end
