Given(/^I log in as a resident$/) do
  login_as CreateFixture.resident
  visit "/"
end

Given(/^the developer has enabled development messages$/) do
  developer = Developer.find_by(company_name: CreateFixture.developer_name)
  developer.update_attributes(enable_development_messages: true)
end

When(/^I visit my community$/) do
  within ".navbar-menu" do
    click_on t("layouts.homeowner.nav.community")
  end
end

Then(/^I can not visit the community$/) do
  within ".navbar-menu" do
    expect(page).not_to have_content t("layouts.homeowner.nav.community")
  end
end

Then(/^I can post a message$/) do
  within ".message-form" do
    fill_in :development_message_subject, with: CommunityFixture.topic_1
    fill_in :development_message_content, with: CommunityFixture.content
    click_on t("homeowners.development_messages.form.send")
  end
end

Given(/^there is another resident$/) do
  second_plot = FactoryGirl.create(:plot, phase: CreateFixture.phase, number: PlotFixture.another_plot_number)
  resident = FactoryGirl.create(:resident, email: HomeownerUserFixture.email, password: HomeownerUserFixture.password)
  FactoryGirl.create(:plot_residency, plot_id: second_plot.id, resident_id: resident.id)
end

Then(/^I can post a new message$/) do
  within ".message-form" do
    fill_in :development_message_subject, with: CommunityFixture.topic_2
    fill_in :development_message_content, with: CommunityFixture.content
    click_on t("homeowners.development_messages.form.send")
  end
end

Then(/^I can follow up an existing message$/) do
  within ".message-reply" do
    expect(page).not_to have_selector ".message_subject"
    fill_in :development_message_content, with: CommunityFixture.reply
    click_on t("homeowners.development_messages.form.send")
  end
end

Then(/^I see all the messages$/) do
  within ".messages-container" do
    expect(page).to have_content %r{#{CommunityFixture.topic_1}}i
    expect(page).to have_content CommunityFixture.reply
    expect(page).to have_content %r{#{CommunityFixture.topic_2}}i

    first_resident = CreateFixture.resident
    expect(page).to have_content first_resident.to_s
    second_resident = Resident.find_by(email: HomeownerUserFixture.email)
    second_resident_citations = page.all("span", text: second_resident.to_s)
   expect(second_resident_citations.count).to eq 2
  end
end

Given(/^there is a message from four months ago$/) do
  resident = CreateFixture.resident
  four_months_ago = Time.zone.now - 120.days
  FactoryGirl.create(:development_message, resident_id: resident.id,
                     development_id: resident.plots.first.development.id,
                     created_at: four_months_ago)
end

Then(/^I will not see the old message$/) do
  resident = CreateFixture.resident
  message = DevelopmentMessage.find_by(resident_id: resident.id)

  within ".messages-container" do
    expect(page).not_to have_content resident.to_s
    expect(page).not_to have_content message.subject
    expect(page).not_to have_content message.content
  end
end
