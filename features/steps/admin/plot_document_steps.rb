# frozen_string_literal: true

When(/^I upload a document using (\w+) plot$/) do |plot_name|
  click_on(t("developments.collection.plot_documents"))

  document_number = CreateFixture.send(plot_name)
  document_name = PlotDocumentFixture.send("document#{document_number}")

  within ".upload" do
    select PlotDocumentFixture.category, from: :document_category, visible: false
  end

  plot_document_path = FileFixture.file_path + document_name
  within ".upload" do
    attach_file("document_files",
                File.absolute_path(plot_document_path),
                visible: false)
  end

  check :document_notify

  click_on(t("plot_documents.form.upload_all"))
end

Then(/^I should see the created (\w+) plot document$/) do |plot_name|
  notice = t("plot_documents.bulk_upload.success", matched: 1)
  notice << t("resident_notification_mailer.notify.update_sent", count: Resident.all.count)
  expect(page).to have_content(notice)

  document_number = CreateFixture.send(plot_name)
  document_name = PlotDocumentFixture.send("document#{document_number}")

  within ".record-list" do
    expect(page).to have_content(document_name)
    expect(page).to have_content(document_number)
    expect(page).to have_content(PlotDocumentFixture.category)
  end
end

When(/^I upload a document (\w+) that does not match a plot$/) do |plot_name|
  click_on(t("developments.collection.plot_documents"))

  within ".upload" do
    select PlotDocumentFixture.category2, from: :document_category, visible: false
  end

  document_number = CreateFixture.send(plot_name)
  document_name = PlotDocumentFixture.send("document#{document_number}10")
  plot_document_path = FileFixture.file_path + document_name

  within ".upload" do
    attach_file("document_files",
                File.absolute_path(plot_document_path),
                visible: false)
  end
  click_on(t("plot_documents.form.upload_all"))
  sleep 0.5
end

Then(/^I should see a (\w+) plot document error$/) do |plot_name|
  document_number = CreateFixture.send(plot_name)
  document_name = PlotDocumentFixture.send("document#{document_number}10")
  notice = t("plot_documents.bulk_upload.failure", unmatched: document_name)
  find(".alert").has_content?(notice)

  within ".record-list" do
    expect(page).not_to have_content(document_name)
  end
end

When(/^I navigate to the phase$/) do
  visit "/"
  goto_phase_show_page
end

Given(/^I should see the number of private documents$/) do
  documents_string = t("developments.development.private_documents")
  documents_string << "2"

  within ".section-title" do
    expect(page).to have_content(documents_string)
  end
end

When(/^I upload a document and rename it$/) do
  click_on(t("developments.collection.plot_documents"))

  within ".upload" do
    select PlotDocumentFixture.category2, from: :document_category, visible: false
  end

  document_number = CreateFixture.plot_name
  document_name = PlotDocumentFixture.send("document#{document_number}")
  plot_document_path = FileFixture.file_path + document_name

  within ".upload" do
    attach_file("document_files",
                File.absolute_path(plot_document_path),
                visible: false)
  end

  within ".upload" do
    fill_in "rename_text", with: PlotDocumentFixture.rename_text
  end
  click_on(t("plot_documents.form.upload_rename"))
end

Then(/^I should see the renamed document$/) do
  within ".record-list" do
    expect(page).to have_content(PlotDocumentFixture.rename_text)
  end
end

Then(/^I should see the document resident has been notified$/) do
  in_app_notification = Notification.all.last
  expect(in_app_notification.residents.count).to eq 1
  expect(in_app_notification.residents.first.email).to eq CreateFixture.resident.email

  email = ActionMailer::Base.deliveries.first
  expect(email).to have_body_text("The following document has been added to your home's online portal:")
  expect(email).to have_body_text("Plot 200 homeowner manual.pdf")
  expect(email.to).to eq [CreateFixture.resident_email]

  ActionMailer::Base.deliveries.clear
end

Given(/^I have selected (\d+) documents per page$/) do |arg1|
  within ".page-sizes" do
    click_on "10"
  end
end

When(/^I edit a plot document$/) do
  @this_path = URI.parse(current_url).path
  within ".actions" do
    find("[data-action='edit']").click
  end

  within ".document_title" do
    fill_in "document_title", with: PlotDocumentFixture.rename_text
  end

  within ".form-actions-footer" do
    click_on t("documents.form.submit")
  end
end

Then(/^I should be redirected to the plot document page$/) do
  expect(current_path).to eq(@this_path)
  expect(page).to have_content t("plot_documents.form.title")
end

Then(/^the plot document should be updated$/) do
  within ".record-list" do
    expect(page).to have_content PlotDocumentFixture.rename_text
    expect(page).to_not have_content PlotDocumentFixture.document200
  end
end

When(/^I delete a plot document$/) do
  within ".actions" do
    find("[data-action='delete']").click
  end
  within ".ui-dialog-buttonset" do
    click_on "Delete"
  end
end

Then(/^the plot document should be deleted$/) do
  within ".record-list" do
    expect(page).to_not have_content PlotDocumentFixture.rename_text
  end
end
