Given(/^I have two letable plots$/) do
  LettingsFixture.create_letable_plot
  LettingsFixture.create_second_letable_plot
end

Given(/^I have an unletable plot$/) do
  LettingsFixture.create_unletable_plot
end

Given(/^one of the plots has had lettings set up by another resident$/) do
  LettingsFixture.create_second_resident
    # Logout as first homeowner
    within ".full-menu" do
      click_on t("users.sign_out")
    end

    visit "/"

    # Login as second resident
    within ".sign-in" do
      fill_in :resident_email, with: LettingsFixture.second_resident_email
      fill_in :resident_password, with: LettingsFixture.second_resident_password
      check_box = find(".accept-ts-and-cs")
      check_box.trigger(:click)
      click_on "Login"
    end

    # Set up second resident account
    within ".full-menu" do
      click_on t("components.homeowner.welcome.rentals")
    end
    within ".management-service" do
      click_on t("homeowners.lettings.show.management_service_select")
    end
    within ".ui-dialog" do
      click_on t("homeowners.lettings.show.confirm_cta")
    end

    # PLANET RENT API
    # From here we need to alter the tests to test the function of the api.
    # The form needs to be sent to Planet Rent to set up the lettings account
    # For now I have just re-visited the page to continue the testing of the ui.
    visit "/"
    within ".full-menu" do
      click_on t("components.homeowner.welcome.rentals")
    end

    # Set up plot letting
    within ".letable" do
      click_on t("homeowners.components.lettings.let_my_plot")
    end

    # PLANET RENT API
    # The Property Type dropdown in the lettings form needs to be populated
    # by the property type api sent to us from Planet Rent
    within ".lettings-form" do
      fill_in :letting_price, with: "800"
      fill_in :letting_town, with: "Town Name"
      fill_in :letting_landlord_pets_policy, with: LettingsFixture.pets_policy
      fill_in :letting_summary, with: LettingsFixture.property_summary
      fill_in :letting_notes, with: LettingsFixture.key_features
      fill_in :letting_bedrooms, with: "2"
      fill_in :letting_bathrooms, with: "2"
      fill_in :letting_postcode, with: "SO505TL"
    end

    within ".ui-dialog" do
      click_on t("homeowners.components.lettings.submit")
    end

    # PLANET RENT API
    # From here we need to alter the tests to test the function of the api.
    # The form needs to be sent to Planet Rent to set up the letting
    # Planet Rent need to send back a confirmation of letting creation and we then
    # need to set the plot's let status to true
    # For now I have just manually changed the plots let status and
    # re-visited the page to continue the testing of the ui.
    plot = Plot.find_by(number: LettingsFixture.letable_plot_number)
    plot.let = true
    plot.save!

    # Log out as second resident and log in as first resident
    within ".full-menu" do
      click_on t("users.sign_out")
    end

    homeowner = HomeownerUserFixture
    visit "/"

    within ".sign-in" do
      fill_in :resident_email, with: homeowner.email
      fill_in :resident_password, with: homeowner.password

      click_on "Login"
    end
end

When(/^I navigate to the lettings page$/) do
  visit "/"
  within ".full-menu" do
    click_on t("components.homeowner.welcome.rentals")
  end
end

Then(/^I can see the plot that has been set up by the other resident$/) do
  within ".other-resident-lettings" do
    resident = LettingsFixture.second_resident_name + " " + LettingsFixture.second_resident_surname
    expect(page).to have_content(t("homeowners.components.lettings.let_out_other", other: resident))
    expect(page).to have_content("Plot #{LettingsFixture.letable_plot_number}")
    expect(page).to have_content(t("homeowners.components.other_resident_lettings.let_out_other", other: LettingsFixture.residents.second.email))
  end
end

Then(/^I can set up my self managed lettings account$/) do
  within ".self-managed" do
    click_on t("homeowners.lettings.show.self_managed_select")
  end
  within ".ui-dialog" do
    click_on t("homeowners.lettings.show.confirm_cta")
  end

  # PLANET RENT API
  # From here we need to alter the tests to test the function of the api.
  # The form needs to be sent to Planet Rent to set up the lettings account
  # For now I have just re-visited the page to continue the testing of the ui.
  visit "/"
  within ".full-menu" do
    click_on t("components.homeowner.welcome.rentals")
  end
end

Then(/^I can see my management type$/) do
  within ".lettings-management" do
    expect(page).to have_content(t("homeowners.lettings.show.self_managed"))
  end
end

Then(/^I can see my letable plot$/) do
  within ".unlet-plot" do
    expect(page).to have_content(LettingsFixture.second_letable_plot_number)
  end
end

Then(/^I can see the let plot$/) do
  within ".letable" do
    expect(page).to have_content(LettingsFixture.letable_plot_number)

    resident = LettingsFixture.second_resident_name + " " + LettingsFixture.second_resident_surname
    expect(page).to have_content(t("homeowners.components.lettings.let_out_other", other: resident))
    expect(page).to have_content("Plot #{LettingsFixture.letable_plot_number}")
  end
end

Then(/^I cannot see my unletable plot$/) do
  within ".unlet-plot" do
    expect(page).to_not have_content("Plot #{LettingsFixture.unletable_plot_number}")
  end
end

When(/^I set up my letable plot for letting$/) do
  within ".letable" do
    click_on t("homeowners.components.lettings.let_my_plot")
  end

  # PLANET RENT API
  # The Property Type dropdown in the lettings form needs to be populated
  # by the property type api sent to us from Planet Rent
  within ".lettings-form" do
    fill_in :letting_bedrooms, with: "2"
    fill_in :letting_bathrooms, with: "2"
    fill_in :letting_price, with: "800"
    fill_in :letting_town, with: "Town Name"
    fill_in :letting_landlord_pets_policy, with: LettingsFixture.pets_policy
    fill_in :letting_summary, with: LettingsFixture.property_summary
    fill_in :letting_notes, with: LettingsFixture.key_features
    fill_in :letting_postcode, with: "SO505TL"
  end

  within ".ui-dialog" do
    click_on t("homeowners.components.lettings.submit")
  end
end

Then(/^I can see that it is set up$/) do

  # PLANET RENT API
  # From here we need to alter the tests to test the function of the api.
  # The form needs to be sent to Planet Rent to set up the letting
  # Planet Rent need to send back a confirmation of letting creation and we then
  # need to set the plot's let status to true
  # For now I have just manually changed the plots let status and
  # re-visited the page to continue the testing of the ui.
  plot = Plot.find_by(number: LettingsFixture.second_letable_plot_number)
  plot.let = true
  plot.save!
  visit "/"
  within ".full-menu" do
    click_on t("components.homeowner.welcome.rentals")
  end

  within ".letable" do
    expect(page).to have_content("Plot #{LettingsFixture.second_letable_plot_number}")
    expect(page).to have_content(t("homeowners.components.lettings.dashboard"))
  end
end

Given(/^I have no letable plots$/) do
  # Plots are unletable by default
  plot = Plot.find_by(number: HomeownerUserFixture.plot_number)
end

Given(/^I am logged in as a limited access user$/) do
  login_as HomeownerUserFixture.create
  resident = Resident.find_by(email: HomeownerUserFixture.email)
  residency = PlotResidency.find_by(resident_id: resident.id)
  residency.role = 'tenant'
  residency.save!
  visit "/"
end

Then(/^I cannot see the lettings link$/) do
  visit "/"
  within ".full-menu" do
    expect(page).to_not have_content(t("components.homeowner.welcome.rentals"))
  end
end
