# frozen_string_literal: false

When(/^I upload private documents$/) do
  visit "/homeowners/private_documents"

  document_full_path = FileFixture.file_path + FileFixture.document_name

  within ".new-document" do
    attach_file("private_document_file",
                File.absolute_path(document_full_path),
                visible: false)
  end

  within ".notice" do
    expect(page).to have_content("#{FileFixture.document_alt} was created successfully")
  end

  avatar_full_path = FileFixture.file_path + FileFixture.avatar_name

  within ".new-document" do
    attach_file("private_document_file",
                File.absolute_path(avatar_full_path),
                visible: false)

  end

  within ".notice" do
    expect(page).to have_content("#{FileFixture.avatar_alt} was created successfully")
  end

  manual_full_path = FileFixture.file_path + FileFixture.manual_name

  within ".new-document" do
    attach_file("private_document_file",
                File.absolute_path(manual_full_path),
                visible: false)

  end

  within ".notice" do
    expect(page).to have_content("Washing machine manual was created successfully")
  end
end

Then(/^I should see my private documents$/) do
  within ".private-documents" do
    expect(page).to have_content %r{#{FileFixture.document_alt}}i
    expect(page).to have_content %r{#{FileFixture.avatar_alt}}i
    expect(page).to have_content %r{#{FileFixture.manual_name_alt}}i
  end
end

When(/^I edit a private document$/) do
  manual_document = PrivateDocument.find_by(title: "Washing machine manual")

  within ".private-document[data-document='#{manual_document.id}']" do
    edit_button = page.find("[data-action='update']")
    edit_button.click
  end

  within ".ui-dialog" do
    fill_in :title, with: "Updated private document"
    click_on t("homeowners.private_documents.edit.submit")
  end
end

Then(/^I should see my updated private document$/) do
  within ".private-documents" do
    expect(page).to have_content %r{#{"Updated private document"}}i
    expect(page).not_to have_content %r{#{FileFixture.manual_name_alt}}i
    expect(page).to have_content %r{#{FileFixture.avatar_alt}}i
  end
end

When(/^I delete a private document$/) do
  document = PrivateDocument.find_by(title: FileFixture.document_alt)
  delete_scope = "[data-document='#{document.id}']"

  delete_and_confirm!(scope: delete_scope)
end

Then(/^I should no longer see the private document$/) do
  within ".private-documents" do
    expect(page).not_to have_content %r{#{FileFixture.document_alt}}i
    expect(page).to have_content %r{#{FileFixture.avatar_alt}}i
    expect(page).to have_content %r{#{FileFixture.manual_name_alt}}i
  end
end

Given(/^there is another tenant on the homeowner plot$/) do
  plot = Plot.find_by(number: HomeownerUserFixture.plot_number)

  tenant = FactoryGirl.create(:resident,
                              :with_tenancy,
                              plot: plot,
                              email: "tenant@example.com",
                              developer_email_updates: true,
                              ts_and_cs_accepted_at: Time.zone.now)
end

When(/^I share a private document with tenants$/) do
  visit "/homeowners/private_documents"

  document = PrivateDocument.find_by(title: "Avatar girl face")

  within "[data-document='#{document.id}']" do
    permission_circle = page.find(".document-permission")
    permission_circle.trigger('click')
  end
end

Then(/^I should see the private document has been shared$/) do
  plot = Plot.find_by(number: HomeownerUserFixture.plot_number)

  success_message = t("homeowners.private_documents.update.shared", title: FileFixture.avatar_alt, address: plot.to_homeowner_s)

  within ".flash" do
    expect(page).to have_content success_message
  end
end

Then(/^I should see the shared private document$/) do
  visit "/homeowners/private_documents"

  within ".private-documents" do
    expect(page).not_to have_content %r{#{"Updated private document"}}i
    expect(page).not_to have_content %r{#{FileFixture.manual_name_alt}}i
    expect(page).to have_content %r{#{FileFixture.avatar_alt}}i
  end
end
