# frozen_string_literal: false

Given(/^I am logged in as a homeowner on a plot that will expire$/) do
  login_as HomeownerUserFixture.create
end

And(/^the development has set a maintenance link$/) do
  development = Development.find_by(name: HomeownerUserFixture.development_name)
  FactoryGirl.create(:maintenance, development_id: development.id, path: "https://dummy.fixflo.com/issue/plugin/")
end

Then(/^I should see the maintenance link$/) do
  visit "/"
  within ".burger-navigation" do
    check_box = find(".burger")
    check_box.trigger(:click)
  end
  expect(page).to have_content I18n.t("components.homeowner.navigation.maintenance")
end

Given(/^the completion release date is set$/) do
  plot = Plot.find_by(number: "63B")
  plot.update_attributes(completion_release_date: ExpiryFixture.fixflo_completion_release_date)
end

And(/^the date is after completion release date plus validity$/) do
  plot = Plot.find_by(number: "63B")
  plot.update_attributes(validity: ExpiryFixture.validity)
end

And(/^the date is before extended access$/) do
  plot = Plot.find_by(number: "63B")
  plot.update_attributes(extended_access: ExpiryFixture.extended_access)
end

Given(/^the completion release date has been set$/) do
  plot = Plot.find_by(number: "63B")
  plot.update_attributes(completion_release_date: ExpiryFixture.expiry_completion_release_date)
end

Given(/^the development has branding$/) do
  FactoryGirl.create(:brand, brandable: Development.find_by(name: HomeownerUserFixture.development_name),
                             bg_color: "#446677",
                             button_color: "#776644",
                             button_text_color: "#698492")
end

Then(/^I should see the development branding$/) do
  visit "/"
  style = page.find("head [data-test='brand-style-overrides']", visible: false)

  # bg-color
  expect(style['outerHTML']).to have_content("library-navigation { background-color: #446677")
  # button-color
  expect(style['outerHTML']).to have_content("branded-btn { background-color: #776644")
  # button-text-color
  expect(style['outerHTML']).to have_content("branded-btn { color: #698492")
  #banner
  expect(style['outerHTML']).to have_content("branded-hero { background-image: url(/uploads/brand/banner/1/cala_banner.jpg)")
end

Given(/^the date is after extended access$/) do
  plot = Plot.find_by(number: "63B")
  plot.update_attributes(extended_access: ExpiryFixture.extended_access)
end

Then(/^I should see the expired branding$/) do
  visit "/"
  style = page.find("head [data-test='expired-style']", visible: false)

  # bg-color
  expect(style['outerHTML']).to have_content("branded-body { background-color: #FFFFFF")
  # button-color
  expect(style['outerHTML']).to have_content("branded-btn { background-color: #FFFFFF")
  #banner
  expect(style['outerHTML']).to have_content("branded-hero { background-image: url(\"/assets/expiry_banner")
end

Given(/^I have enabled developer emails$/) do
  resident = Resident.find_by(email: HomeownerUserFixture.email)
  resident.update_attributes(developer_email_updates: 1)
end

Then(/^when a cf admin sends a notification$/) do
  page.find("#dropdownMenu").click
  find("#signOut").click

  cf_admin = FactoryGirl.create(:cf_admin, email: ExpiryFixture.cf_email, password: ExpiryFixture.cf_password)
  login_as cf_admin

  visit "/admin/notifications"

  ActionMailer::Base.deliveries.clear
  attrs = ResidentNotificationsFixture::MESSAGES[:all]

  within ".section-actions" do
    click_on t("admin.notifications.collection.add")
  end

  within ".new_notification" do
    check :notification_send_to_all
    fill_in :notification_subject, with: attrs[:subject]
    fill_in_ckeditor(:notification_message, with: attrs[:message])
  end

  within ".form-actions-footer" do
    click_on t("admin.notifications.form.submit")
  end

  within find(".submit-dialog") do
    click_on "Confirm"
  end

  within ".navbar" do
    click_on t("components.navigation.log_out")
  end
end

Then(/^I will receive an email$/) do
  expect(ActionMailer::Base.deliveries.count).to eq 1
  email = ActionMailer::Base.deliveries.last
  email.should deliver_to(HomeownerUserFixture.email)
end

Then(/^I will receive a notification$/) do
  resident = Resident.find_by(email: HomeownerUserFixture.email)
  login_as resident
  visit "/"
  within "#acctNav" do
    sup = page.first(".unread")
    expect(sup).to have_content("1")
  end
end

Then(/^when a non cf admin sends a notification$/) do
  page.find("#dropdownMenu").click
  find("#signOut").click

  div_admin = FactoryGirl.create(:division_admin,
                                 permission_level: Division.find_by(division_name: HomeownerUserFixture.division_name),
                                 password: HomeownerUserFixture.admin_password)
  login_as div_admin

  visit "/admin/notifications"

  ActionMailer::Base.deliveries.clear
  attrs = ResidentNotificationsFixture::MESSAGES[:all]

  within ".section-actions" do
    click_on t("admin.notifications.collection.add")
  end

  within ".new_notification" do
    fill_in :notification_subject, with: attrs[:subject]
    fill_in_ckeditor(:notification_message, with: attrs[:message])
  end

  within ".form-actions-footer" do
    click_on t("admin.notifications.form.submit")
  end

  within find(".submit-dialog") do
    click_on "Confirm"
  end

  within ".navbar" do
    click_on t("components.navigation.log_out")
  end
end


Then(/^I will not receive an email$/) do
  # There are no other residents, so the email should not have sent
  expect(ActionMailer::Base.deliveries.count).to eq 0
end

Then(/^I will not receive a notification$/) do
  resident = Resident.find_by(email: HomeownerUserFixture.email)
  login_as resident
  visit "/"
  # The unread notification count should still be one, as per the previous notification sent
  within "#acctNav" do
    sup = page.first(".unread")
    expect(sup).to have_content("1")
  end
end

Then(/^when a cf admin creates a document$/) do
  page.find("#dropdownMenu").click
  find("#signOut").click

  cf_admin = FactoryGirl.create(:cf_admin, email: ExpiryFixture.cf_email, password: ExpiryFixture.cf_password)
  login_as cf_admin

  ActionMailer::Base.deliveries.clear

  developer = Developer.find_by(company_name: HomeownerUserFixture.developer_name)
  visit "/developers/#{developer.id}/documents/new"

  document_full_path = FileFixture.file_path + FileFixture.document_name
  within ".documents" do
    attach_file(:document_files,
                File.absolute_path(document_full_path),
                visible: false)
  end

  within ".form-actions-footer" do
    check :document_notify
  end

  click_on t("documents.form.submit")

  within ".navbar" do
    click_on t("components.navigation.log_out")
  end
end

Then(/^I can see the document$/) do
  within ".burger-navigation" do
    check_box = find(".burger")
    check_box.trigger(:click)
  end
  click_on(t("components.homeowner.sub_menu.library"))

  within find(".main-container") do
    expect(page).to have_content(ExpiryFixture.doc_name)
  end
end

Given(/^there is another plot on my phase that is not expired$/) do
  ExpiryFixture.create_live_plot_residency
end

Then(/^when a non cf admin creates a document$/) do
  page.find("#dropdownMenu").click
  find("#signOut").click

  div_admin = FactoryGirl.create(:division_admin,
                                 permission_level: Division.find_by(division_name: HomeownerUserFixture.division_name),
                                 password: HomeownerUserFixture.admin_password)
  login_as div_admin

  ActionMailer::Base.deliveries.clear

  division = Division.find_by(division_name: HomeownerUserFixture.division_name)
  visit "/divisions/#{division.id}/documents/new"

  document_full_path = FileFixture.file_path + FileFixture.second_document_name
  within ".documents" do
    attach_file(:document_files,
                File.absolute_path(document_full_path),
                visible: false)
  end

  within ".form-actions-footer" do
    check :document_notify
  end

  click_on t("documents.form.submit")

  within ".navbar" do
    click_on t("components.navigation.log_out")
  end
end

Then(/^I cannot see the new document$/) do
  # The document will not be visible on the dashboard
  visit "/"
  within find(".document-images") do
    expect(page).to_not have_content(ExpiryFixture.second_doc_name)
  end

  # The document will not be visible on the library page
  within ".burger-navigation" do
    check_box = find(".burger")
    check_box.trigger(:click)
  end
  click_on(t("components.homeowner.sub_menu.library"))

  within ".main-container" do
    expect(page).to_not have_content(ExpiryFixture.second_doc_name)
  end
end

When(/^I log in as a resident on the live plot$/) do
  page.find("#dropdownMenu").click
  find("#signOut").click

  second_resident = Resident.find_by(email: ExpiryFixture.resident_email)
  login_as second_resident

  visit "/"
end

Then(/^I can see a notification$/) do
  within "#acctNav" do
    sup = page.first(".unread")
    expect(sup).to have_content("1")
  end
end

Then(/^I can see both documents$/) do
  within find(".burger-navigation") do
    check_box = find(".burger")
    check_box.trigger(:click)
  end
  click_on(t("components.homeowner.sub_menu.library"))

  within find(".main-container") do
    expect(page).to have_content(ExpiryFixture.second_doc_name)
    expect(page).to have_content(ExpiryFixture.doc_name)
  end
end

Then(/^when a cf admin creates a contact$/) do
  page.find("#dropdownMenu").click
  find("#signOut").click

  cf_admin = FactoryGirl.create(:cf_admin, email: ExpiryFixture.cf_email, password: ExpiryFixture.cf_password)
  login_as cf_admin

  ActionMailer::Base.deliveries.clear

  developer = Developer.find_by(company_name: HomeownerUserFixture.developer_name)
  visit "/developers/#{developer.id}/contacts/new"

  within ".contact" do
    fill_in "contact_email", with: ContactFixture.email
    fill_in "contact_organisation", with: ContactFixture.organisation
  end

  within ".form-actions-footer" do
    check :contact_notify
  end

  click_on t("contacts.form.submit")

  within ".navbar" do
    click_on t("components.navigation.log_out")
  end
end

Then(/^I will not have any notifications$/) do
  resident = Resident.find_by(email: HomeownerUserFixture.email)
  login_as resident
  visit "/homeowners/notifications"
  within ".branded-body" do
    expect(page).to have_content I18n.t("homeowners.notifications.index.none")
  end
end

Then(/^I cannot see the contact$/) do
  within ".burger-navigation" do
    check_box = find(".burger")
    check_box.trigger(:click)
  end
  click_on(t("components.navigation.contacts"))


  within find(".full-contacts") do
    expect(page).to_not have_content(ContactFixture.email)
  end
end

When(/^a non cf admin creates a contact$/) do
  page.find("#dropdownMenu").click
  find("#signOut").click

  div_admin = FactoryGirl.create(:division_admin,
                                 permission_level: Division.find_by(division_name: HomeownerUserFixture.division_name),
                                 password: HomeownerUserFixture.admin_password)
  login_as div_admin

  ActionMailer::Base.deliveries.clear

  division = Division.find_by(division_name: HomeownerUserFixture.division_name)
  visit "/divisions/#{division.id}/contacts/new"

  within ".contact" do
    fill_in "contact_email", with: ContactFixture.second_email
    fill_in "contact_organisation", with: ContactFixture.organisation
  end

  within ".form-actions-footer" do
    check :contact_notify
  end

  click_on t("contacts.form.submit")

  within ".navbar" do
    click_on t("components.navigation.log_out")
  end
end

Then(/^I can see both contacts$/) do
  # Are the contacts visible on the dashboard
  within ".contact-list" do
    expect(page).to have_content(ContactFixture.email)
    expect(page).to have_content(ContactFixture.second_email)
  end

  # Are the contacts visible on the contacts page
  within ".burger-navigation" do
    check_box = find(".burger")
    check_box.trigger(:click)
  end
  click_on(t("components.navigation.contacts"))

  within find(".full-contacts", wait: 5) do
    expect(page).to have_content(ContactFixture.email)
    expect(page).to have_content(ContactFixture.second_email)
  end
end

When(/^I will not receive a notification email$/) do
  # There will be one email delivered to the live plot resident
  expect(ActionMailer::Base.deliveries.count).to eq 1
  email = ActionMailer::Base.deliveries.last
  email.should_not deliver_to(HomeownerUserFixture.email)
end

Then(/^I will have received an email$/) do
  email = ActionMailer::Base.deliveries.last
  email.should deliver_to(ExpiryFixture.resident_email)
end

Then(/^when a cf admin creates a FAQ$/) do
  visit "/"
  page.find("#dropdownMenu").click
  find("#signOut").click

  cf_admin = FactoryGirl.create(:cf_admin, email: ExpiryFixture.cf_email, password: ExpiryFixture.cf_password)
  login_as cf_admin

  ActionMailer::Base.deliveries.clear

  developer = Developer.find_by(company_name: HomeownerUserFixture.developer_name)
  visit "/developers/#{developer.id}/faqs/new?active_tab=1"

  within ".new_faq" do
    fill_in :faq_question, with: ExpiryFixture.faq_title
    fill_in_ckeditor(:faq_answer, with: ExpiryFixture.faq_content)

    select_from_selectmenu :faq_faq_category, with: "Settling In"
    check :faq_notify
    click_on t("faqs.form.submit")
  end

  within ".navbar" do
    click_on t("components.navigation.log_out")
  end
end

Then(/^I cannot see the FAQ$/) do
  visit "/"
  # The FAQ will not be visible on the dashboard
  within ".faq-list" do
    expect(page).to_not have_content(ExpiryFixture.faq_title)
  end
end

Then(/^when a non cf admin creates an FAQ$/) do
  page.find("#dropdownMenu").click
  find("#signOut").click

  div_admin = FactoryGirl.create(:division_admin,
                                 permission_level: Division.find_by(division_name: HomeownerUserFixture.division_name),
                                 password: HomeownerUserFixture.admin_password)
  login_as div_admin

  ActionMailer::Base.deliveries.clear

  division = Division.find_by(division_name: HomeownerUserFixture.division_name)
  visit "/divisions/#{division.id}/faqs/new?active_tab=1"

  within ".new_faq" do
    fill_in :faq_question, with: ExpiryFixture.second_faq_title
    fill_in_ckeditor(:faq_answer, with: ExpiryFixture.second_faq_content)

    select_from_selectmenu :faq_faq_category, with: "Settling In"
    check :faq_notify
    click_on t("faqs.form.submit")
  end

  within ".navbar" do
    click_on t("components.navigation.log_out")
  end
end

Then(/^I cannot see the new FAQ$/) do
  visit "/"
  # The FAQ will not be visible on the dashboard
  within ".faq-list" do
    expect(page).to_not have_content(ExpiryFixture.second_faq_title)
  end
end

Then(/^I can see both FAQs$/) do
  visit "/"
  # Both FAQs will be visible on the dashboard
  within ".faq-list" do
   expect(page).to have_content(ExpiryFixture.faq_title)
   expect(page).to have_content(ExpiryFixture.second_faq_title)
  end

  # Both FAQs will be visible on the FAQ page
  visit "/homeowners/faqs/1/1"
  within ".main-container" do
   expect(page).to have_content(ExpiryFixture.faq_title)
   expect(page).to have_content(ExpiryFixture.second_faq_title)
  end
end

Then(/^when a cf admin creates a video$/) do
  page.find("#dropdownMenu").click
  find("#signOut").click

  cf_admin = FactoryGirl.create(:cf_admin, email: ExpiryFixture.cf_email, password: ExpiryFixture.cf_password)
  login_as cf_admin

  development = Development.find_by(name: HomeownerUserFixture.development_name)
  visit "/developments/#{development.id}/videos"

  within ".empty" do
    click_on t("components.empty_list.add", action: "Add", type_name: Video.model_name.human.titleize)
  end

  within ".row" do
    fill_in "video_title", with: VideoFixture.title
    fill_in "video_link", with: VideoFixture.link
  end

  click_on t("rooms.form.submit")

  within ".navbar" do
    click_on t("components.navigation.log_out")
  end
end

Then(/^I cannot see the video$/) do
  resident = Resident.find_by(email: HomeownerUserFixture.email)
  login_as resident
  visit "/"

  within ".burger-navigation" do
    check_box = find(".burger")
    check_box.trigger(:click)
  end
  click_on(t("components.homeowner.sub_menu.library"))

  within find(".sub-navigation-container", wait: 5) do
    expect(page).to_not have_content I18n.t("components.homeowner.library_categories.videos")
  end
end

Then(/^when a non cf admin creates a video$/) do
  page.find("#dropdownMenu").click
  find("#signOut").click

  div_admin = FactoryGirl.create(:division_admin,
                                 permission_level: Division.find_by(division_name: HomeownerUserFixture.division_name),
                                 password: HomeownerUserFixture.admin_password)
  login_as div_admin

  development = Development.find_by(name: HomeownerUserFixture.development_name)
  visit "/developments/#{development.id}/videos"

  within ".section-actions" do
   click_on t("videos.collection.create")
  end

  within ".row" do
   fill_in "video_title", with: VideoFixture.second_title
   fill_in "video_link", with: VideoFixture.second_link
  end

  click_on t("rooms.form.submit")

  within ".navbar" do
   click_on t("components.navigation.log_out")
  end
end

Then(/^I cannot see the new video$/) do
  resident = Resident.find_by(email: HomeownerUserFixture.email)
  login_as resident
  visit "/"

  within find(".library-component", wait: 5) do
    click_on I18n.t("homeowner.dashboard.cards.library.view_more")
  end

  within find(".library-categories", wait: 5) do
    expect(page).to_not have_content I18n.t("components.homeowner.library_categories.videos")
  end

end

Then(/^I can see both videos$/) do
  within ".burger-navigation" do
    check_box = find(".burger")
    check_box.trigger(:click)
  end
  click_on(t("components.homeowner.sub_menu.library"))

  within find(".library-categories", wait: 5) do
    click_on I18n.t("components.homeowner.library_categories.videos")
  end

  within ".videos" do
    expect(page).to have_content(VideoFixture.title)
    expect(page).to have_content(VideoFixture.second_title)
  end
end

Then(/^when I am on the private documents page$/) do
  visit "/homeowners/private_documents"
end

Then(/^I can no longer upload private documents$/) do
  within ".new-document" do
    expect(page).to have_content(t("homeowners.private_documents.index.expired"))
    expect(page).to have_no_css("#new_private_document")
  end
end

Then(/^when I am on the my account page$/) do
  page.find("#dropdownMenu").click
  within ".links-list" do
    click_on t("homeowners.residents.show.my_account")
  end
end

Then(/^I can no longer invite other residents to my plot$/) do
  plot = Plot.find_by(number: HomeownerUserFixture.plot_number)
  within ".other-residents" do
    expect(page).to_not have_content I18n.t("homeowners.residents.show.invite", plot: plot.number)
  end
end

Given(/^there is another resident on my plot$/) do
  ExpiryFixture.create_second_resident
  ExpiryFixture.create_second_residency

  page.find("#dropdownMenu").click
  within ".links-list" do
    click_on t("homeowners.residents.show.my_account")
  end

  within ".other-residents" do
    expect(page).to have_content(ExpiryFixture.first_name)
  end
end

Then(/^I can no longer delete residents from my plot$/) do
  within ".other-residents" do
    expect(page).to have_no_css(".prompt-remove")
  end
end
