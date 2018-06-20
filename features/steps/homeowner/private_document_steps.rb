# frozen_string_literal: false

When(/^I upload private documents$/) do
  visit "/homeowners/private_documents"

  document_full_path = FileFixture.file_path + FileFixture.document_name
  avatar_full_path = FileFixture.file_path + FileFixture.avatar_name

  within ".new-document" do
    attach_file("private_document_file",
                File.absolute_path(document_full_path),
                visible: false)
  end

  within ".notice" do
    expect(page).to have_content("#{FileFixture.document_alt} was created successfully")
  end

  within ".new-document" do
    attach_file("private_document_file",
                File.absolute_path(avatar_full_path),
                visible: false)

  end

  within ".notice" do
    expect(page).to have_content("#{FileFixture.avatar_alt} was created successfully")
  end
end

Then(/^I should see my private documents$/) do
  within ".private-documents" do
    expect(page).to have_content %r{#{FileFixture.document_alt}}i
    expect(page).to have_content %r{#{FileFixture.avatar_alt}}i
  end
end

When(/^I edit a private document$/) do
  within ".private-document" do
    edit_button = page.find("[data-action='update']")
    edit_button.click
  end

  within ".ui-dialog" do
    fill_in :title, with: FileFixture.logo_alt
    click_on t("homeowners.private_documents.edit.submit")
  end
end

Then(/^I should see my updated private document$/) do
  within ".private-documents" do
    expect(page).to have_content %r{#{FileFixture.logo_alt}}i
    expect(page).not_to have_content %r{#{FileFixture.avatar_alt}}i
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
  end
end
