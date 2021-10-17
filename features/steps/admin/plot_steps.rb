# frozen_string_literal: true

Given(/^I have a developer with a development with unit types$/) do
  PlotFixture.create_developer_with_development_and_unit_types
end

Then(/^I should see the created plot$/) do
  expect(page).to have_content(PlotFixture.developer_name)
  click_on PlotFixture.plot_name

  within ".about" do
    expect(page).to have_content(PlotFixture.plot_number)
    expect(page).to have_content(PlotFixture.unit_type_name)
  end

  within ".section-data" do
    expect(page).not_to have_content(PlotFixture.plot_number)
  end

  click_on t("plots.edit.back")
end

When(/^I update the plot$/) do
  within ".record-list" do
    find("[data-action='edit']").click
  end

  within ".edit_plot" do
    PlotFixture.update_attrs.each do |attr, value|
      fill_in "plot_#{attr}", with: value
    end

    within ".plot_unit_type" do
      select PlotFixture.updated_unit_type_name, visible: false
    end

    select_from_selectmenu :plot_progress, with: PlotFixture.progress

    check :plot_notify
    click_on t("plots.form.submit")
  end
end

Then(/^I should see the updated plot$/) do
  success_flash = t(
    "controller.success.update",
    name: "Plot #{PlotFixture.plot_number}"
  )
  success_flash << t("resident_notification_mailer.notify.update_sent", count: 1)

  expect(page).to have_content(success_flash)

  within ".record-list" do
    click_on PlotFixture.plot_name
  end

  within ".section-title" do
    expect(page).to have_content(PlotFixture.update_attrs[:number])
    expect(page).to have_content(PlotFixture.progress)
    expect(page).to have_content(PlotFixture.completion_date)
  end

  within ".section-data" do
    expect(page).to have_content(PlotFixture.updated_unit_type_name)
    expect(page).to have_content(PlotFixture.updated_house_number)
    expect(page).to have_content(PlotFixture.plot_building_name)
    expect(page).to have_content(PlotFixture.plot_road_name)
    expect(page).to have_content(PlotFixture.plot_postcode)
    expect(page).to have_content(PhaseFixture.development_address_attrs[:locality])
    expect(page).to have_content(PhaseFixture.development_address_attrs[:city_name])
    expect(page).to have_content(PhaseFixture.development_address_attrs[:county_name])

    expect(page).not_to have_content(PlotFixture.unit_type_name)
  end
end

When(/^I delete the plot$/) do
  goto_development_show_page

  within ".tabs" do
    click_on t("developments.collection.plots")
  end

  plot_id = PlotFixture.plot_id
  delete_and_confirm!(scope: "[data-plot='#{plot_id}']")
end

Then(/^I should see that the plot deletion completed successfully$/) do
  success_flash = t(
    "plots.destroy.success",
    plot_name: PlotFixture.plot_name
  )
  expect(page).to have_content(success_flash)

  within ".breadcrumbs" do
    expect(page).to have_content(PlotFixture.development_name)
  end

  expect(page).not_to have_content(".record-list")

  within ".empty" do
    expect(page).to have_content t("components.empty_list.add", type_name: Plot.model_name.human.downcase)
  end
end

Given(/^I have created a plot for the development$/) do
  goto_development_show_page

  within ".tabs" do
    click_on t("developments.collection.plots")
  end

  click_on t("plots.collection.add")

  fill_in "plot_list", with: PlotFixture.plot_number
  within ".plot_unit_type" do
    select PlotFixture.unit_type_name, visible: false
  end

  click_on t("phases.form.submit")
end

When(/^I preview the plot$/) do
  within ".record-list" do
    click_on CreateFixture.phase_plot_name
  end

  within ".section-data" do
    click_on t("plots.show.preview")
  end
end

Then(/^I see the plot preview page$/) do
  sleep 0.3

  within_frame("rails_iframe") do
    expect(page).to have_content(t("homeowners.my_home_name", construction: t("construction_type.home")))
    expect(page).to have_content(t("homeowners.components.address.view_more", construction: t("components.homeowner.sub_menu.title")))

    expect(page).to have_content(PhaseFixture.phase_address_update_attrs[:building_name])
    expect(page).to have_content(PhaseFixture.phase_address_update_attrs[:road_name])
    expect(page).to have_content(PhaseFixture.phase_address_update_attrs[:postcode])

    expect(page).to have_content(t("homeowners.dashboard.contacts.contacts_title"))
    expect(page).to have_content(t("homeowners.dashboard.contacts.contacts_view_more"))

    expect(page).to have_content(t("homeowner.dashboard.cards.faqs.title"))
    expect(page).to have_content(t("homeowner.dashboard.cards.faqs.view_more"))
  end
end

Then(/^I can see my library$/) do
  within_frame("rails_iframe") do
    click_on t("homeowner.dashboard.cards.library.view_more")
  end

  sleep 0.7
  within_frame("rails_iframe") do
    expect(page).to have_content %r{#{t("components.homeowner.sub_menu.library")}}i

    expect(page).to have_content "Development Document"
    anchor = page.first("a[href='/uploads/document/file/2/development_document.pdf']")
    expect(anchor).not_to be_nil
  end
end

Then(/^I can see my appliances$/) do
  within_frame("rails_iframe") do
    within ".burger-navigation" do
      check_box = find(".burger")
      check_box.trigger(:click)
    end
    find(:xpath, "//a[@href='/homeowners/my_appliances']", visible: true).click
  end

  within_frame("rails_iframe") do
    expect(page).to have_content(t("homeowners.appliances.show.title"))
  end
end

Then(/^I can see my contacts$/) do
  within_frame("rails_iframe") do
    within ".burger-navigation" do
      check_box = find(".burger")
      check_box.trigger(:click)
    end
    find(:xpath, "//li[contains(text(),'#{t("layouts.homeowner.nav.contacts")}')]").trigger('click')
  end

  sleep 0.2
  within_frame("rails_iframe") do
    expect(page).to have_content %r{#{t("homeowners.contacts.index.title")}}i
  end
end

Then(/^I can see my faqs$/) do
  within_frame("rails_iframe") do
    within ".burger-navigation" do
      check_box = find(".burger")
      check_box.trigger(:click)
    end
    faqs = find(:xpath, "//a/li[contains(text(),'#{t("components.homeowner.navigation.faqs")}')]/parent::a")
    faqs.trigger(:click)
  end

  sleep 0.2
  within_frame("rails_iframe") do
    expect(page).to have_content %r{#{t("homeowners.faqs.index.faqs", type: "Homeowner")}}i
  end
end

When(/^I send a notification the phase$/) do
  ActionMailer::Base.deliveries.clear
  visit "/admin/notifications/new"

  within ".send-targets" do
    within ".developer-id" do
      select_from_selectmenu(:notification_developer_id, with: CreateFixture.developer_name)
    end

    sleep 0.3
    within ".phase-id" do
      select_from_selectmenu(:"notification_phase_id", with: PhasePlotFixture.phase_name)
    end
  end

  within ".send-message" do
    fill_in :notification_subject, with: "Send to deleted plot"
    fill_in_ckeditor(:notification_message, with: "This message should not arrive")
  end

  within ".form-actions-footer" do
    click_on t("admin.notifications.form.submit")
  end

  within find(".submit-dialog") do
    page.should have_content(I18n.t("admin.notifications.form.no_plots"))
    page.should have_no_content("Confirm")
    click_on "Cancel"
  end
end

Then(/^I should see the notification is not sent to the former resident$/) do
  emails = ActionMailer::Base.deliveries
  expect(emails.length).to be_zero
end

When(/^I update the progress for the plot$/) do
  goto_phase_plot_show_page
  sleep 0.5

  within ".tabs" do
    click_on t("plots.collection.progress")
  end

  within ".edit_plot" do
    select_from_selectmenu :plot_progress, with: PhaseFixture.progress
  end

  within ".row-item" do
    check :plot_notify
    click_on t("progresses.progress.submit")
  end
end

Then(/^I should see the plot progress has been updated$/) do
  success_flash = t("plots.update.success.one", plot_name: CreateFixture.phase_plot_name )
  success_flash << t("resident_notification_mailer.notify.update_sent", count: 2)

  within ".notice" do
    expect(page).to have_content(success_flash)
  end

  within ".section-header" do
    expect(page).to have_content(PhaseFixture.progress)
    expect(page).not_to have_content("Building soon")
  end
end

Then(/^both residents have been notified$/) do
  message = t("notify.updated_progress", stage: "Ready for exchange")

  in_app_notification = Notification.all.last
  expect(in_app_notification.residents.count).to eq 2
  expect(in_app_notification.residents.first.email).to eq CreateFixture.resident.email
  expect(in_app_notification.residents.last.email).to eq PlotResidencyFixture.second_email

  expect(ActionMailer::Base.deliveries.count).to eq 2

  first_notification = ActionMailer::Base.deliveries.first
  expect(first_notification).to have_body_text(message)
  expect(first_notification.to).to include CreateFixture.resident.email

  last_notification = ActionMailer::Base.deliveries.last
  expect(last_notification).to have_body_text(message)
  expect(last_notification.to).to include PlotResidencyFixture.second_email

  ActionMailer::Base.deliveries.clear
end

When(/^I update the completion date for the plot$/) do
  plot = CreateFixture.phase_plot
  visit "/plots/#{plot.id}?active_tab=completion"

  within ".edit_plot" do
    fill_in "plot_completion_date", with: PlotFixture.completion_date
  end

  check :plot_notify
  click_on t("edit.submit")
end

When(/^I update the release dates$/) do
  plot = Plot.find_by(number: PhasePlotFixture.plot_number.to_i + 1)
  visit "/plots/#{plot.id}/edit"

  within ".edit_plot" do
    fill_in :plot_reservation_release_date, with: PlotFixture.reservation_release_date
    fill_in :plot_completion_release_date, with: PlotFixture.completion_release_date
    fill_in :plot_validity, with: 20
    fill_in :plot_extended_access, with: 2
  end

  click_on t("plots.form.submit")
end

Then(/^I should see the expiry date has been updated$/) do
  expiry_date = Time.zone.today.advance(months: 20).advance(months: 2).strftime("%d %B %Y")

  within ".about" do
    expect(page).to have_content " Expiry Date: #{expiry_date}"
  end
end

Given(/^there is a second resident$/) do
  phase_plot = CreateFixture.phase_plot
  resident = FactoryGirl.create(:resident, :activated, email: PlotResidencyFixture.second_email)
  FactoryGirl.create(:plot_residency, resident_id: resident.id, plot_id: phase_plot.id)
end

Then(/^I can not create a plot$/) do
  goto_phase_show_page

  within ".phase" do
    expect(page).not_to have_selector(".section-actions .fa-plus")
    expect(page).not_to have_content(t("plots.collection.add"))
  end
end

Then(/^I can not edit a plot$/) do
  within ".plots" do
    edit_links = page.all("[data-action='edit']")
    expect(edit_links.count).to eq 0
  end

  within ".record-list" do
    click_on CreateFixture.phase_plot_name
    find(:xpath, "//div[contains(text(),'Plot #{CreateFixture.phase_plot_name}')]")
  end

  find(".tabs").click_on "Documents"
  find(:xpath, "//a[@class='active'][text()[contains(.,'Documents')]]")
  within ".plot" do
    edit_links = page.all("[data-action='edit']")
    expect(edit_links.count).to eq 0
  end
end

Then(/^I can update the completion date for a plot$/) do
  within ".tabs" do
    click_on t("plots.collection.completion")
  end

  within ".edit_plot" do
    fill_in "plot_completion_date", with: PlotFixture.completion_date
  end

  within ".row-item" do
    click_on t("edit.submit")
  end
end

Then(/^the completion date has been set$/) do
  success_flash = t("plots.update.success.one", plot_name: CreateFixture.phase_plot_name )

  within ".notice" do
    expect(page).to have_content(success_flash)
  end

  within ".section-header" do
    expect(page).to have_content Time.zone.today.advance(days: 7).to_date.strftime("%d %B %Y")
  end
end

Then(/^I can not update the completion date for a plot$/) do
  within ".tabs" do
    expect(page).not_to have_content t("plots.collection.completion")
  end
end

Then(/^I can not update the progress for a plot$/) do
  within ".tabs" do
    expect(page).not_to have_content t("phases.collection.progresses")
  end
end

When(/^I create a plot with prefix and copy plot numbers$/) do
  phase = PhasePlotFixture.phase
  visit "/phases/#{phase.id}/plots/new"

  within ".new_plot" do
    select PhasePlotFixture.unit_type_name, visible: false
    fill_in :plot_list, with: PhasePlotFixture.prefix_plot_number
    fill_in :plot_prefix, with: "Flat"
    checkbox = page.find("#plot_copy_plot_numbers")
    checkbox.set(true)

    click_on t("plots.form.submit")
  end
end

Then(/^I should see the postal number inherit from the plot number$/) do
  within ".plots" do
    click_on "Plot #{PhasePlotFixture.prefix_plot_number}"
  end

  within ".plot" do
    expect(page).to have_content "Flat #{PhasePlotFixture.prefix_plot_number}"
  end
end

When(/^I edit a plot with prefix and postal number$/) do
  within ".section-data" do
    find("[data-action='edit']").click
  end

  within ".edit_plot" do
    fill_in :plot_house_number, with: PhasePlotFixture.prefix_postal_number
  end

  click_on t("plots.form.submit")
end

Then(/^the postal number should not inherit from the plot number$/) do

  within ".plot" do
    within ".section-data" do
      expect(page).to have_content "Flat #{PhasePlotFixture.prefix_postal_number}"
      expect(page).not_to have_content PhasePlotFixture.prefix_plot_number
    end
  end
end

When(/^I create plots for the phase$/) do
  phase = PhasePlotFixture.phase
  visit "/phases/#{phase.id}/plots/new"

  within ".new_plot" do
    select PhasePlotFixture.unit_type_name, visible: false
    fill_in :plot_list, with: "1~11"
    check :plot_copy_plot_numbers

    click_on t("plots.form.submit")
  end
end

Then(/^I should see the plots have been created$/) do
  success_flash = "Plots 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, and 11 were created successfully"

  expect(page).to have_content(success_flash)
end

Then(/^the plots should have the postal number configured$/) do
  within ".plots" do
    plot = Plot.find_by(number: "11")
    find("[href='/plots/#{plot.id}']").trigger('click')
  end

  within ".section-data" do
    expect(page).to have_content "11"
  end
end

When(/^I update the order numbers$/) do
  within ".section-data" do
    find("[data-action='edit']").click
  end
  within ".res-order-number" do
    fill_in :plot_reservation_order_number, with: "RES01"
  end
  within ".comp-order-number" do
    fill_in :plot_completion_order_number, with: "COMP01"
  end
  within ".form-actions-footer" do
    click_on t("plots.form.submit")
  end
end

Then(/^I should see the order numbers have been updated$/) do
  within ".section-data" do
    find("[data-action='edit']").click
  end
  within ".res-order-number" do
    expect(find_field("plot_reservation_order_number").value).to eq "RES01"
  end
  within ".comp-order-number" do
    expect(find_field("plot_completion_order_number").value).to eq "COMP01"
  end
  within ".form-actions-footer" do
    click_on t("plots.form.submit")
  end
end
