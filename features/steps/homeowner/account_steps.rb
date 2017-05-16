# frozen_string_literal: true
Then(/^I should see be able to view My Account$/) do
  visit "/"

  within ".session-inner" do
    click_on t("homeowners.residents.show.my_account")
  end
end

When(/^I update the account details$/) do
  within ".resident" do
    click_on t("homeowners.residents.show.edit_profile")
  end

  sleep 0.2

  within ".resident" do
    fill_in "resident_first_name", with: AccountFixture.first_name
    check "resident[telephone_updates]"
    check "resident[hoozzi_email_updates]"
    click_on t("homeowners.residents.edit.submit")
  end
end

Then(/^I should see account details updated successfully$/) do
  sleep 0.2

  within ".session-inner" do
    click_on t("homeowners.residents.show.my_account")
  end

  within ".resident" do
    expect(page).to have_content AccountFixture.first_name
  end

  within ".communications" do
    selected = page.all(".selected").map(&:text)
    expect(selected).to have_content t("homeowners.residents.show.telephone_updates")
    expect(selected).to have_content t("homeowners.residents.show.hoozzi_email_updates")

    unselected = page.all(".unselected").map(&:text)
    expect(unselected).to have_content t("homeowners.residents.show.post_updates")
    expect(unselected).to have_content t("homeowners.residents.show.developer_email_updates")
  end
end
