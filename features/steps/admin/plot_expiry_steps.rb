# frozen_string_literal: false

Given(/^there are plots that have expired$/) do
  ExpiryFixture.create_phase
  ExpiryFixture.create_expired_plots
end

Given(/^I am logged in as a cf admin$/) do
  cf_admin = FactoryGirl.create(:cf_admin, email: ExpiryFixture.cf_email, password: ExpiryFixture.cf_password)
  login_as cf_admin
end

Then(/^I do not see a message telling me the plot is expired$/) do
  within ".section-title" do
    expect(page).to_not have_content I18n.t("plots.plot.expiry")
  end
end

Then(/^I can CRUD documents$/) do
  # Add a document
  within ".tabs" do
    click_on t("plots.collection.documents")
  end

  within ".empty" do
    click_on t("components.empty_list.add", action: "Add", type_name: Document.model_name.human.titleize)
  end

  document_full_path = FileFixture.file_path + FileFixture.document_name
  within ".documents" do
    attach_file(:document_files,
                File.absolute_path(document_full_path),
                visible: false)
  end

  click_on t("documents.form.submit")

  # Delete is available
  page.find(".actions").has_css?(".fa-trash")
  # Edit is available
  page.find(".actions").has_css?(".fa-pencil")
  # Add documents is available
  within ".section-actions" do
    expect(page).to have_content I18n.t("documents.collection.add")
  end
end

Then(/^I can update the the build progress of that plot$/) do
  within ".tabs" do
    click_on t("plots.collection.progress")
  end

  select_from_selectmenu :plot_progress, with: PlotFixture.progress

  within ".submit" do
    click_on t("progresses.progress.submit")
  end
end

Then(/^I can update the completion date of that plot$/) do
  within ".tabs" do
    click_on t("plots.collection.completion")
  end

  within ".plot_completion_date" do
    fill_in "plot_completion_date", with: PlotFixture.completion_date
  end

  within ".row-item" do
    click_on t("edit.submit")
  end
end

Then(/^I can add a resident to the plot$/) do
  within ".tabs" do
    click_on t("plots.collection.residents")
  end

  within ".empty" do
    click_on t("components.empty_list.add", action: "Add", type_name: Resident.model_name.human.titleize)
  end

  fill_in "resident_first_name", with: ExpiryFixture.first_name
  fill_in "resident_last_name", with: ExpiryFixture.last_name
  fill_in "resident_email", with: ExpiryFixture.resident_email
  fill_in "resident_phone_number", with: ExpiryFixture.resident_phone_num

  within ".form-actions-footer" do
    click_on t("residents.form.submit")
  end

  within ".section-actions" do
    expect(page).to have_content I18n.t("residents.collection.add")
  end

  # Delete is available
  page.find(".actions").has_css?(".fa-trash")
  # Edit is available
  page.find(".actions").has_css?(".fa-pencil")
end

Then(/^I can preview the plot$/) do
  within ".section-data" do
    expect(page).to have_content I18n.t("plots.show.preview")
  end
end

Given(/^I am logged in as a development admin$/) do
  development_admin = FactoryGirl.create(:development_admin,
                                         permission_level: Development.find_by(name: ExpiryFixture.development_name),
                                         password: ExpiryFixture.admin_password)
  login_as development_admin
end

Given(/^I am on the plot page$/) do
  plot = Plot.find_by(number: ExpiryFixture.plot_number)
  visit "/plots/#{plot.id}"
end

Then(/^I see a message telling me the plot is expired$/) do
  within ".section-title" do
    expect(page).to have_content I18n.t("plots.plot.expiry")
  end
end

Then(/^I can no longer CRUD documents$/) do
  within ".tabs" do
    click_on t("plots.collection.documents")
  end

  # When there are legacy documents, no new documents can be created
  within ".record-list" do
    expect(page).to have_no_css(".section-actions")
    expect(page).to_not have_content I18n.t("documents.collection.add")
    expect(page).to have_content(ExpiryFixture.doc_name)
  end

  # When there are legacy documents, no legacy documents can be edited / deleted
  within ".record-list" do
    expect(page).to have_no_css(".fa-trash")
    expect(page).to have_no_css(".fa-pencil")
  end

  # Going directly to the edit page results in a redirect to show page
  document = Document.find_by(title: ExpiryFixture.doc_name)
  visit "/documents/#{document.id}/edit"
  expect(page).to have_current_path(document_path(id: document.id))
  # The edit button is not available on the show page
  within ".section-data" do
    expect(page).to have_no_css(".fa-pencil")
  end

  # When there are no legacy documents, no new documents can be created
  document.destroy!

  within ".form-actions-footer" do
    click_on I18n.t("documents.show.back")
  end

  within ".main-container" do
    expect(page).to have_content("You have no documents.")
    expect(page).to_not have_content(t("components.empty_list.add", action: "Add", type_name: Document.model_name.human.downcase))
  end
end

Then(/^I can no longer update the build progress of that plot$/) do
  within ".tabs" do
    click_on t("plots.collection.progress")
  end

  expect(page).to have_content I18n.t("components.admin.plot_fields.current_progress")
  expect(page).to have_no_css(".ui-selectmenu-text")
  expect(page).to_not have_content I18n.t("components.admin.plot_fields.update_progress")
  expect(page).to_not have_content I18n.t("progresses.progress.submit")
end

Then(/^I can no longer update the completion date of that plot$/) do
  within ".tabs" do
    click_on t("plots.collection.completion")
  end

  expect(page).to have_content I18n.t("plots.plot.completion_date")
  expect(page).to_not have_content I18n.t("edit.submit")

  within ".plot-completion" do
    expect(page).to have_no_css("#plot_completion_date")
  end
end

Then(/^I can no longer add a resident to the plot$/) do
  within ".tabs" do
    click_on t("plots.collection.residents")
  end

  # When there are legacy residents, no new residents can be created
  within ".plot" do
    expect(page).to have_no_css(".section-actions")
    expect(page).to_not have_content I18n.t("residents.collection.add")
    expect(page).to have_content(ExpiryFixture.first_name)
  end

  # When there are legacy residents, no legacy residents can be edited / deleted
  within ".actions" do
    expect(page).to have_no_css(".fa-trash")
    expect(page).to have_no_css(".fa-pencil")
  end

  # Going directly to the edit page results in a redirect to show page
  resident = Resident.find_by(email: ExpiryFixture.resident_email)
  plot = Plot.find_by(number: ExpiryFixture.plot_number)
  visit "/plots/#{plot.id}/residents/#{resident.id}/edit"
  expect(page).to have_current_path(plot_resident_path(plot_id: plot.id, id: resident.id))
  # The edit button is not available on the show page
  within ".section-data" do
    expect(page).to have_no_css(".fa-pencil")
  end

  # When there are no legacy residents, no new residents can be created
  resident.destroy!

  within ".form-actions-footer" do
    click_on I18n.t("residents.show.back")
  end

  within ".main-container" do
    expect(page).to have_content("You have no residents.")
    expect(page).to_not have_content(t("components.empty_list.add", action: "Add", type_name: Resident.model_name.human.downcase))
  end
end

Then(/^I can no longer preview the plot$/) do
  within ".tabs" do
    click_on t("plots.collection.documents")
  end

  within ".section-data" do
    expect(page).to_not have_content I18n.t("plots.show.preview")
  end
end

Given(/^there are plots that have not expired$/) do
  ExpiryFixture.create_live_plot
end

Given(/^I am on the phase page$/) do
  development = Development.find_by(name: ExpiryFixture.development_name)
  phase = Phase.find_by(name: ExpiryFixture.phase_name)
  visit "/developments/#{development.id}/phases/#{phase.id}"
end

Then(/^I see a message telling me some plots have expired on the phase$/) do
  within ".section-title" do
    expect(page).to have_content(t("phases.phase.partial_expiry_text"))
  end
end

Then(/^I can CRUD contacts$/) do
  # Add a contact
  within ".tabs" do
    click_on t("phases.collection.contacts")
  end

  within ".empty" do
    click_on t("components.empty_list.add", action: "Add", type_name: Contact.model_name.human.titleize)
  end

  within ".contact" do
    fill_in "contact_email", with: ContactFixture.email
    fill_in "contact_organisation", with: ContactFixture.organisation
  end

  click_on t("contacts.form.submit")

  # Delete is available
  page.find(".actions").has_css?(".fa-trash")
  # Edit is available
  page.find(".actions").has_css?(".fa-pencil")
  # Add contact is available
  within ".section-actions" do
    expect(page).to have_content I18n.t("contacts.collection.create")
  end
end

Then(/^I can update the build progress of the phase$/) do
  within ".tabs" do
    click_on t("phases.collection.progresses")
  end

  select_from_selectmenu :progress_all, with: PlotFixture.progress

  within ".form-actions-footer" do
    click_on t("progresses.progress.submit")
  end
end

Then(/^only the live plot will have its build progress updated$/) do
  within ".record-list" do
    expect(page).to have_content(PlotFixture.progress, count: 1)
  end
end

Then(/^I do not see a message telling me the phase is expired$/) do
  within ".section-title" do
    expect(page).to_not have_content(t("phases.phase.expiry"))
  end
end

Then(/^I see a message telling me the phase has expired$/) do
  within ".section-title" do
    expect(page).to have_content(t("phases.phase.expiry_text"))
  end
end

Then(/^I can no longer CRUD contacts$/) do
  within ".tabs" do
    click_on t("phases.collection.contacts")
  end

  # When there are legacy contacts, no new contacts can be created
  within ".record-list" do
    expect(page).to have_no_css(".section-actions")
    expect(page).to_not have_content I18n.t("contacts.collection.create")
    expect(page).to have_content(ContactFixture.organisation)
  end

  # When there are legacy contacts, no legacy documents can be edited / deleted
  within ".record-list" do
    expect(page).to have_no_css(".fa-trash")
    expect(page).to have_no_css(".fa-pencil")
  end

  # Going directly to the edit page results in a redirect to show page
  contact = Contact.find_by(email: ContactFixture.email)
  visit "/contacts/#{contact.id}/edit"
  expect(page).to have_current_path(contact_path(id: contact.id))
  # The edit button is not available on the show page
  within ".section-data" do
    expect(page).to have_no_css(".fa-pencil")
  end

  # When there are no legacy documents, no new documents can be created
  contact.destroy!

  within ".form-actions-footer" do
    click_on I18n.t("contacts.show.back")
  end

  within ".main-container" do
    expect(page).to have_content("You have no contacts.")
    expect(page).to_not have_content(t("components.empty_list.add", action: "Add", type_name: Video.model_name.human.downcase))
  end
end

Then(/^I can no longer update the build progress of the phase$/) do
  within ".tabs" do
    click_on t("phases.collection.progresses")
  end

  # The page will the show progress of two plots, both of which are the default progress
  expect(page).to have_content(t("activerecord.attributes.plot.progresses.soon"), count: 2)

  expect(page).to have_no_css(".ui-selectmenu-text")
  expect(page).to_not have_content I18n.t("progresses.progress.submit")
end

Given(/^I am on the development page$/) do
  division = Division.find_by(division_name: ExpiryFixture.division_name)
  development = Development.find_by(name: ExpiryFixture.development_name)
  visit "/divisions/#{division.id}/developments/#{development.id}"
end

Then(/^I see a message telling me some plots have expired on the development$/) do
  within ".section-title" do
    expect(page).to have_content(t("developments.development.partial_expiry_text"))
  end
end

Then(/^I can CRUD faqs$/) do
  development = Development.find_by(name: ExpiryFixture.development_name)

  development.faq_types.each do |faq_type|
    find(:xpath,"//a[contains(., '#{faq_type.name}')]", visible: all).trigger('click')

    within ".empty" do
      click_on t("components.empty_list.add", action: "Add", type_name: faq_type.name)
    end

    within ".new_faq" do
      fill_in :faq_question, with: ExpiryFixture.faq_title
      fill_in_ckeditor(:faq_answer, with: ExpiryFixture.faq_content)

      select_from_selectmenu :faq_faq_category, with: faq_type.categories.first.name
      check :faq_notify
      click_on t("faqs.form.submit")
    end

    # Delete is available
    page.find(".actions").has_css?(".fa-trash")
    # Edit is available
    page.find(".actions").has_css?(".fa-pencil")
    # Add faq is available
    within ".section-actions" do
      expect(page).to have_content I18n.t("faqs.collection.add", type: faq_type.name)
    end
  end
end

Then(/^I can CRUD videos$/) do
  # Add a video
  within ".tabs" do
    click_on t("developments.collection.videos")
  end

  within ".empty" do
    click_on t("components.empty_list.add", action: "Add", type_name: Video.model_name.human.titleize)
  end

  within ".row" do
    fill_in "video_title", with: VideoFixture.title
    fill_in "video_link", with: VideoFixture.link
  end

  click_on t("rooms.form.submit")

  # Delete is available
  page.find(".actions").has_css?(".fa-trash")
  # Edit is available
  page.find(".actions").has_css?(".fa-pencil")
  # Add video is available
  within ".section-actions" do
    expect(page).to have_content I18n.t("videos.collection.create")
  end
end

Then(/^I do not see a message telling me the development is expired$/) do
  within ".section-title" do
    expect(page).to_not have_content(t("developments.development.expiry"))
  end
end

Then(/^I see a message telling me the development has expired$/) do
  within ".section-title" do
    expect(page).to have_content(t("developments.development.expiry_text"))
  end
end

When(/^I can no longer CRUD faqs$/) do
  development = Development.find_by(name: ExpiryFixture.development_name)
  find(:xpath,"//a[contains(., '#{development.faq_types.first.name}')]", visible: all).trigger('click')

  # When there are legacy faqs, no new faqs can be created
  within ".main-container" do
    expect(page).to have_no_css(".section-actions")
    expect(page).to_not have_content I18n.t("faqs.collection.add")
    expect(page).to have_content(ExpiryFixture.faq_title)
  end

  # When there are legacy faqs, no legacy faqs can be edited / deleted
  within ".actions" do
    expect(page).to have_no_css(".fa-trash")
    expect(page).to have_no_css(".fa-pencil")
  end

  # Going directly to the edit page results in a redirect to show page
  faq = Faq.find_by(question: ExpiryFixture.faq_title)
  visit "/faqs/#{faq.id}/edit"
  expect(page).to have_current_path(faq_path(id: faq.id))
  # The edit button is not available on the show page
  within ".section-data" do
    expect(page).to have_no_css(".fa-pencil")
  end

  # When there are no legacy faqs, no new faqs can be created
  faq.destroy!

  within ".form-actions-footer" do
    click_on I18n.t("faqs.show.back")
  end

  within ".main-container" do
    expect(page).to have_content(t("faqs.collection.empty_list", type: development.faq_types.first.name))
    expect(page).to_not have_content(t("components.empty_list.add", action: "Add", type_name: development.faq_types.first.name))
  end
end

When(/^I can no longer CRUD videos$/) do
  within ".tabs" do
    click_on t("developments.collection.videos")
  end

  # When there are legacy videos, no new videos can be created
  within ".main-container" do
    expect(page).to have_no_css(".section-actions")
    expect(page).to_not have_content I18n.t("videos.collection.create")
    expect(page).to have_content(VideoFixture.link)
  end

  # When there are legacy faqs, no legacy faqs can be edited / deleted
  within ".actions" do
    expect(page).to have_no_css(".fa-trash")
    expect(page).to have_no_css(".fa-pencil")
  end

  # Going directly to the edit page results in a redirect to show page
  video = Video.find_by(link: VideoFixture.link)
  visit "/videos/#{video.id}/edit"
  expect(page).to have_current_path(video_path(id: video.id))
  # The edit button is not available on the show page
  within ".section-data" do
    expect(page).to have_no_css(".fa-pencil")
  end

  # When there are no legacy faqs, no new faqs can be created
  video.destroy!

  within ".form-actions-footer" do
    click_on I18n.t("videos.show.back")
  end

  within ".main-container" do
    expect(page).to have_content("You have no videos.")
    expect(page).to_not have_content(t("components.empty_list.add", action: "Add", type_name: Video.model_name.human.upcase))
  end
end

Given(/^I am on the division page$/) do
  developer = Developer.find_by(company_name: ExpiryFixture.developer_name)
  division = Division.find_by(division_name: ExpiryFixture.division_name)
  visit "/developers/#{developer.id}/divisions/#{division.id}"
end

Then(/^I do not see a message telling me the division is expired$/) do
  within ".section-title" do
    expect(page).to_not have_content(t("divisions.division.expiry"))
  end
end

Given(/^I am logged in as a developer admin$/) do
  developer_admin = FactoryGirl.create(:developer_admin,
                                       permission_level: Developer.find_by(company_name: ExpiryFixture.developer_name),
                                       password: ExpiryFixture.admin_password)
  login_as developer_admin
end

Then(/^I see a message telling me the division has expired$/) do
  within ".section-title" do
    expect(page).to have_content(t("divisions.division.expiry"))
  end
end

Given(/^I am on the developer page$/) do
  developer = Developer.find_by(company_name: ExpiryFixture.developer_name)
  visit "/developers/#{developer.id}"
end

Then(/^I do not see a message telling me the developer is expired$/) do
  within ".section-title" do
    expect(page).to_not have_content(t("developers.developer.expiry"))
  end
end

Then(/^I see a message telling me the developer has expired$/) do
  within ".section-title" do
    expect(page).to have_content(t("developers.developer.expiry_text"))
  end
end

Then(/^I can no longer use the feedback feature$/) do
  within ".header-container" do
    expect(page).to have_no_css(".feedback-container")
  end
end

Then(/^I do not see a message telling me some plots have expired on the division$/) do
  within ".section-title" do
    expect(page).to have_no_css(".partial-expired-text")
  end
end

Then(/^there is a message saying documents will not be visible on expired plots$/) do
  within ".section-actions" do
    click_on I18n.t("documents.collection.add")
  end

  within ".partial-expired-text" do
    expect(page).to have_content("New documents will not be visible to expired plots")
  end

  within ".form-actions-footer" do
    click_on I18n.t("documents.show.back")
  end
end

Then(/^there is a message saying contacts will not be visible on expired plots$/) do
  within ".section-actions" do
    click_on I18n.t("contacts.collection.create")
  end

  within ".partial-expired-text" do
    expect(page).to have_content("New contacts will not be visible to expired plots")
  end

  within ".form-actions-footer" do
    click_on I18n.t("contacts.show.back")
  end
end

Then(/^there is a message saying faqs will not be visible on expired plots$/) do
  within ".section-actions" do
    development = Development.find_by(name: ExpiryFixture.development_name)
    click_on I18n.t("faqs.collection.add", type: development.faq_types.last.name)
  end

  within ".partial-expired-text" do
    expect(page).to have_content("New FAQs will not be visible to expired plots")
  end

  within ".form-actions-footer" do
    click_on I18n.t("faqs.show.back")
  end
end

Then(/^there is a message saying videos will not be visible on expired plots$/) do
  within ".section-actions" do
    click_on I18n.t("videos.collection.create")
  end

  within ".partial-expired-text" do
    expect(page).to have_content("New videos will not be visible to expired plots")
  end

  within ".form-actions-footer" do
    click_on I18n.t("videos.show.back")
  end
end

Then(/^I do not see a message telling me some plots have expired on the developer$/) do
  within ".section-title" do
    expect(page).to have_no_css(".partial-expired-text")
  end
end
