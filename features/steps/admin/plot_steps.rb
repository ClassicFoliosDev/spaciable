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

  within ".above-footer" do
    click_on t("plots.show.preview")
  end
end

Then(/^I see the plot preview page$/) do
  sleep 0.3

  within_frame("rails_iframe") do
    expect(page).to have_content(t("layouts.homeowner.nav.dashboard"))
    expect(page).to have_content(t("layouts.homeowner.nav.my_home"))
    expect(page).to have_content(t("layouts.homeowner.nav.how_to"))
    expect(page).to have_content(t("layouts.homeowner.nav.contacts"))

    expect(page).to have_content(t("homeowners.dashboard.show.my_home_title"))
    expect(page).to have_content(t("homeowners.components.address.my_home_view_more"))

    expect(page).to have_content(PhaseFixture.address_update_attrs[:building_name])
    expect(page).to have_content(PhaseFixture.address_update_attrs[:road_name])
    expect(page).to have_content(PhaseFixture.address_update_attrs[:postcode])

    expect(page).to have_content(t("homeowners.dashboard.show.contacts_title"))
    expect(page).to have_content(t("homeowners.dashboard.show.contacts_view_more"))

    expect(page).to have_content(t("homeowner.dashboard.cards.faqs.title"))
    expect(page).to have_content(t("homeowner.dashboard.cards.faqs.view_more"))
  end
end

Then(/^I can see my library$/) do
  within_frame("rails_iframe") do
    click_on t("homeowner.dashboard.cards.library.view_more")
  end

  sleep 0.2
  within_frame("rails_iframe") do
    expect(page).to have_content %r{#{t("components.homeowner.library_hero.title")}}i
  end
end

Then(/^I can see my appliances$/) do
  within_frame("rails_iframe") do
    click_on t("layouts.homeowner.sub_nav.rooms")
  end

  sleep 0.2
  within_frame("rails_iframe") do
    expect(page).to have_content %r{#{PhaseFixture.address_update_attrs[:building_name]}}i
    expect(page).to have_content %r{#{PhaseFixture.address_update_attrs[:road_name]}}i
    expect(page).to have_content PhaseFixture.address_update_attrs[:postcode]
  end
end

Then(/^I can see my contacts$/) do
  within_frame("rails_iframe") do
    click_on t("layouts.homeowner.nav.contacts")
  end

  sleep 0.2
  within_frame("rails_iframe") do
    expect(page).to have_content %r{#{t("homeowners.contacts.index.title")}}i
  end
end

Then(/^I can see my faqs$/) do
  within_frame("rails_iframe") do
    click_on t("layouts.homeowner.sub_nav.faqs")
  end

  sleep 0.2
  within_frame("rails_iframe") do
    expect(page).to have_content %r{#{t("homeowners.faqs.index.title")}}i
  end
end

When(/^I send a notification the phase$/) do
  ActionMailer::Base.deliveries.clear
  visit "/admin/notifications/new"

  within ".send-targets" do
    within ".developer-id" do
      select_from_selectmenu(:notification_developer_id, with: PhasePlotFixture.developer_name)
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
end

Then(/^I should see the notification is not sent to the former resident$/) do
  within ".notice" do
    expect(page).to have_content("Sending notifications to residents")
  end

  emails = ActionMailer::Base.deliveries
  expect(emails.length).to be_zero
end

When(/^I update the progress for the plot$/) do
  goto_phase_plot_show_page

  within ".tabs" do
    click_on t("plots.collection.progress")
  end

  within ".edit_plot" do
    select_from_selectmenu :plot_progress, with: PhaseFixture.progress
  end

  within ".above-footer" do
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
  message = "has been updated to Ready for exchange"

  in_app_notification = Notification.all.last
  expect(in_app_notification.residents.count).to eq 2
  expect(in_app_notification.residents.first.email).to eq CreateFixture.resident.email
  expect(in_app_notification.residents.last.email).to eq PlotResidencyFixture.second_email
  expect(in_app_notification.message).to include message

  expect(ActionMailer::Base.deliveries.count).to eq 2

  first_notification = ActionMailer::Base.deliveries.first
  expect(first_notification.parts.first.body.raw_source).to include message
  expect(first_notification.to).to include CreateFixture.resident.email

  last_notification = ActionMailer::Base.deliveries.last
  expect(last_notification.parts.first.body.raw_source).to include message
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
  within ".record-list" do
    find("[data-action='edit']").click
  end

  within ".edit_plot" do
    fill_in :plot_reservation_release_date, with: PlotFixture.reservation_release_date
    fill_in :plot_completion_release_date, with: PlotFixture.completion_release_date
    fill_in :plot_validity, with: 20
    fill_in :plot_extended_access, with: 2
  end

  click_on t("plots.form.submit")
end

Then(/^I should see the expiry date has been updated$/) do
  expiry_date = Time.zone.today.advance(months: 22).strftime("%d %B %Y")

  within ".about" do
    expect(page).to have_content " Expiry date: #{expiry_date}"
  end
end

Then(/^both residents have been notified of the completion date$/) do
  message = "has been updated for your home"

  in_app_notification = Notification.all.last
  expect(in_app_notification.residents.count).to eq 2
  expect(in_app_notification.residents.first.email).to eq CreateFixture.resident.email
  expect(in_app_notification.residents.last.email).to eq PlotResidencyFixture.second_email
  expect(in_app_notification.message).to include message

  first_notification = ActionMailer::Base.deliveries.first
  expect(first_notification.parts.first.body.raw_source).to include message
  expect(first_notification.to).to include CreateFixture.resident.email

  last_notification = ActionMailer::Base.deliveries.last
  expect(last_notification.parts.first.body.raw_source).to include message
  expect(last_notification.to).to include PlotResidencyFixture.second_email

  ActionMailer::Base.deliveries.clear
end

Given(/^there is a second resident$/) do
  phase_plot = CreateFixture.phase_plot
  resident = FactoryGirl.create(:resident, :activated, email: PlotResidencyFixture.second_email)
  FactoryGirl.create(:plot_residency, resident_id: resident.id, plot_id: phase_plot.id)
end

Then(/^I can not create a plot$/) do
  goto_phase_show_page

  within ".phase" do
    expect(page).not_to have_selector(".section-actions")
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
  end

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

  within ".above-footer" do
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

When(/^I create a plot with prefix$/) do
  phase = PhasePlotFixture.phase
  visit "/phases/#{phase.id}/plots/new"

  within ".new_plot" do
    select PhasePlotFixture.unit_type_name, visible: false
    fill_in :plot_list, with: PhasePlotFixture.prefix_plot_number
    fill_in :plot_prefix, with: "Flat"

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

   click_on t("plots.form.submit")
  end
end

Then(/^the postal number should not inherit from the plot number$/) do
  within ".plot" do
    within ".section-data" do
      expect(page).to have_content "Flat #{PhasePlotFixture.prefix_postal_number}"
      expect(page).not_to have_content PhasePlotFixture.prefix_plot_number
    end
  end
end
