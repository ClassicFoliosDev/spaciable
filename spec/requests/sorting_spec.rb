# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Sorting", type: :feature do
  it "provides sortable headers" do
    login_as create(:cf_admin)

    create(:developer, company_name: "Alpha")
    create(:developer, company_name: "Beta")
    create(:developer, company_name: "Gamma")
    visit "/developers"

    within ".record-list" do
      expect(page).to have_link(I18n.t("activerecord.attributes.developer.company_name"))
    end

    first_row_content = first(".record-list-item-content").text
    last_row_content = all(".record-list-item-content").last.text

    expect(first_row_content).to have_content("Alpha")
    expect(last_row_content).to have_content("Gamma")

    click_on(I18n.t("activerecord.attributes.developer.company_name"))

    post_sort_first_row_content = first(".record-list-item-content").text
    post_sort_last_row_content = all(".record-list-item-content").last.text

    expect(post_sort_first_row_content).to have_content("Gamma")
    expect(post_sort_last_row_content).to have_content("Alpha")
  end
end
