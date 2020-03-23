Given(/^I am logged in as a development admin with snagging enabled$/) do
  AdminUsersFixture.create_permission_resources
  CreateFixture.create_division_development_phase
  CreateFixture.create_unit_type
  admin = CreateFixture.create_developer_admin
  admin.update_attributes(first_name: SnagFixture.first_name, last_name: SnagFixture.last_name, email: SnagFixture.developer_email)
  login_as admin
  visit "/"
end

Given(/^there are unresolved snags for a plot on my development$/) do
  plot = CreateFixture.create_snag_plot
  resident = HomeownerUserFixture.create_without_residency
  resident.update_attributes(developer_email_updates: 1)
  @second_resident = SnagFixture.second_resident
  FactoryGirl.create(:plot_residency, plot_id: plot.id, resident_id: resident.id, role: :homeowner)
  FactoryGirl.create(:plot_residency, plot_id: plot.id, resident_id: @second_resident.id, role: :homeowner)
  SnagFixture.create_snag(plot)
end

Then(/^I should see the snagging notification checkbox on my profile$/) do
  within ".navbar" do
    click_on(t"components.navigation.profile")
  end

  find("[data-action='edit']").click

  within ".user" do
    expect(page).to have_content t("admin.users.form.receive_snag_emails")
  end
end

Then(/^I should see a notification next to the snagging link$/) do
  sup = page.find(".unresolved-count")
  expect(sup).to have_content("1")
end

When(/^I visit the snagging page$/) do
  within ".navbar" do
    click_on t("components.navigation.snagging")
  end
end

Then(/^I can see the snags that have been submitted$/) do
  within ".record-list" do
    click_on(t("admin.snags.phases.collection.plots"))
  end

  within ".record-list" do
    expect(page).to have_content(CreateFixture.snag_plot_number)
    expect(page).to have_content(CreateFixture.snag_house_number)
  end

  within ".record-list" do
    click_on(t("admin.snags.phases.show.snags"))
  end
end

Then(/^I can view the snag details$/) do
  within ".record-list" do
    click_on(SnagFixture.title)
  end
  within ".snag" do
    expect(page).to have_content(SnagFixture.description)
    expect(page).to have_content(t("admin.snags.show.unresolved"))
  end
end

Then(/^I can add a comment$/) do
  within ".snag-comment-form" do
    fill_in :snag_comment_content, with: SnagFixture.admin_comment

    picture_full_path = FileFixture.file_path + FileFixture.finish_picture_name
    within ".message" do
      attach_file("snag_comment_image",
                  File.absolute_path(picture_full_path),
                  visible: false)
    end
  end
  click_on t("snag_comments.form.send")
  name = [SnagFixture.first_name, SnagFixture.last_name].compact.join(" ")
  full_name = name + " (" + CreateFixture.developer.to_s + ")"
  email = ActionMailer::Base.deliveries.last
  email.should deliver_to(HomeownerUserFixture.email)
  email.should_not deliver_to(SnagFixture.resident_email)
  expect(email).to have_subject(t("resident_snag_mailer.snag_comment_email.snag_comment_subject", commenter_name: full_name))
  expect(email).to have_body_text(SnagFixture.title)
  within ".snag-comments" do
    expect(page).to have_content(SnagFixture.admin_comment)
    expect(page).to have_content(full_name)

    image = page.find("img")
    expect(image["src"]).to have_content(FileFixture.finish_picture_name)
    expect(image["alt"]).to have_content(FileFixture.finish_picture_alt)
  end
end

When(/^I mark the snag as resolved$/) do
  within ".snag-status" do
    click_on(t("admin.snags.show.mark_as_resolved", status: "Resolved"))
  end
  email = ActionMailer::Base.deliveries.last
  email.should deliver_to(HomeownerUserFixture.email)
  email.should_not deliver_to(SnagFixture.resident_email)
  expect(email).to have_subject(t("resident_snag_mailer.snag_status_email.snag_status_subject"))
  expect(email).to have_body_text(SnagFixture.title)
  within ".snag-status" do
    expect(page).to have_content(t("admin.snags.show.awaiting"))
  end
end

Then(/^any resident of the plot can approve the resolved status$/) do
  # logout as admin
  within ".navbar" do
    click_on t("components.navigation.log_out")
  end

  visit "/homeowners/sign_in"

  # login as second resident
  within ".sign-in" do
    fill_in :resident_email, with: @second_resident.email
    fill_in :resident_password, with: @second_resident.password
    check_box = find(".accept-ts-and-cs")
    check_box.trigger(:click)
    click_on "Login"
  end

  # check notifications
  within(".session-inner") do
    notification_link = page.find(:css, 'a[href="/homeowners/notifications"]')
    notification_link.click
  end

  within ".notification-list" do
    cards = page.all(".card")
    expect(cards.length).to eq(2)  # one for comment, one for resolved status
  end

  # navigate to snagging page
  within ".navigation" do
    click_on (t("layouts.homeowner.nav.my_home", construction: t("construction_type.home")))
  end

  within ".sub-navigation-container" do
    click_on "Snagging"
  end

  within ".main-container" do
    expect(page).to have_content(t("homeowners.snags.index.snag_continuation"))
  end

  within ".snag" do
    expect(page).to have_content(SnagFixture.title)
    click_on(t("homeowners.components.snag.show"))
  end

  within ".snag-article" do
    expect(page).to have_content(t("homeowners.snags.show.resolved_status.awaiting"))
    within ".snag-comment-list" do
      image = page.find("img")
      expect(image["src"]).to have_content(FileFixture.finish_picture_name)
      expect(image["alt"]).to have_content(FileFixture.finish_picture_alt)
    end
    click_on (t("homeowners.snags.show.resident_approved"))
  end

  within ".snag-article" do
  sleep 0.5
    expect(page).to have_content(t("homeowners.snags.show.resolved_status.approved"))
    expect(page).to_not have_content(t("admin.snags.show.snag_comments_description"))
  end
end

Then(/^I am notified that the snag status have been approved$/) do
  email = ActionMailer::Base.deliveries.last
  email.should deliver_to(SnagFixture.developer_email)
  expect(email).to have_subject(t("snag_mailer.notify_rejection", status: "approved"))
  expect(email).to have_body_text(t("snag_mailer.rejected_status", status: "approved"))
  expect(email).to have_body_text(SnagFixture.title)
end

Then(/^the resident is no longer able to submit snags$/) do
  # check notifications
  within(".session-inner") do
    notification_link = page.find(:css, 'a[href="/homeowners/notifications"]')
    notification_link.click
  end
  within ".notification-list" do
    cards = page.all(".card")
    expect(cards.length).to eq(3)  # one for comment, one for resolved status, one for all resolved
    card = page.find(".details", text: t("resident_snag_mailer.notify.new_notification"), match: :first)
    card.trigger(:click)
  end
  within ".notification-expanded" do
    expect(page).to have_content "You can view your archived issue reports under the Account page."
  end

  # check nav link and my account link
  within ".navigation" do
    click_on (t("layouts.homeowner.nav.my_home", construction: t("construction_type.home")))
  end
  within ".sub-navigation-container" do
    expect(page).to_not have_content("Snagging")
  end
  within ".session-inner" do
    click_on(t("components.homeowner.welcome.account"))
  end
  within ".snagging-history" do
    click_on("Snagging History")
  end
  within ".main-container" do
    expect(page).to have_content(t("homeowners.snags.index.snag_archive"))
  end
  within ".snagging" do
    expect(page).to have_content(SnagFixture.title)
    expect(page).to_not have_content("Edit")
  end
end

Given(/^I am logged in as a development admin with snagging disabled$/) do
  AdminUsersFixture.create_permission_resources
  admin = CreateFixture.create_development_admin
  login_as admin
  visit "/"
end

Then(/^I cannot see any snags$/) do
  within ".main-container" do
    expect(page).to have_content(t("admin.snags.phases.collection.request_enabled"))
  end
end

Then(/^I cannot see the snagging link$/) do
  within ".navbar" do
    expect(page).to_not have_content("Snagging")
  end
end

Then(/^a resident can dispute the resolved status$/) do
  # logout as admin
  within ".navbar" do
    click_on t("components.navigation.log_out")
  end

  visit "/homeowners/sign_in"
  # login as second resident
  within ".sign-in" do
    fill_in :resident_email, with: @second_resident.email
    fill_in :resident_password, with: @second_resident.password
    check_box = find(".accept-ts-and-cs")
    check_box.trigger(:click)
    click_on "Login"
  end

  within ".navigation" do
    click_on (t("layouts.homeowner.nav.my_home", construction: t("construction_type.home")))
  end
  within ".sub-navigation-container" do
    click_on "Snagging"
  end
  within ".snag" do
    click_on(t("homeowners.components.snag.show"))
  end
  within ".snag-article" do
    click_on (t("homeowners.snags.show.resident_rejected"))
  end
  within ".notice" do
    expect(page).to have_content(t("homeowners.snags.update.notify_status", status: "rejected"))
  end
end

Then(/^I am notified that the snag status has been rejected$/) do
  email = ActionMailer::Base.deliveries.last
  email.should deliver_to(SnagFixture.developer_email)
  expect(email).to have_subject(t("snag_mailer.notify_rejection", status: "rejected"))
  expect(email).to have_body_text(t("snag_mailer.rejected_status", status: "rejected"))
  expect(email).to have_body_text(SnagFixture.title)
end

Then(/^the resident is able to add comments to the snag$/) do
  within ".snag-comments-container" do
    expect(page).to have_content(t("homeowners.snags.show.snag_comments_description"))
  end
end
