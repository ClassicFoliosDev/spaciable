# frozen_string_literal: true

When(/^I add appliances and finishes$/) do
  CreateFixture.create_appliances
end

When(/^I want to create a development for the developer$/) do
  visit "/"

  within ".navbar" do
    click_on t("components.navigation.developers")
  end

  within "[data-developer='#{CreateFixture.developer_id}']" do
    click_on t("developers.index.developments")
  end

  click_on t("developments.index.add")

  fill_in "development_name", with: CreateFixture.development_name
  DeveloperDevelopmentFixture.update_attrs.each do |attr, value|
    fill_in "development_#{attr}", with: value
  end
end

Then(/^choice options should be off by default$/) do
  expect(page).to have_content("Choices")
  expect(page).to have_content("Off")
  expect(page).not_to have_content("Choices Email")
end

When(/^I submit and view the new development$/) do
  click_on t("developments.form.submit")
  click_on CreateFixture.development_name
end

Then(/^no choice options should be available$/) do
  expect(page).not_to have_content("Choices")
end

When(/^I enable the Either option on the development$/) do
  find("[data-action='edit']").click
  select_from_selectmenu :development_choice_option, with: t(".activerecord.attributes.developer.choice_labels.either_can_choose")
  fill_in "development_choices_email_contact", with: CreateFixture.choice_email_contact
end

Then(/^a Choises contact email should become available$/) do
  expect(page).to have_content("Choices Email")
  click_on t("developments.form.submit")
  sleep 2
end

Then(/^the choices option should be available on the development$/) do
  expect(page).to have_content("Choices")
end

When(/^I create a unit type with rooms for the development$/) do
  CreateFixture.create_unit_type
  CreateFixture.create_unit_type_rooms
  sleep 2
end

When(/^I create a new choice configuration$/) do
  development = Development.find_by(name: CreateFixture.development_name)
  sleep 2
end

Then(/^I should be able to create my config based on the unit_type$/) do
  click_on "Choices"
  sleep 5
  click_on t("choice_configurations.collection.add")
  fill_in "choice_configuration_name", with: CreateFixture.choice_configuration_name
  select_from_selectmenu :choice_configuration_unit_type, with: CreateFixture. unit_type_name
  click_on t("developments.form.submit")
end

Then(/^the configuration should be created successfully$/) do
  expect(page).to have_content("#{CreateFixture.choice_configuration_name} was created successfully")
end

When(/^I go to the view the configuration$/) do
  click_on CreateFixture.choice_configuration_name
  sleep 4
end

Then(/^the configuration should contain rooms matching the unit type$/) do
  CreateFixture.unit_type_rooms.each do |roomname|
    expect(page).to have_content(roomname)
  end
end

When(/^I add a new room configuration$/) do
  click_on t("room_configurations.collection.add")
  fill_in "room_configuration_name", with: CreateFixture.bedroom2_name
  select_from_selectmenu :room_configuration_icon_name, with: "Bedroom"
  click_on t("developments.form.submit")
end

Then(/^the configuration should contain the new room configuration$/) do
  expect(page).to have_content(CreateFixture.bedroom2_name)
end

When(/^I select a room configuration$/) do
  click_on "Kitchen"
end

Then(/^it should contain no room items$/) do
  expect(page).to have_content("You have no room items")
end

When(/^I add a new room item/) do
  click_on "Add room item"
end

When(/^I associate multiple apliances$/) do
  sleep 4
  # Check all appliance types are selectable
  CreateFixture::APPLIANCERESOURCES.each do |appliancecategory|
    select_from_selectmenu :room_item_room_itemable_id, with: appliancecategory
  end

  sleep 2
  # type in 'F<return>' 4 times to select the 4 items
  within ".chosen-choices" do
    find('.chosen-search-input').set('F\nF\nF\vF\n')
  end

  # check the items appear fully formed on the page
  (1..4).each do |appliance|
    expect(page).to have_content("#{CreateFixture.appliance_manufacturer} #{CreateFixture::APPLIANCERESOURCES.last}#{appliance}")
  end

  # The 'chosen' javscriot library doesn't seem to work 100% inside capybara so select the items in the
  # hidden select so as they get posted back to the controller and saved
  ignore = Capybara.ignore_hidden_elements
  Capybara.ignore_hidden_elements = false
  (1..4).each do |appliance|
    appliance = Appliance.find_by(model_num: "#{CreateFixture::APPLIANCERESOURCES.last}#{appliance}")
    page.find_by_id('room_item_category_item_ids').find("option[value='#{appliance.id}']").select_option
  end
  Capybara.ignore_hidden_elements = ignore

  click_on t("developments.form.submit")
end

Then(/^the room item should save successfully$/) do
  expect(page).to have_content("#{CreateFixture::APPLIANCERESOURCES.last} was created successfully")
end

When(/^I select the room item$/) do
  click_on CreateFixture::APPLIANCERESOURCES.last
end

Then(/^the room item options should be listed$/) do
  (1..4).each do |appliance|
    expect(page).to have_content("#{CreateFixture::APPLIANCERESOURCES.last}#{appliance}")
  end
end

When(/^there is development where either can make choices$/) do
  CreateFixture.create_development_with_plots_and_choices
  # enable 'either' choices on developments
  Development.update_all(choice_option: :either_can_choose, choices_email_contact: CreateFixture.choice_email_contact)
end

Then(/^I can associate plots with the choice configuration$/) do
  # go to the choice configuration for the developmenp
  visit "developments/#{CreateFixture.development.id}/choice_configurations/#{CreateFixture.choice_configuration.id}"
  within ".section-header" do
    # edit it
    find("[data-action='edit']").click
  end

  expect(page).to have_content(CreateFixture.phase_name)
  # We  really want to use 'Select All' but the 'chosen' javascript doesn't seem to work inside capybara
  # Have to go through and set all options - this will confirm that all the required plots are there
  # and also set them so the submit assigns the choice configuration to them
  selector = "choice_configuration_phase_#{CreateFixture.phase.id}_ids"

  # 'chosen' hides the selector so we need to temporarily see the hidden fields
  ignore = Capybara.ignore_hidden_elements
  Capybara.ignore_hidden_elements = false
  page.find_by_id(selector).find("option[value='#{CreateFixture.phase_plot.id}']").select_option
  (1..10).each do |plot_number|
    plot = Plot.find_by(number: plot_number.to_s)
    page.find_by_id(selector).find("option[value='#{plot.id}']").select_option
  end
  Capybara.ignore_hidden_elements = ignore

  click_on t("developments.form.submit")
end

Then(/^I can view choices for a plot$/) do
   visit "plots/#{CreateFixture.phase_plot.id}/choices"
end

Then(/^I can only see rooms with available choices$/) do
  expect(page).to have_selector('#'+CreateFixture.kitchen_name, visible: false)
  expect(page).to have_selector('#'+CreateFixture.bedroom_name, visible: false)
  expect(page).not_to have_selector('#'+CreateFixture.lounge_name, visible: false)
  expect(page).not_to have_selector('#'+CreateFixture.bathroom_name, visible: false)
end

When(/^I select a room a category and a choice$/) do
  select_from_selectmenu :room_select, with: CreateFixture.kitchen_name
  expect(page).to have_content(CreateFixture.kitchen_name, count: 2)
  expect(page).not_to have_selector('#'+CreateFixture.bedroom_name)
  sleep 1
  select_from_selectmenu :select_item, with: "Oven"
  sleep 1
  select_from_selectmenu :select_item_choice, with: "#{CreateFixture.appliance_manufacturer_name} Oven1"
end

Then(/^the room item populates with the selected value$/) do
  expect(page).to have_content("#{CreateFixture.appliance_manufacturer_name} Oven1", count: 2)
end

Then(/^I can successfully save the change$/) do
  click_on t("choices.save")
  expect(page).to have_content(t("choices.admin.update.admin_updating"))
end

When(/^I log in as the plot resident$/) do
  resident = Resident.find_by(email: CreateFixture.resident_email)
  login_as resident
end

Then(/^I have choices available$/) do
  visit "/"
  within ".burger-navigation" do
    check_box = find(".burger")
    check_box.trigger(:click)
  end
  click_on(t("components.homeowner.navigation.choices"))
end

Then(/^I can see the choice made by the administrator$/) do
  expect(page).to have_content("Oven1")
end

Then(/^the resident can make a change and save it$/) do
  select_from_selectmenu :room_select, with: CreateFixture.kitchen_name
  expect(page).to have_content(CreateFixture.kitchen_name, count: 2)
  expect(page).not_to have_selector('#'+CreateFixture.bedroom_name)
  sleep 1
  select_from_selectmenu :select_item, with: CreateFixture::FINISHRESOURCES[1][0]
  sleep 1
  select_from_selectmenu :select_item_choice, with: CreateFixture::FINISHRESOURCES[1][3][1]
  click_on t("choices.save")
  expect(page).to have_content(t("choices.homeowner.homeowner_updating"))
end

When(/^all the choices are complete$/) do
  select_from_selectmenu :room_select, with: CreateFixture.bedroom_name
  expect(page).to have_content(CreateFixture.bedroom_name, count: 2)
  expect(page).not_to have_selector('#'+CreateFixture.kitchen_name)
  sleep 1
  select_from_selectmenu :select_item, with: CreateFixture::FINISHRESOURCES[0][0]
  sleep 1
  select_from_selectmenu :select_item_choice, with: CreateFixture::FINISHRESOURCES[0][3][1]
end

Then(/^I can commit the choices$/) do
  click_on t("choices.confirm")
  expect(page).to have_content(t("components.choices.resident.confirm_message"))
  click_on "Confirm"
  expect(page).to have_content(t("choices.homeowner.committed_by_homeowner"))
  expect(page).not_to have_content(t("choices.confirm"))
end

When(/^I can view the plot choices$/) do
 expect(page).to have_content("#{CreateFixture.appliance_manufacturer_name} Oven1")
 finish = Finish.find_by(name: CreateFixture::FINISHRESOURCES[1][3][1])
 expect(page).to have_content(finish.full_name)
 finish = Finish.find_by(name: CreateFixture::FINISHRESOURCES[0][3][1])
 expect(page).to have_content(finish.full_name)
 expect(page).to have_content(t("choices.admin.committed_by_homeowner", plot_name: CreateFixture.phase_plot_name))
end

When(/^I remove a choice$/) do
  page.find(:xpath, './/button[@id="4_3"]').trigger('click')
end

Then(/^a dialog should appear asking if I want to archive the choice$/) do
  expect(page).to have_content("Would you like to archive this choice?")
end

Then(/^I can acknowledge the dialog and archive the choice$/) do
  click_on "Yes"
  expect(page).not_to have_content("#{CreateFixture.appliance_manufacturer} Oven1")
end

When(/^the "([^"]*)" button should be disabled$/) do |arg1|
  expect(page.find("##{arg1}")[:disabled]).to be true
end

When(/^the "([^"]*)" button should not be disabled$/) do |arg1|
  expect(page.find("##{arg1}")[:disabled]).to be false
end

When(/^I press the reject button$/) do
 page.find("#Reject").trigger('click')
end

Then(/^a dialog appears asking for details of the rejection$/) do
 expect(page).to have_content("Please provide the buyer with a reason for declining their list of choices..")
end

When(/^I fill in the reason for rejection and confirm$/) do
 fill_in "notification", with: CreateFixture.rejection_message
 click_on "Confirm"
end

Then(/^I am told the homeowner has been notified$/) do
 expect(page).to have_content(t("choices.admin.homeowner_notified_of_rejection", plot_name: CreateFixture.phase_plot_name))
end

Then(/^I can see a notification containing the rejection reason$/) do
 visit("homeowners/notifications")
 expect(page).to have_content("Home Choices Declined")
 page.find(:xpath, './/div[@data-subject="Home Choices Declined"]').trigger('click')
 expect(page).to have_content(CreateFixture.rejection_message)
end

Then(/^I see a message telling me the choices have been rejected$/) do
 find(".notice")
 expect(page).to have_content(t("choices.homeowner.choices_rejected", plot_name: CreateFixture.phase_plot_name))
end

Then(/^the archived choice is no longer available for selection$/) do
 select_from_selectmenu :room_select, with: CreateFixture.kitchen_name
 sleep 1
 select_from_selectmenu :select_item, with: "Oven"
 sleep 1
 ignore = Capybara.ignore_hidden_elements
 Capybara.ignore_hidden_elements = false
 expect(page).not_to have_content("#{CreateFixture.appliance_manufacturer_name} Oven1")
 Capybara.ignore_hidden_elements = ignore
end

Then(/^I make a new choice for the rejeted item$/) do
 select_from_selectmenu :select_item_choice, with: "#{CreateFixture.appliance_manufacturer_name} Oven2"
end

When(/^I can view the updated plot choices$/) do
 expect(page).to have_content("#{CreateFixture.appliance_manufacturer_name} Oven2")
 finish = Finish.find_by(name: CreateFixture::FINISHRESOURCES[1][3][1])
 expect(page).to have_content(finish.full_name)
 finish = Finish.find_by(name: CreateFixture::FINISHRESOURCES[0][3][1])
 expect(page).to have_content(finish.full_name)
 expect(page).to have_content(t("choices.admin.committed_by_homeowner", plot_name: CreateFixture.phase_plot_name))
end

When(/^I approve the choices$/) do
 click_on "Approve"
end

Then(/^I get a confirmation message$/) do
 expect(page).to have_content(t("choices.admin.update.choices_approved", plot_name: CreateFixture.phase_plot_name))
end

Then(/^I can export the choices as a CSV file$/) do
  click_on "Choices"
  expect(page).to have_content("Export Choices")

  #page.find(:xpath, './/button[text()="Export Choices"]').trigger('click')
  #sleep 4
  #filename = "Plot #{CreateFixture.phase_plot_name}-#{Time.zone.today.strftime('%d %B %Y')}.csv"
  #page.response_headers['Content-Disposition'].should include("filename=\"#{filename}\"")
end

When(/^I view the rooms$/) do
 click_on "Rooms"
end

Then(/^I see a list of the rooms$/) do
 expect(page).to have_content(CreateFixture.kitchen_name)
 expect(page).to have_content(CreateFixture.bedroom_name)
end

Then(/^I see the approved choices$/) do
  click_on CreateFixture.kitchen_name
  expect(page).to have_content(CreateFixture::FINISHRESOURCES[1][3][1])
  within ".tabs" do
    click_on "Appliances"
  end
  expect(page).to have_content("#{CreateFixture.appliance_manufacturer_name} Oven2")
  click_on t("plots.rooms.show.back")
  click_on CreateFixture.bedroom_name
  expect(page).to have_content(CreateFixture::FINISHRESOURCES[0][3][1])
end

Then(/^I dont have the choices tab available$/) do
  visit("homeowners/rooms")
  expect(page).not_to have_content("Choices")
end

Then(/^my choices are displayed against the rooms$/) do
  expect(page).to have_content(CreateFixture::FINISHRESOURCES[1][3][1])
  expect(page).to have_content(CreateFixture::FINISHRESOURCES[0][3][1])
  expect(page).to have_content("#{CreateFixture.appliance_manufacturer_name} Oven2")
end

Then(/^my appliance choices are displayed under appliances$/) do
  click_on "Appliances"
  expect(page).to have_content("#{CreateFixture.appliance_manufacturer_name} Oven2")
end

When(/^there is development where only Admin can make choices$/) do
  CreateFixture.create_development_with_plots_and_choices
  # enable 'either' choices on developments
  Development.update_all(choice_option: :admin_can_choose, choices_email_contact: CreateFixture.choice_email_contact)
end

When(/^I can complete all the choices$/) do
 visit "plots/#{CreateFixture.phase_plot.id}/choices"
  select_from_selectmenu :room_select, with: CreateFixture.kitchen_name
  sleep 1
  select_from_selectmenu :select_item, with: CreateFixture::FINISHRESOURCES[1][0]
  sleep 1
  finish = Finish.find_by(name: CreateFixture::FINISHRESOURCES[1][3][1])
  select_from_selectmenu :select_item_choice, with: finish.full_name
  select_from_selectmenu :room_select, with: CreateFixture.bedroom_name
  sleep 1
  select_from_selectmenu :select_item, with: CreateFixture::FINISHRESOURCES[0][0]
  sleep 1
  finish = Finish.find_by(name: CreateFixture::FINISHRESOURCES[0][3][1])
  select_from_selectmenu :select_item_choice, with: finish.full_name
  select_from_selectmenu :room_select, with: CreateFixture.kitchen_name
  sleep 1
  select_from_selectmenu :select_item, with: "Oven"
  sleep 1
  select_from_selectmenu :select_item_choice, with: "#{CreateFixture.appliance_manufacturer_name} Oven2"
end

Then(/^I can approve the choices$/) do
  click_on "Approve"
  expect(page).to have_content(t("components.choices.admin.confirm_message"))
  click_on "Confirm"
  expect(page).to have_content(t("choices.admin.update.choices_approved"))
end

Then(/^I can see an email confirming the choices$/) do
  open_last_email
  email = ActionMailer::Base.deliveries.last
  email.should be_delivered_from(CreateFixture.resident_email)
  email.should deliver_to(CreateFixture.development_admin.email)
  expect(email).to have_subject ("Plot #{CreateFixture.phase_plot_name} Choice Selections")
  expect(email.default_part_body.to_s).to include(CreateFixture.phase_plot_name)
  expect(email.default_part_body.to_s).to include(CreateFixture.development_name)
  expect(email.default_part_body.to_s).to include(CreateFixture.developer_name)
end

Then(/^I can see a rejection email$/) do
  open_last_email
  current_email.should be_delivered_from("no-reply@spaciable.com")
  current_email.should deliver_to(CreateFixture.resident_email)
  expect(current_email).to have_subject ("Plot #{CreateFixture.phase_plot_name} Choice Selections Declined")
  expect(current_email.default_part_body.to_s).to include(CreateFixture.rejection_message)
end

Then(/^a confirmation email is sent to the resident$/) do
  email = ActionMailer::Base.deliveries.first
  email.should be_delivered_from("no-reply@spaciable.com")
  email.should deliver_to(CreateFixture.resident_email)
  expect(email).to have_subject ("Plot #{CreateFixture.phase_plot_name} Choice Selections Approved")
  expect(email).to have_body_text(CreateFixture.phase_plot_name)
  expect(email).to have_body_text(CreateFixture.development_name)
  expect(email).to have_body_text("Your selected choices have been approved for")
  expect(email).to have_body_text(CreateFixture.kitchen_name)
  expect(email).to have_body_text("Oven2")
  expect(email).to have_body_text(CreateFixture::FINISHRESOURCES[1][3][1])
  expect(email).to have_body_text(CreateFixture.bedroom_name)
  expect(email).to have_body_text(CreateFixture::FINISHRESOURCES[0][3][1])
end

Then(/^a confirmation email is sent to the developer admin$/) do
  email = ActionMailer::Base.deliveries.last
  email.should be_delivered_from(CFAdminUserFixture.email)
  email.should deliver_to(CreateFixture.choice_email_contact, CFAdminUserFixture.email)
  expect(email).to have_subject ("Plot #{CreateFixture.phase_plot_name} Choice Selections")
  expect(email.default_part_body.to_s).to include(CreateFixture.phase_plot_name)
  expect(email.default_part_body.to_s).to include(CreateFixture.development_name)
  expect(email.default_part_body.to_s).to include(CreateFixture.developer_name)
  expect(email.default_part_body.to_s).to include("Choices have been submitted and approved for the following plot")
  expect(email.default_part_body.to_s).to include(CreateFixture.kitchen_name)
  appliance = Appliance.find_by(model_num: "Oven2")
  expect(email.default_part_body.to_s).to include(appliance.full_name)
  finish = Finish.find_by(name: CreateFixture::FINISHRESOURCES[1][3][1])
  expect(email.default_part_body.to_s).to include(finish.full_name)
  expect(email.default_part_body.to_s).to include(CreateFixture.bedroom_name)
  finish = Finish.find_by(name: CreateFixture::FINISHRESOURCES[0][3][1])
  expect(email.default_part_body.to_s).to include(finish.full_name)
end

When(/^there is plot with no resident where only Admin can make choices$/) do
  CreateFixture.create_development_with_plot_and_choices_no_resident
  # enable 'either' choices on developments
  Development.update_all(choice_option: :admin_can_choose, choices_email_contact: CreateFixture.choice_email_contact)
end


