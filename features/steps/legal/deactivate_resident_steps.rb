When(/^I deactivate my account$/) do
  visit "/"

  page.find("#dropdownMenu").click
  within ".links-list" do
    click_on t("homeowners.residents.show.my_account")
  end

  within ".show-actions" do
    click_on t(".homeowners.residents.show.deactivate")
  end
  
  within ".remove-resident-form" do
    fill_in :password, with: HomeownerUserFixture.password
  end
  
  within ".ui-dialog-buttonset" do
    click_on t(".homeowners.residents.show.confirm_deactivate")
  end
end

Then(/^my account no longer exists$/) do
#   expect(page).to have_content t(".homeowners.residents.destroy.success")
  sleep 0.5
  expect(current_path).to eq '/homeowners/sign_in'

  residents = Resident.all
  expect(residents.count).to be_zero
end

Then(/^my documents no longer exist$/) do
  documents = PrivateDocument.all
  expect(documents.count).to be_zero
end

Then(/^I am no longer subscribed in mailchimp$/) do
  # Not possible to test this properly, make sure it's tested in a live system
end

Then(/^I see an error$/) do
  within ".alert" do
    expect(page).to have_content "Invalid email address or password"
  end  
end
