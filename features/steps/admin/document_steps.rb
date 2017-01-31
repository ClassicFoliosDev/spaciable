# frozen_string_literal: true
When(/^I upload a document for the developer$/) do
  visit "/"

  within ".navbar" do
    click_on t("components.navigation.developers")
  end

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
  within ".documents" do
    attach_file("document_file",
                File.absolute_path(document_full_path),
                visible: false)
    fill_in "document_title", with: DocumentFixture.document_name
  end

  click_on t("documents.form.submit")
end

Then(/^I should see the created document$/) do
  within ".documents" do
    expect(page).to have_content(DocumentFixture.document_name)
  end

  within ".breadcrumbs" do
    expect(page).to have_content(CreateFixture.developer_name)
  end
end

And(/^I should see the original filename$/) do
  within ".documents" do
    click_on DocumentFixture.document_name
  end

  within ".documents" do
    expect(page).to have_content(FileFixture.document_name)
    expect(page).to have_content(DocumentFixture.document_name)
    # Wasn't set explicitly, but current behaviour will default it
    expect(page).to have_content(t("activerecord.attributes.document.categories.homeowner_manual"))
  end
end

When(/^I update the developer's document$/) do
  visit "/documents"

  within ".documents" do
    find("[data-action='edit']").click
  end

  fill_in "document_title", with: DocumentFixture.updated_document_name

  select_from_selectmenu :document_category, with: t("activerecord.attributes.document.categories.insurance_warranty")

  click_on t("developers.form.submit")
end

Then(/^I should see the updated document$/) do
  success_flash = t(
    "controller.success.update",
    name: DocumentFixture.updated_document_name
  )
  expect(page).to have_content(success_flash)

  # No developer in the breadcrumbs for documents index
  within ".breadcrumbs" do
    expect(page).not_to have_content(CreateFixture.developer_name)
  end

  # On the list page
  within ".documents" do
    click_on DocumentFixture.updated_document_name
  end

  # On the show page
  within ".documents" do
    expect(page).to have_content(FileFixture.document_name)
    expect(page).to have_content(DocumentFixture.updated_document_name)
    expect(page).not_to have_content DocumentFixture.document_name
    expect(page).to have_content(t("activerecord.attributes.document.categories.insurance_warranty"))
    expect(page).not_to have_content(t("activerecord.attributes.document.categories.homeowner_manual"))
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

  click_on t("documents.collection.add")

  document_full_path = FileFixture.file_path + FileFixture.document_name

  within ".documents" do
    fill_in "document_title", with: DocumentFixture.second_document_name
    attach_file("document_file",
                File.absolute_path(document_full_path),
                visible: false)
  end

  click_on t("developments.form.submit")
end

Then(/^I should see the document in the developer document list$/) do
  within ".record-list" do
    expect(page).to have_content DocumentFixture.updated_document_name
    expect(page).to have_content DocumentFixture.second_document_name
  end
end

When(/^I delete the document$/) do
  visit "/documents"

  delete_and_confirm!(finder_options: { match: :first })
end

Then(/^I should see that the deletion was successful for the document$/) do
  success_flash = t(
    "controller.success.destroy",
    name: DocumentFixture.updated_document_name
  )
  expect(page).to have_content(success_flash)

  within ".record-list" do
    expect(page).not_to have_content DocumentFixture.updated_document_name
    expect(page).to have_content(DocumentFixture.second_document_name)
  end
end
