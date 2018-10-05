# frozen_string_literal: true

When(/^I submit feedback$/) do
  ActionMailer::Base.deliveries.clear
  visit "/"

  within ".header-container" do
    click_on t("components.header.feedback")
  end

  within ".feedback-dialog" do
    happy = find("input.option3", visible: false)
    happy.trigger("click")
    fill_in :comments, with: FeedbackFixture.feedback_comments
  end

  within ".ui-dialog-buttonset" do
    click_on t("feedback.submit")
  end
end

Then(/^An email should be sent to Hoozzi$/) do
  sleep 0.6

  emails = ActionMailer::Base.deliveries

  subject_text = emails[0].subject
  email_address = emails[0].to

  expect(subject_text).to eq t("feedback.email_subject")
  expect(email_address).to match_array(["feedback@hoozzi.com"])

  body = Capybara.string(emails[0].body.encoded)
  expect(body.native).to have_content t("feedback.option3")
  expect(body.native).to have_content FeedbackFixture.feedback_comments_test
  expect(body.native).to have_content t("feedback.not_sent")

  ActionMailer::Base.deliveries.clear
end

When(/^I submit feedback with email$/) do
  ActionMailer::Base.deliveries.clear
  visit "/"

  within ".header-container" do
    click_on t("components.header.feedback")
  end

  within ".feedback-dialog" do
    email = find("input.send-email")
    email.click
  end

  within ".ui-dialog-buttonset" do
    click_on t("feedback.submit")
  end
end

Then(/^My email should be sent to Hoozzi$/) do
  sleep 0.5

  emails = ActionMailer::Base.deliveries

  subject_text = emails[0].subject
  email_address = emails[0].to

  expect(subject_text).to eq t("feedback.email_subject")
  expect(email_address).to match_array(["feedback@hoozzi.com"])

  body = Capybara.string(emails[0].body.encoded)
  expect(body.native).not_to have_content t("feedback.option3")
  expect(body.native).not_to have_content FeedbackFixture.feedback_comments
  expect(body.native).to have_content CreateFixture.developer_admin.email

  ActionMailer::Base.deliveries.clear
end
