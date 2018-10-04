# frozen_string_literal: true

When(/^I upload a document for the developer$/) do
  visit "/developers"

  within ".developers" do
    click_on CreateFixture.developer_name
  end

  within ".tabs" do
    click_on t("developers.collection.documents")
  end

  within ".empty" do
    click_on t("components.empty_list.add", type_name: Document.model_name.human.downcase)
  end

  document_full_path = FileFixture.file_path + FileFixture.document_name
  within ".documents" do
    attach_file(:document_files,
                File.absolute_path(document_full_path),
                visible: false)
  end

  click_on t("documents.form.submit")
end

Then(/^I should see the created document$/) do
  within ".documents" do
    expect(page).to have_content(DocumentFixture.document_name_alt)
  end
end

And(/^I should see the original filename$/) do
  within ".documents" do
    click_on DocumentFixture.document_name_alt
  end

  within ".document" do
    expect(page).to have_content(DocumentFixture.document_name_alt)
    # Wasn't set explicitly, but current behaviour will default it
    expect(page).to have_content(t("activerecord.attributes.document.categories.my_home"))
  end
end

And(/^I should see who uploaded the file$/) do
  within ".document" do
    expect(page).to have_content(CreateFixture.development_admin)
  end
end

When(/^I update the developer's document$/) do
  click_on(t("developers.show.back"))

  within ".documents" do
    find("[data-action='edit']").click
  end

  within ".edit_document" do
    fill_in "document_title", with: DocumentFixture.updated_document_name
    select_from_selectmenu :document_category, with: t("activerecord.attributes.document.categories.legal_and_warranty")

    click_on t("developers.form.submit")
  end
end

Then(/^I should see the updated (\w+) document$/) do |parent_type|
  parent_name = CreateFixture.send("#{parent_type}_name")

  success_flash = t(
    "controller.success.update",
    name: DocumentFixture.updated_document_name
  )
  within ".notice" do
    expect(page).to have_content(success_flash)
  end

  within ".breadcrumbs" do
    expect(page).to have_content(parent_name)
  end

  # On the list page
  within ".documents" do
    click_on DocumentFixture.updated_document_name
  end

  # On the show page
  within ".document" do
    expect(page).to have_content(DocumentFixture.updated_document_name)
    expect(page).not_to have_content DocumentFixture.document_name
    expect(page).to have_content(t("activerecord.attributes.document.categories.legal_and_warranty"))
    expect(page).not_to have_content(t("activerecord.attributes.document.categories.my_home"))
  end
end

When(/^I create another document$/) do
  visit "/developers"

  within ".developers" do
    click_on CreateFixture.developer_name
  end

  within ".tabs" do
    click_on t("developers.collection.documents")
  end

  within ".section-actions" do
    click_on t("documents.collection.add")
  end

  document_full_path = FileFixture.file_path + FileFixture.document_name

  within ".new_document" do
    attach_file(:document_files,
                File.absolute_path(document_full_path),
                visible: false)

    click_on t("developments.form.submit")
  end
end

Then(/^I should see the document in the developer document list$/) do
  within ".documents" do
    expect(page).to have_content DocumentFixture.document_name_alt
    click_on DocumentFixture.document_name_alt
  end

  within ".document" do
    expect(page).to have_content DocumentFixture.document_name_alt
  end
end

When(/^I delete the document$/) do
  within ".form-actions-footer" do
    click_on t("documents.form.back")
  end

  document_id = DocumentFixture.updated_document_id
  delete_and_confirm!(scope: "[data-document='#{document_id}']")
end

Then(/^I should see that the deletion was successful for the developer document$/) do
  success_flash = t(
    "controller.success.destroy",
    name: DocumentFixture.updated_document_name
  )
  expect(page).to have_content(success_flash)

  within ".documents" do
    expect(page).not_to have_content DocumentFixture.updated_document_name
    expect(page).to have_content(DocumentFixture.document_name_alt)
  end
end

Then(/^I should see that the deletion was successful for the document$/) do
  success_flash = t(
    "controller.success.destroy",
    name: DocumentFixture.updated_document_name
  )
  expect(page).to have_content(success_flash)

  expect(page).not_to have_content(".documents")

  within ".empty" do
    expect(page).to have_content t("components.empty_list.add", type_name: Document.model_name.human.downcase)
  end
end

When(/^I upload a document for the division$/) do
  division = CreateFixture.division
  visit "/developers/#{division.developer.id}/divisions/#{division.id}?active_tab=documents"

  within ".empty" do
    click_on t("components.empty_list.add", type_name: Document.model_name.human.downcase)
  end

  document_full_path = FileFixture.file_path + FileFixture.document_name
  within ".new_document" do
    attach_file(:document_files,
                File.absolute_path(document_full_path),
                visible: false)

    click_on t("documents.form.submit")
  end
end

When(/^I upload a document for the development$/) do
  goto_development_show_page

  within ".tabs" do
    click_on t("developments.collection.documents")
  end

  within ".empty" do
    click_on t("components.empty_list.add", type_name: Document.model_name.human.downcase)
  end

  document_full_path = FileFixture.file_path + FileFixture.document_name
  within ".new_document" do
    attach_file(:document_files,
                File.absolute_path(document_full_path),
                visible: false)

    click_on t("documents.form.submit")
  end
end

When(/^I upload a document for the division development$/) do
  development = CreateFixture.division_development
  visit "/divisions/#{development.division.id}/developments/#{development.id}?active_tab=documents"

  within ".empty" do
    click_on t("components.empty_list.add", type_name: Document.model_name.human.downcase)
  end

  document_full_path = FileFixture.file_path + FileFixture.document_name
  within ".new_document" do
    attach_file(@document_files,
                File.absolute_path(document_full_path),
                visible: false)

    click_on t("documents.form.submit")
  end
end

When(/^I upload a document for the phase$/) do
  goto_phase_show_page

  within ".phase" do
    click_on t("developments.collection.documents")
  end

  within ".empty" do
    click_on t("components.empty_list.add", type_name: Document.model_name.human.downcase)
  end

  document_full_path = FileFixture.file_path + FileFixture.document_name
  within ".new_document" do
    attach_file(:document_files,
                File.absolute_path(document_full_path),
                visible: false)
  end

  click_on t("documents.form.submit")
end

When(/^I upload a document for the unit type$/) do
  unit_type = CreateFixture.unit_type
  visit "/developments/#{unit_type.development.id}/unit_types/#{unit_type.id}"

  within ".unit-type" do
    click_on t("components.empty_list.add", type_name: Document.model_name.human.downcase)
  end

  document_full_path = FileFixture.file_path + FileFixture.document_name
  within ".new_document" do
    attach_file(:document_files,
                File.absolute_path(document_full_path),
                visible: false)

    click_on t("documents.form.submit")
  end
end

When(/^I upload a document for the division phase$/) do
  goto_division_development_show_page

  within ".tabs" do
    click_on t("developments.collection.phases")
  end

  within ".phases" do
    click_on CreateFixture.division_phase_name
  end

  within ".phase" do
    click_on t("developments.collection.documents")
  end

  within ".empty" do
    click_on t("components.empty_list.add", type_name: Document.model_name.human.downcase)
  end

  document_full_path = FileFixture.file_path + FileFixture.document_name
  within ".new_document" do
    attach_file(:document_files,
                File.absolute_path(document_full_path),
                visible: false)

    click_on t("documents.form.submit")
  end
end

When(/^I upload a document for the division plot$/) do
  goto_division_development_show_page

  within ".tabs" do
    click_on t("developments.collection.plots")
  end

  within ".plots" do
    click_on CreateFixture.division_plot_name
  end

  within ".empty" do
    click_on t("components.empty_list.add", type_name: Document.model_name.human.downcase)
  end

  document_full_path = FileFixture.file_path + FileFixture.document_name
  within ".new_document" do
    attach_file(:document_files,
                File.absolute_path(document_full_path),
                visible: false)

    click_on t("documents.form.submit")
  end
end

When(/^I upload a document for the division phase plot$/) do
  plot = Plot.find_by(number: CreateFixture.phase_plot_name)
  visit "/plots/#{plot.id}?active_tab=documents"

  within ".empty" do
    click_on t("components.empty_list.add", type_name: Document.model_name.human.downcase)
  end

  document_full_path = FileFixture.file_path + FileFixture.document_name
  within ".new_document" do
    attach_file(:document_files,
                File.absolute_path(document_full_path),
                visible: false)

    click_on t("documents.form.submit")
  end
end

When(/^I upload a document for the phase plot$/) do
  goto_phase_show_page

  within ".phase" do
    click_on t("phases.collection.plots")
  end

  plots = Plot.where(phase_id: CreateFixture.phase.id)
  within ".plots" do
    click_on plots.first
  end

  within ".empty" do
    click_on t("components.empty_list.add", type_name: Document.model_name.human.downcase)
  end

  document_full_path = FileFixture.file_path + FileFixture.document_name
  within ".new_document" do
    attach_file(:document_files,
                File.absolute_path(document_full_path),
                visible: false)

    click_on t("documents.form.submit")
  end
end

When(/^I update the document$/) do
  within ".section-data" do
    find("[data-action='edit']").click
  end

  within ".edit_document" do
    fill_in "document_title", with: DocumentFixture.updated_document_name
    select_from_selectmenu :document_category, with: t("activerecord.attributes.document.categories.legal_and_warranty")

    check :document_notify
    click_on t("developers.form.submit")
  end
end

Then(/^I should see the updated document for the plot$/) do
  success_flash = t(
    "controller.success.update",
    name: DocumentFixture.updated_document_name
  )
  success_flash << t("resident_notification_mailer.notify.update_sent", count: 0)
  expect(page).to have_content(success_flash)

  within ".breadcrumbs" do
    expect(page).to have_content(CreateFixture.plot_name)
  end

  # On the list page
  within ".documents" do
    click_on DocumentFixture.updated_document_name
  end

  # On the show page
  within ".document" do
    expect(page).to have_content(DocumentFixture.updated_document_name)
    expect(page).not_to have_content DocumentFixture.document_name
    expect(page).to have_content(t("activerecord.attributes.document.categories.legal_and_warranty"))
    expect(page).not_to have_content(t("activerecord.attributes.document.categories.my_home"))
  end
end

Then(/^I should see the updated document for the phase plot$/) do
  success_flash = t(
    "controller.success.update",
    name: DocumentFixture.updated_document_name
  )
  expect(page).to have_content(success_flash)

  within ".breadcrumbs" do
    expect(page).to have_content(CreateFixture.phase_plot_name)
  end

  # On the list page
  within ".documents" do
    click_on DocumentFixture.updated_document_name
  end

  # On the show page
  within ".document" do
    expect(page).to have_content(DocumentFixture.updated_document_name)
    expect(page).not_to have_content DocumentFixture.document_name
    expect(page).to have_content(t("activerecord.attributes.document.categories.legal_and_warranty"))
    expect(page).not_to have_content(t("activerecord.attributes.document.categories.my_home"))
  end
end

Then(/^I should not see the bulk uploads tab$/) do
  within ".tabs" do
    expect(page).not_to have_content(t("developments.collection.plot_documents"))
    expect(page).to have_content(t("developments.collection.documents"))
  end
end

When(/^I navigate to the division phase$/) do
  phase = CreateFixture.division_phase
  visit "/developments/#{phase.development.id}/phases/#{phase.id}"
end

When(/^I upload an image for the phase plot$/) do
  goto_phase_show_page

  within ".phase" do
    click_on t("phases.collection.plots")
  end

  plots = Plot.where(phase_id: CreateFixture.phase.id)
  within ".plots" do
    click_on plots.first
  end

  within ".empty" do
    click_on t("components.empty_list.add", type_name: Document.model_name.human.downcase)
  end

  image_full_path = FileFixture.file_path + FileFixture.finish_picture_name
  within ".new_document" do
    attach_file(:document_files,
                File.absolute_path(image_full_path),
                visible: false)

    click_on t("documents.form.submit")
  end
end

Then(/^I should see the created image$/) do
  within ".documents" do
    expect(page).to have_content(FileFixture.finish_picture_alt)
  end
end

Then(/^I should see the created svg image$/) do
  within ".documents" do
    expect(page).to have_content(FileFixture.svg_picture_alt)
  end
end

When(/^I update the image name$/) do
  click_on(t("developers.show.back"))

  within ".documents" do
    find("[data-action='edit']").click
  end

  within ".edit_document" do
    fill_in "document_title", with: DocumentFixture.updated_document_name
    select_from_selectmenu :document_category, with: t("activerecord.attributes.document.categories.legal_and_warranty")

    click_on t("developers.form.submit")
  end
end

When(/^I upload an svg image for the division phase plot$/) do
  plot = Plot.find_by(number: CreateFixture.phase_plot_name)
  visit "/plots/#{plot.id}?active_tab=documents"

  within ".plot" do
    click_on t("components.empty_list.add", type_name: Document.model_name.human.downcase)
  end

  document_full_path = FileFixture.file_path + FileFixture.svg_picture_name
  within ".new_document" do
    attach_file(:document_files,
                File.absolute_path(document_full_path),
                visible: false)

    click_on t("documents.form.submit")
  end
end

Then(/^only the homeowner should receive a notification$/) do
  emailed_addresses = ActionMailer::Base.deliveries.map(&:to).flatten
  expect(emailed_addresses.count).to eq 1

  expect(emailed_addresses).to include "resident@example.com"
  expect(emailed_addresses).not_to include "tenant@example.com"

  ActionMailer::Base.deliveries.clear
end

Then(/^both homeowner and tenant should receive a notification$/) do
  emailed_addresses = ActionMailer::Base.deliveries.map(&:to).flatten
  expect(emailed_addresses.count).to eq 2

  expect(emailed_addresses).to include "resident@example.com"
  expect(emailed_addresses).to include "tenant@example.com"

  ActionMailer::Base.deliveries.clear
end

When(/^I upload documents for the development$/) do
  development = CreateFixture.development
  url = "/developers/#{development.developer_id}/developments/#{development.id}?active_tab=documents"
  visit url

  within ".empty" do
    click_on t("components.empty_list.add", type_name: Document.model_name.human.downcase)
  end

  document_full_path = FileFixture.file_path + FileFixture.document_name
  manual_full_path = FileFixture.file_path + FileFixture.manual_name

  within ".documents" do
    attach_file(:document_files,
                [File.absolute_path(document_full_path), File.absolute_path(manual_full_path)],
                visible: false)
  end

  click_on t("documents.form.submit")
end

Then(/^I should see the documents have been created$/) do
  within ".documents" do
    expect(page).to have_content DocumentFixture.document_name_alt
    expect(page).to have_content FileFixture.manual_name_downcase
  end
end

When(/^I delete one of the documents$/) do
  document = Document.find_by(title: DocumentFixture.document_name_alt)
  delete_and_confirm!(scope: "[data-document='#{document.id}']")
end

Then(/^I should see that the document has been deleted$/) do
  within ".documents" do
    expect(page).not_to have_content FileFixture.document_name.humanize
    expect(page).to have_content FileFixture.manual_name_downcase
  end
end
