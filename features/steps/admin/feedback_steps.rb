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

When(/^I submit homeowner feedback$/) do
  visit "/"
  page.find("#dropdownMenu").click
  within ".links-list" do
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

Then(/^An email should be sent$/) do
  sleep 0.6

  emails = ActionMailer::Base.deliveries

  subject_text = emails[0].subject
  email_address = emails[0].to

  expect(subject_text).to eq t("feedback.email_subject")
  expect(email_address).to match_array(["feedback@spaciable.com"])

  body = Capybara.string(emails[0].body.encoded)
  expect(body.native).to have_content t("feedback.option3")
  expect(body.native).to have_content FeedbackFixture.feedback_comments

  ActionMailer::Base.deliveries.clear
end
