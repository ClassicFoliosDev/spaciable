# frozen_string_literal: true

When(/^I create a video$/) do
  goto_development_show_page

  within ".tabs" do
    click_on t("developments.collection.videos")
  end

  within ".empty" do
    click_on t("components.empty_list.add", type_name: Video.model_name.human.titleize)
  end

  within ".row" do
    fill_in "video_title", with: VideoFixture.title
    fill_in "video_link", with: VideoFixture.link
  end

  click_on t("rooms.form.submit")
end

When(/^I create a video for the division development$/) do
  goto_division_development_show_page

  within ".tabs" do
    click_on t("developments.collection.videos")
  end

  within ".empty" do
    click_on t("components.empty_list.add", type_name: Video.model_name.human.titleize)
  end

  within ".row" do
    fill_in "video_title", with: VideoFixture.title
    fill_in "video_link", with: VideoFixture.link
  end

  check :video_notify
  click_on t("rooms.form.submit")
end

Then(/^I should see the created video$/) do
  success_flash = t(
    "controller.success.create",
    name: VideoFixture.title
  )

  expect(page).to have_content(success_flash)

  within ".record-list" do
    expect(page).to have_content(VideoFixture.title)
    expect(page).to have_content(VideoFixture.link)
  end
end

Then(/^I should see the video resident has been notified$/) do
  in_app_notification = Notification.all.last
  expect(in_app_notification.residents.count).to eq 1
  expect(in_app_notification.residents.first.email).to eq CreateFixture.resident.email

  email = ActionMailer::Base.deliveries.first
  video = VideoFixture.title
  expect(email).to have_body_text("The following video has been added to your home's online portal:")
  expect(email).to have_body_text("#{video}")

  ActionMailer::Base.deliveries.clear
end


When(/^I update the video$/) do
  within ".record-list" do
    find("[data-action='edit']").click
  end

  within ".row" do
    fill_in "video_title", with: VideoFixture.updated_title
    fill_in "video_link", with: VideoFixture.updated_link
  end

  click_on t("rooms.form.submit")
end

Then(/^I should see the updated video$/) do
  success_flash = t(
    "controller.success.update",
    name: VideoFixture.updated_title
  )

  expect(page).to have_content(success_flash)

  within ".record-list" do
    expect(page).to have_content(VideoFixture.updated_title)
    expect(page).to have_content(VideoFixture.updated_link)
  end
end

When(/^I delete the video$/) do
  delete_and_confirm!
end

Then(/^I should no longer see the video$/) do
  success_flash = t(
    "controller.success.destroy",
    name: VideoFixture.updated_title
  )
  expect(page).to have_content(success_flash)

  expect(page).not_to have_content(".record-list")

  within ".empty" do
    expect(page).to have_content %r{#{t("components.empty_list.add", type_name: Video.model_name.human)}}i
  end
end
