Given(/^my development has an admin with snagging notifications enabled$/) do
  development_admin = FactoryGirl.create(:development_admin,
                                         permission_level: Development.find_by(name: HomeownerUserFixture.development_name),
                                         email: SnagFixture.notification_email,
                                         password: HomeownerUserFixture.admin_password,
                                         snag_notifications: true)
  no_notification_admin = FactoryGirl.create(:development_admin,
                                             permission_level: Development.find_by(name: HomeownerUserFixture.development_name),
                                             email: SnagFixture.no_notification_email,
                                             password: HomeownerUserFixture.admin_password,
                                             snag_notifications: false)
end


Then(/^I should see the Snagging page$/) do
  within ".burger-navigation" do
    check_box = find(".burger")
    check_box.trigger(:click)
  end
  click_on HomeownerUserFixture.custom_snag_name
  within ".main-container" do
    expect(page).to have_content(t"homeowners.snags.index.snag_description", snag_name: HomeownerUserFixture.custom_snag_name)
  end
end

Then(/^I can add a snag to my plot$/) do
  within ".new-snag" do
    click_on t("homeowners.snags.index.add_snag")
  end
  within ".snag-form" do
    fill_in :snag_title, with: SnagFixture.title
    fill_in :snag_description, with: SnagFixture.description

    picture_full_path = FileFixture.file_path + FileFixture.finish_picture_name
    attach_file("snag_snag_attachment_image",
                File.absolute_path(picture_full_path),
                visible: false)

  end
  click_on t("homeowners.snags.form.submit")
end

Then(/^the relevant admins are notified$/) do
  email = ActionMailer::Base.deliveries.last
  email.should deliver_to(SnagFixture.notification_email)
  email.should_not deliver_to(SnagFixture.no_notification_email)
  expect(email).to have_subject (t"snag_mailer.create")
  expect(email).to have_body_text(SnagFixture.title)
  expect(email).to have_body_text(HomeownerUserFixture.development_name)
end

When(/^I visit the Snagging page$/) do
  within ".sub-navigation-container" do
    click_on HomeownerUserFixture.custom_snag_name
  end
end

Then(/^I can see the snags submitted for my plot$/) do
  within ".branded-body" do
    expect(page).to have_content(t("homeowners.components.snag.edit"))
    expect(page).to have_content(SnagFixture.title)
    expect(page).to have_content(t("homeowners.components.snag.status"))
  end
end

Then(/^I can click on a snag to view it in full$/) do
  within ".snag" do
    click_on t("homeowners.components.snag.show")
  end
  within ".snag-article" do
    expect(page).to have_content(SnagFixture.description)
    expect(page).to have_content(t("homeowners.snags.show.snag_comments_description"))
  end
  within ".snag-images" do
    image = page.find("img")
    expect(image["src"]).to have_content(FileFixture.finish_picture_name)
    expect(image["alt"]).to have_content(FileFixture.finish_picture_alt)
  end
end

Then(/^I can add a comment to the snag$/) do
  within ".snag-comment-form" do
    fill_in :snag_comment_content, with: SnagFixture.comment

    picture_full_path = FileFixture.file_path + FileFixture.finish_picture_name
    within ".message" do
      attach_file("snag_comment_image",
                  File.absolute_path(picture_full_path),
                  visible: false)
    end
  end
  click_on t("snag_comments.form.send")

  sleep 0.2
  within ".snag-comment-list" do
    expect(page).to have_content(name)
    expect(page).to have_content("Resident")
    expect(page).to have_content(SnagFixture.comment)

    image = page.find("img")
    expect(image["src"]).to have_content(FileFixture.finish_picture_name)
    expect(image["alt"]).to have_content(FileFixture.finish_picture_alt)
  end
end

Then(/^the relevant admins are notified of my comment$/) do
  name = [HomeownerUserFixture.first_name, HomeownerUserFixture.last_name].compact.join(" ")
  full_name = name + " (Resident)"
  email = ActionMailer::Base.deliveries.last
  email.should deliver_to(SnagFixture.notification_email)
  email.should_not deliver_to(SnagFixture.no_notification_email)
  expect(email).to have_subject(t("snag_mailer.new_snag_comment", commenter_name: full_name))
  expect(email).to have_body_text(SnagFixture.title)
  expect(email).to have_body_text(HomeownerUserFixture.development_name)
end


Then(/^I can edit the snag$/) do
  within ".snag-article" do
    click_on t("homeowners.snags.show.edit")
  end
  within ".snag-form" do
    fill_in :snag_title, with: SnagFixture.updated_title
    fill_in :snag_description, with: SnagFixture.updated_description
  end
  click_on t("homeowners.snags.form.submit")
  email = ActionMailer::Base.deliveries.last
  email.should deliver_to(SnagFixture.notification_email)
  email.should_not deliver_to(SnagFixture.no_notification_email)
  expect(email).to have_subject(t"snag_mailer.update")
  expect(email).to have_body_text(SnagFixture.updated_title)
  within ".snag-article" do
    expect(page).to have_content(SnagFixture.updated_description)
  end
end

Then(/^I can add another snag$/) do
  within ".sub-navigation-container" do
    click_on HomeownerUserFixture.custom_snag_name
  end
  within ".new-snag" do
    click_on t("homeowners.snags.index.add_snag")
  end
  within ".snag-form" do
    fill_in :snag_title, with: SnagFixture.second_title
    fill_in :snag_description, with: SnagFixture.second_description
  end
  click_on t("homeowners.snags.form.submit")
end

Then(/^I can see all of my snags$/) do
  within ".sub-navigation-container" do
    click_on HomeownerUserFixture.custom_snag_name
  end
  within ".branded-body" do
    expect(page).to have_content(SnagFixture.title)
    expect(page).to have_content(SnagFixture.second_title)
  end
end

Then(/^I can delete the snag$/) do
  snag = page.first(".snag")
  within snag do
    click_on ("Delete")
  end
  within ".ui-dialog-content" do
    expect(page).to have_content(t("homeowners.components.snag.confirm_snag"))
  end
  within ".ui-dialog-buttonpane" do
    click_on("Confirm Delete")
  end
  within ".snagging" do
    expect(page).to_not have_content(SnagFixture.second_title)
  end
end

Then(/^the relevant admins will be notified that I have deleted the snag$/) do
  sleep 0.4
  email = ActionMailer::Base.deliveries.last
  email.should deliver_to(SnagFixture.notification_email)
  email.should_not deliver_to(SnagFixture.no_notification_email)
  expect(email).to have_subject(t"snag_mailer.delete")
  expect(email).to have_body_text(SnagFixture.second_title)
end
