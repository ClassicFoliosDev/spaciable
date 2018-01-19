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

    first_row_content = first("tbody tr td").text
    last_row_content = all("tbody tr td:first").last.text

    expect(first_row_content).to have_content("Alpha")
    expect(last_row_content).to have_content("Gamma")

    click_on(I18n.t("activerecord.attributes.developer.company_name"))

    post_sort_first_row_content = first("tbody tr td").text
    post_sort_last_row_content = all("tbody tr td:first").last.text

    expect(post_sort_first_row_content).to have_content("Gamma")
    expect(post_sort_last_row_content).to have_content("Alpha")
  end

  it "sorts plots correctly" do
    login_as create(:cf_admin)

    developer = create(:developer, company_name: "Alpha")
    development = create(:development, developer: developer)
    phase = create(:phase, development: development)
    create(:plot, prefix: "Plot", number: "1", phase: phase)
    create(:plot, prefix: "Plot", number: "9", phase: phase)
    create(:plot, prefix: "Plot", number: "10", phase: phase)
    create(:plot, prefix: "Plot", number: "11", phase: phase)
    create(:plot, prefix: "Plot", number: "12", phase: phase)

    visit "/developments/#{development.id}/phases/#{phase.id}"

    within ".plots" do
      rows = page.all("tr")

      # Row 0 is the headers
      expect(rows[1]).to have_content("Plot 1")
      expect(rows[2]).to have_content("Plot 9")
      expect(rows[3]).to have_content("Plot 10")
      expect(rows[4]).to have_content("Plot 11")
    end
  end
end
