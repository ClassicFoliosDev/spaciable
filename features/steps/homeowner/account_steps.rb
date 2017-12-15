# frozen_string_literal: true

When(/^I accept the invitation as a homeowner$/) do

  invitation = ActionMailer::Base.deliveries.last
  sections = invitation.text_part.body.to_s.split("http://")
  paths = sections[2].split(t("devise.mailer.invitation_instructions.ignore"))

  url = "http://#{paths[0]}"
  visit url

  within ".edit_resident" do
    fill_in :resident_password, with: HomeownerUserFixture.updated_password
    fill_in :resident_password_confirmation, with: HomeownerUserFixture.updated_password

    click_on t("residents.invitations.edit.submit_button")
  end
end

Then(/^I should be redirected to the homeowner dashboard$/) do
  expect(current_path).to eq '/'
end

Given(/^the developer has enabled services$/) do
  developer = Developer.find_by(company_name: HomeownerUserFixture.developer_name)
  developer = Developer.find_by(company_name: CreateFixture.developer_name) unless developer

  developer.update_attributes(enable_services: true)
end

Given(/^I have seeded the database with services$/) do
  load Rails.root.join("db", "seeds", "services_seeds.rb")
end

Then(/^I select my services$/) do
  services = Service.all
  first_service = services.first
  last_service = services.last

  within ".services" do
    check_box = find("[value='#{first_service.id}']")
    check_box.set(true)
    check_box = find("[value='#{last_service.id}']")
    check_box.set(true)

    click_on t("homeowners.services.index.submit")
  end
end

Then(/^My services have been selected$/) do
  resident_services = ResidentService.all
  expect(resident_services.length).to eq 2
end

Then(/^I should see be able to view My Account$/) do
  visit "/"

  within ".session-inner" do
    click_on t("homeowners.residents.show.my_account")
  end
end

When(/^I update the account details$/) do
  within ".resident" do
    click_on t("homeowners.residents.show.edit_profile")
  end

  within ".details" do
    fill_in "resident_first_name", with: AccountFixture.first_name
  end

  within ".communications" do
    check "resident[telephone_updates]"
    check "resident[hoozzi_email_updates]"
  end

  within ".services" do
    check_boxes = page.all("input")
    check_boxes.first.set(true)
    check_boxes.last.set(true)
  end

  within ".actions" do
    click_on t("homeowners.residents.edit.submit")
  end
end

Then(/^I should see account details updated successfully$/) do
  within ".session-inner" do
    click_on I18n.t("homeowners.residents.show.my_account")
  end

  within ".resident" do
    expect(page).to have_content AccountFixture.first_name
  end

  within ".communications" do
    selected = page.all(".selected").map(&:text)
    expect(selected).to have_content t("homeowners.residents.show.telephone_updates")
    expect(selected).to have_content t("homeowners.residents.show.hoozzi_email_updates")

    unselected = page.all(".unselected").map(&:text)
    expect(unselected).to have_content t("homeowners.residents.show.post_updates")
    expect(unselected).to have_content t("homeowners.residents.show.developer_email_updates")
  end

  within ".services" do
    selected = page.all(".selected")
    expect(selected.count).to eq 2

    unselected = page.all(".unselected")
    expect(unselected.count).to eq 4
  end
end

When(/^I remove services from my account$/) do
  within ".resident" do
    click_on t("homeowners.residents.show.edit_profile")
  end

  within ".communications" do
    uncheck "resident[telephone_updates]"
    uncheck "resident[hoozzi_email_updates]"
  end

  within ".services" do
    check_boxes = page.all("input")
    check_boxes.last.set(false)
    check_boxes.first.set(false)
  end

  within ".actions" do
    click_on t("homeowners.residents.edit.submit")
  end
end

Then(/^I should see account subscriptions removed successfully$/) do
  within ".session-inner" do
    click_on I18n.t("homeowners.residents.show.my_account")
  end

  within ".resident" do
    expect(page).to have_content AccountFixture.first_name
  end

  within ".communications" do
    selected = page.all(".selected").map(&:text)
    expect(selected.count).to be_zero

    unselected = page.all(".unselected").map(&:text)
    expect(unselected).to have_content t("homeowners.residents.show.telephone_updates")
    expect(unselected).to have_content t("homeowners.residents.show.hoozzi_email_updates")
  end

  within ".services" do
    selected = page.all(".selected").map(&:text)
    expect(selected.count).to be_zero

    unselected = page.all(".unselected").map(&:text)
    expect(unselected.count).to eq 6
    expect(unselected).to have_content "Removals"
  end
end

Then(/^I should not see services in my account$/) do
  within ".session-inner" do
    click_on t("homeowners.residents.show.my_account")
  end

  within ".outer-container" do
    expect(page).not_to have_content(".services")
  end
end

Then(/^I should not see services when I edit my account$/) do
  within ".resident" do
    click_on t("homeowners.residents.show.edit_profile")
  end

  within ".outer-container" do
    expect(page).not_to have_content(".services")
  end
end

Then(/^I should see the resident emails listed in my account$/) do
  resident = Resident.find_by(email: HomeownerUserFixture.email)
  visit "/homeowners/residents/#{resident.id}"

  within ".other-residents" do
    expect(page).to have_content "test1@example.com"
    expect(page).to have_content "test2@example.com"
    expect(page).to have_content "test3@example.com"

    # Should not see resident for a different plot
    expect(page).not_to have_content "test4@example.com"
    # Should not see my own email address
    expect(page).not_to have_content resident.email
  end
end

When(/^I select no services$/) do
  within ".services" do
   click_on t("homeowners.services.index.submit")
  end
end

Then(/^I should not see other resident emails listed in my account$/) do
  resident = Resident.find_by(email: HomeownerUserFixture.email)
  visit "/homeowners/residents/#{resident.id}"

  within ".other-residents" do
    expect(page).to have_content t("homeowners.residents.show.none", plot: PlotFixture.another_plot_number)

    expect(page).not_to have_content "test1@example.com"
    expect(page).not_to have_content "test2@example.com"
    expect(page).not_to have_content "test3@example.com"
    expect(page).not_to have_content "test4@example.com"
    expect(page).not_to have_content resident.email
  end
end

When(/^I switch to the homeowner plot$/) do
  within ".plot-list" do
    plot_link = page.find_link(HomeownerUserFixture.plot_number)
    plot_link.trigger(:click)
  end

  wait_for_branding_to_reload
end
