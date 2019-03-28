# frozen_string_literal: true

When(/^I accept the invitation as a homeowner$/) do
  within ".edit_resident" do
    fill_in :resident_password, with: HomeownerUserFixture.updated_password
    fill_in :resident_password_confirmation, with: HomeownerUserFixture.updated_password

    check_box = find(".accept-ts-and-cs")
    check_box.trigger(:click)

    click_on t("residents.invitations.edit.submit_button")
  end

  ActionMailer::Base.deliveries.clear
end

Then(/^I should be redirected to the homeowner dashboard$/) do
  expect(current_path).to eq '/'
end

Given(/^the developer has enabled services$/) do
  developer = Developer.find_by(company_name: HomeownerUserFixture.developer_name)
  developer = Developer.find_by(company_name: CreateFixture.developer_name) unless developer

  developer.update_attributes(enable_services: true)
end

Then(/^I select my services$/) do
  within ".services" do
    check_boxes = page.all(".add-service-checkbox")

    check_boxes.first.set(true)
    check_boxes.last.trigger("click")

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
    phone_updates = find(".telephone-updates")
    phone_updates.trigger(:click)
    email_updates = find(".cf-email-updates")
    email_updates.trigger(:click)
    sms_updates = find(".developer-sms-updates")
    sms_updates.trigger(:click)
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
    expect(selected).to have_content t("homeowners.residents.show.cf_email_updates")
    expect(selected).to have_content t("homeowners.residents.show.developer_sms_updates")

    unselected = page.all(".unselected").map(&:text)
    expect(unselected).to have_content t("homeowners.residents.show.post_updates")
    expect(unselected).to have_content t("homeowners.residents.show.developer_email_updates")
  end
end

When(/^I remove notification methods from my account$/) do
  within ".resident" do
    click_on t("homeowners.residents.show.edit_profile")
  end

  within ".communications" do
    phone_updates = find(".telephone-updates")
    phone_updates.trigger(:click)
    email_updates = find(".cf-email-updates")
    email_updates.trigger(:click)
    sms_updates = find(".developer-sms-updates")
    sms_updates.trigger(:click)
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
    expect(unselected).to have_content t("homeowners.residents.show.cf_email_updates")
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
    expect(page).to have_content t("homeowners.residents.show.none", plot: "Plot #{PlotFixture.another_plot_number}")

    expect(page).not_to have_content "test1@example.com"
    expect(page).not_to have_content "test2@example.com"
    expect(page).not_to have_content "test3@example.com"
    expect(page).not_to have_content "test4@example.com"
    expect(page).not_to have_content resident.email
  end
end

When(/^I switch to the homeowner plot$/) do
  plot = Plot.find_by(number: HomeownerUserFixture.plot_number)

  within ".plot-list" do
    plot_link = page.find_link(plot.to_homeowner_s)
    plot_link.trigger(:click)
  end

  wait_for_branding_to_reload
end

When(/^I soft delete the plot residency$/) do
  within ".session-inner" do
    click_on t("users.sign_out")
  end

  resident = Resident.find_by(email: PlotResidencyFixture.original_email)
  plot = resident.plots.first

  # PlotResidency is now hard delete
  # Sadly, we have legacy data in both staging and production with soft delete of PlotResidencies
  # The moral of the story is: never use soft delete on join tables
  plot_residency = PlotResidency.find_by(resident_id: resident.id, plot_id: plot.id)
  plot_residency.update_attribute(:deleted_at, Time.zone.now)
end

When(/^I log in as a Development Admin$/) do
  development_admin = CreateFixture.development_admin

  login_as development_admin
end

When(/^I log in as an existing homeowner$/) do
  within ".navbar-menu" do
    click_on t("components.navigation.log_out")
  end

  invitation = ActionMailer::Base.deliveries.last
  body_text = invitation.text_part.body.to_s
  sections = body_text.split(t("devise.mailer.resident_invitation.already_activated"))
  full_url = sections[1].strip

  relative_url = full_url.split("http://")[1]

  visit relative_url

  within ".new_resident" do
    fill_in :resident_email, with: PlotResidencyFixture.original_email
    fill_in :resident_password, with: HomeownerUserFixture.updated_password

    check_box = find(".accept-ts-and-cs")
    check_box.trigger(:click)

    click_on t("residents.sessions.new.login_cta")
  end
end

When(/^I visit the invitation accept page$/) do
  invitation = ActionMailer::Base.deliveries.last
  sections = invitation.text_part.body.to_s.split("http://")
  paths = sections[2].split(t("devise.mailer.invitation_instructions.ignore"))

  visit "/#{paths[0]}"
end

When(/^I do not accept terms and conditions$/) do
  within ".edit_resident" do
    fill_in :resident_password, with: HomeownerUserFixture.updated_password
    fill_in :resident_password_confirmation, with: HomeownerUserFixture.updated_password
  end
end

Then(/^I can not complete registration$/) do
  disabled_btn = page.find("[disabled]")
  expect(disabled_btn.value).to eq t("residents.invitations.edit.submit_button")
end

Given(/^a CF admin has configured a video link$/) do
  FactoryGirl.create(:setting, video_link: SettingsFixture.video_url)
end

Then(/^I should be redirected to the video introduction page$/) do
  within ".video-container" do
    expect(page).to have_content %r{#{t("homeowners.intro_videos.show.welcome_title", name: PlotResidencyFixture.attrs[:first_name])}}i

    click_on t("homeowners.intro_videos.show.next")
  end
end

Given(/^the plot has an address$/) do
  plot = Plot.find_by(number: HomeownerUserFixture.plot_number)
  plot.house_number = "66"
  address = FactoryGirl.create(:address)
  address.addressable = plot

  plot.save!
  address.save!
end

Given(/^I am a legacy homeowner$/) do
  # Invalid homeowner with no phone number
  homeowner = Resident.create(email: HomeownerUserFixture.email,
                              first_name: HomeownerUserFixture.first_name,
                              last_name: "Fooness",
                              password: HomeownerUserFixture.password,
                              invitation_accepted_at: Time.zone.now)
  homeowner.save(validate: false)

  plot = CreateFixture.division_plot
  plot_residency = PlotResidency.create(resident: homeowner, plot: plot)
  plot_residency.save(validate: false)
end

Given(/^I log in with cookies$/) do
  homeowner = Resident.find_by(email: HomeownerUserFixture.email)
  visit "/"

  within ".sign-in" do
    fill_in :resident_email, with: homeowner.email
    fill_in :resident_password, with: HomeownerUserFixture.password

    check_box = find(".accept-ts-and-cs")
    check_box.trigger(:click)

    click_on "Login"
  end
end

Then(/^the cookie should be set correctly$/) do
  homeowner = Resident.find_by(email: HomeownerUserFixture.email)
  expect(homeowner.ts_and_cs_accepted_at).not_to be_nil
end

Then(/^I add another resident$/) do
  visit "/"

  within ".session-inner" do
    click_on t("homeowners.residents.show.my_account")
  end

  within ".other-residents" do
    find(".add-resident").trigger("click")
  end

  within ".ui-dialog" do
    fill_in :resident_email, with: AccountFixture.second_resident_email
    fill_in :resident_phone_number, with: AccountFixture.second_resident_phone
    fill_in :resident_first_name, with: AccountFixture.second_resident_first
    fill_in :resident_last_name, with: AccountFixture.second_resident_last

    send_button = page.find(".btn-send")
    send_button.trigger("click")
  end
end

Then(/^I should see the resident has been added$/) do
  within ".notice" do
    expect(page).to have_content t("homeowners.residents.create.new_invitation", email: AccountFixture.second_resident_email)
  end

  resident = Resident.find_by(email: AccountFixture.second_resident_email)
  plot_residency = resident.plot_residencies.last
  expect(plot_residency.role).to eq "tenant"
  expect(plot_residency.homeowner?).to be false
  expect(plot_residency.tenant?).to be true
end

Then(/^I add a homeowner resident$/) do
  visit "/"

  within ".session-inner" do
    click_on t("homeowners.residents.show.my_account")
  end

  within ".other-residents" do
    find(".add-resident").trigger("click")
  end

  within ".ui-dialog" do
    select_from_selectmenu :resident_role, with: t("activerecord.attributes.plot_residency.roles.homeowner")
    fill_in :resident_email, with: AccountFixture.third_resident_email
    fill_in :resident_phone_number, with: AccountFixture.second_resident_phone
    fill_in :resident_first_name, with: AccountFixture.second_resident_first
    fill_in :resident_last_name, with: AccountFixture.third_resident_last

    send_button = page.find(".btn-send")
    send_button.trigger("click")
  end
end

Then(/^I should see the homeowner resident has been added$/) do
  within ".notice" do
    expect(page).to have_content t("homeowners.residents.create.new_invitation", email: AccountFixture.third_resident_email)
  end

  resident = Resident.find_by(email: AccountFixture.third_resident_email)
  plot_residency = resident.plot_residencies.last

  expect(plot_residency.role).to eq "homeowner"
  expect(plot_residency.homeowner?).to be true
  expect(plot_residency.tenant?).to be false
end

Then(/^I should see a duplicate plot resident error$/) do
  within ".alert" do
    expect(page).to have_content t("homeowners.residents.create.already_resident", email: AccountFixture.second_resident_email)
  end
end

Then(/^I can not add or remove residents$/) do
  within ".other-residents" do
    expect(page).not_to have_content(".remove-resident")
    expect(page).not_to have_content(".add-resident")
  end
end

When(/^I log back in as the first homeowner$/) do
  resident = Resident.find_by(email: PlotResidencyFixture.original_email)

  login_as resident

  visit "/"
end

When(/^I remove the additional resident$/) do
  within ".other-residents" do
    expect(page).to have_content( AccountFixture.second_resident_email)

    button = page.find("[data-email='#{AccountFixture.second_resident_email}']")
    button.trigger("click")
  end

  within ".ui-dialog-buttonset" do
    find(".remove-resident").trigger('click')
  end
end

Then(/^I see the resident has been hard removed$/) do
  within ".flash" do
    expect(page).to have_content t("homeowners.residents.remove_resident.success", email: AccountFixture.second_resident_email)
  end

  within ".other-residents" do
    expect(page).not_to have_content( AccountFixture.second_resident_email)
  end

  resident = Resident.find_by(email: AccountFixture.second_resident_email)
  expect(resident).to be_nil
end

Given(/^there are services$/) do
  Service.categories.each do |category|
    Service.create(category: category.last)
  end
end
