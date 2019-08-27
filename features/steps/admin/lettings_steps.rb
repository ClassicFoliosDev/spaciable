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

Given(/^there is a unit type for the development$/) do
  CreateFixture.create_division_development_unit_type
end

Given(/^there are two plots on the phase$/) do
  phase = Phase.find_by(name: CreateFixture.phase_name)
  FactoryGirl.create(:plot, phase: phase, unit_type: CreateFixture.unit_type, number: "1")
  FactoryGirl.create(:plot, phase: phase, unit_type: CreateFixture.unit_type, number: "2")
end

When(/^I navigate to the lettings tab$/) do
  within ".tabs" do
    click_on t("phases.collection.lettings")
  end
end

When(/^I make one plot admin letable$/) do
  fill_in :phase_bulk_edit_list, with: "1"
  within ".submit" do
    click_on "Submit"
  end
  # The page redirects to the plots tab after submit, so we need to go back to the lettings page
  within ".tabs" do
    click_on t("phases.collection.lettings")
  end
end

Then(/^I can see the plot in the admin lettings list$/) do
  within ".admin-lettings-list" do
    expect(page).to have_content("Plot 1")
    expect(page).to have_content(t("lettings.client_admin_lettings.planet_rent"))
  end
  # Check that the plot is not in the homeowner lettings list
  within ".homeowner-lettings-list" do
    expect(page).to_not have_content("Plot 1")
  end
end

# PLANET RENT API
# The lettings form currently doesn't check whether the plot has already been made letable or not
# We will need to add additional tests for this once the validation checks have been set up
Then(/^when I make one plot homeowner letable$/) do
  choose("lettings_homeowner_checked")
  fill_in :phase_bulk_edit_list, with: "2"
  within ".submit" do
    click_on "Submit"
  end
  # The page redirects to the plots tab after submit, so we need to go back to the lettings page
  within ".tabs" do
    click_on t("phases.collection.lettings")
  end
end

Then(/^I can see the plot in the homeowner lettings list$/) do
  within ".homeowner-lettings-list" do
    expect(page).to have_content("Plot 2")
  end
  # Check that the plot is not in the homeowner lettings list
  within ".admin-lettings-list" do
    expect(page).to_not have_content("Plot 2")
  end
end

Then(/^if I delete the plot from homeowner lettings$/) do
  within ".homeowner-lettings-list" do
    page.find(".remove-letter-btn").click
  end
  within ".ui-dialog" do
    click_on "Confirm"
  end
end

Then(/^the plot is no longer in the homeowner lettings list$/) do
  within ".homeowner-lettings-list" do
    expect(page).to_not have_content("Plot 2")
  end
  within ".notice" do
    expect(page).to have_content(t("plots.update.lettings_success", plot_name: "Plot 2", type: "unlettable"))
  end
end

Then(/^if I swap the admin letting to homeowner lettings$/) do
  within ".admin-lettings-list" do
    page.find(".change-letter-btn").click
  end

  within ".ui-dialog" do
    click_on "Confirm"
  end
end

Then(/^I can see the admin plot in the homeowner lettings list$/) do
  within ".homeowner-lettings-list" do
    expect(page).to have_content("Plot 1")
  end
  within ".notice" do
    expect(page).to have_content(t("plots.update.lettings_success", plot_name: "Plot 1", type: "homeowner"))
  end
end

Given(/^the plot has been let$/) do
  plot = Plot.find_by(number: "1")
  plot.let = true
  plot.save!

  # We need to refresh the page to see this change
  within ".tabs" do
    click_on "Plots"
    click_on t("phases.collection.lettings")
  end
end

Then(/^I can no longer make the plot unlettable$/) do
  within ".homeowner-lettings-list" do
    expect(page).to have_content("Yes")
    expect(page).to have_no_css(".remove-letter-btn")
  end
end

Then(/^I can no longer swap the plot letter type$/) do
  within ".homeowner-lettings-list" do
    expect(page).to have_content("Yes")
    expect(page).to have_no_css(".change-letter-btn")
  end
end

Given(/^the plot has not been let$/) do
  plot = Plot.find_by(number: "1")
  plot.let = false
  plot.save!

  # We need to refresh the page to see this change
  within ".tabs" do
    click_on "Plots"
    click_on t("phases.collection.lettings")
  end
end

# PLANET RENT API
# There is currently no check whether the plot is already let when using the form to make plots unlettable
# We will need to add an additional test for this one the functionality has been set up
Then(/^I can make it unlettable using the form$/) do
  choose("lettings_not_lettable_checked")
  fill_in :phase_bulk_edit_list, with: "1"
  within ".submit" do
    click_on "Submit"
  end
  # The page redirects to the plots tab after submit, so we need to go back to the lettings page
  within ".tabs" do
    click_on t("phases.collection.lettings")
  end

  within ".homeowner-lettings-list" do
    expect(page).to_not have_content("Plot 1")
  end
end

Given(/^the plot is admin lettable$/) do
  plot = Plot.find_by(number: CreateFixture.phase_plot_name)
  plot.letable = true
  plot.letable_type = 'planet_rent'
  plot.letter_type = 'admin'
  plot.save!
end

Given(/^there is a second phase plot$/) do
  FactoryGirl.create(:phase_plot, phase: CreateFixture.phase, number: LettingsFixture.unletable_plot_number, unit_type: CreateFixture.unit_type)
end

Given(/^the plot is homeowner lettable$/) do
  plot = Plot.find_by(number: LettingsFixture.unletable_plot_number)
  plot.letable = true
  plot.letable_type = 'planet_rent'
  plot.letter_type = 'homeowner'
  plot.save!
end

Then(/^I can visit the lettings tab$/) do
  within ".tabs" do
    click_on t("phases.collection.lettings")
  end
end

Then(/^I can set up a managed lettings account$/) do
  within ".management-description" do
    click_on(t("lettings.client_admin_lettings.management_service_select"))
  end

  # Checks that the submit button is disabled if all of the fields have not been populated
  within ".ui-dialog-buttonset" do
    expect(page).to have_css(".ui-state-disabled")
  end
  within ".management-type" do
    expect(page).to have_content("Management Service")
  end
  fill_in :lettings_account_email, with: "lettings@email.com"
  click_on t("lettings.client_admin_lettings.confirm_cta")


  # PLANET RENT API
  # From here we need to alter the tests to test the function of the api.
  # The form needs to be sent to Planet Rent to set up the lettings account
  # For now I have just re-visited the page to continue the testing of the ui.
  # We need some sleeps to wait for the new lettings page content to render
  within ".tabs" do
    click_on "Plots"
    sleep 1
    click_on t("phases.collection.lettings")
    sleep 1
  end
end

Then(/^I see a list of my lettable plots$/) do
  within ".record-list" do
    expect(page).to have_content("Plot #{CreateFixture.phase_plot_name}")
    expect(page).to have_content(t("lettings.client_admin_lettings.planet_rent"))
  end
end

Then(/^I cannot see the homeowner lettable plots$/) do
  within ".record-list" do
    expect(page).to_not have_content("Plot #{LettingsFixture.unletable_plot_number}")
  end
end

Then(/^I can set up my plot letting$/) do
  within ".record-list" do
    click_on(t("lettings.client_admin_lettings.let_my_plot"))
  end

  # Checks that the submit button is disabled when not all fields are completed
  within ".ui-dialog-buttonset" do
    expect(page).to have_css(".ui-state-disabled")
  end

  within ".lettings-form" do
    fill_in :letting_price, with: "800"
    fill_in :letting_town, with: "Town Name"
    fill_in :letting_bedrooms, with: "2"
    fill_in :letting_bathrooms, with: "2"
    fill_in :letting_landlord_pets_policy, with: LettingsFixture.pets_policy
    fill_in :letting_summary, with: LettingsFixture.property_summary
    fill_in :letting_notes, with: LettingsFixture.key_features
    fill_in :letting_postcode, with: "SO505TL"
  end

  within ".ui-dialog" do
    click_on t("lettings.client_admin_lettings.submit")
  end

  # PLANET RENT API
  # From here we need to alter the tests to test the function of the api.
  # The form needs to be sent to Planet Rent to set up the letting
  # Planet Rent need to send back a confirmation of letting creation and we then
  # need to set the plot's let status to true
  # For now I have just manually changed the plots let status and
  # re-visited the page to continue the testing of the ui.
  plot = Plot.find_by(number: CreateFixture.phase_plot_name)
  plot.let = true
  plot.save!
  within ".tabs" do
    click_on "Plots"
    click_on t("phases.collection.lettings")
  end
end

Then(/^I can see my plot marked as set up$/) do
  within ".record-list" do
    expect(page).to have_content("Plot #{CreateFixture.phase_plot_name}")
    expect(page).to have_content("Yes")
  end
end

Then(/^I can see the links to my lettings account$/) do
  expect(page).to_not have_content(t("lettings.client_admin_lettings.busy_living"))
  expect(page).to have_content(t("lettings.client_admin_lettings.planet_rent"))
end
