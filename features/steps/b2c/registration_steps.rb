When(/^I visit the B2C home page$/) do
  ActionMailer::Base.deliveries.clear
  visit "/b2c"
end

When(/^I complete the registration fields$/) do
  within ".register" do
    fill_in :client_name, with: ClientFixture.name
    fill_in :client_email, with: ClientFixture.email
    fill_in :client_password, with: ClientFixture.password

    click_on t("b2c.clients.registrations.new.submit")
  end
end

Then(/^My new client user should be created$/) do
  clients = Client.all
  expect(clients.size).to eq 1
  expect(clients.first.email).to eq ClientFixture.email
  expect(clients.first.name).to eq ClientFixture.name

  registration_email = ActionMailer::Base.deliveries.first

  expect(registration_email.parts.first.body.raw_source).to include t("b2c_mailer.register.success")
  expect(registration_email.parts.first.body.raw_source).to include ClientFixture.email
  expect(registration_email.parts.first.body.raw_source).to include ClientFixture.name

  ActionMailer::Base.deliveries.clear
end
