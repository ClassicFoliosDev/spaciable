# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Pagination", type: :feature do
  it "provides page links" do
    login_as create(:cf_admin)

    77.times do |n|
      FactoryGirl.create(:developer, company_name: "Developer #{n}")
    end
    visit "/developers"

    within(".record-list") do
      expect(page.all("tbody tr").count).to eq(25)
    end

    within ".page-sizes" do
      expect(page).to have_link(I18n.t("pagination.per_page_10"), href: "/developers?per=10")
      expect(page).to have_link(I18n.t("pagination.per_page_25"), href: "/developers?per=25")
      expect(page).to have_link(I18n.t("pagination.per_page_50"), href: "/developers?per=50")
      expect(page).to have_link(I18n.t("pagination.per_page_100"), href: "/developers?per=100")
    end

    click_on(I18n.t("pagination.per_page_10"))

    within(".record-list") do
      expect(page.all("tbody tr").count).to eq(10)
    end

    within ".pagination" do
      expect(page).to have_link("2", href: "/developers?page=2&per=10")
    end
  end
end
