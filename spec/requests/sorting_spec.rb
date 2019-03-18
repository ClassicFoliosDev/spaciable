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

  it "sorts numeric plots correctly" do
    login_as create(:cf_admin)

    country = create(:country)
    developer = create(:developer, company_name: "Alpha", country_id: country.id)
    development = create(:development, developer: developer)
    phase = create(:phase, development: development)
    create(:plot, number: "12", phase: phase)
    create(:plot, number: "10", phase: phase)
    create(:plot, number: "11", phase: phase)
    create(:plot, number: "1", phase: phase)
    create(:plot, number: "9", phase: phase)

    visit "/developments/#{development.id}/phases/#{phase.id}"

    within ".plots" do
      rows = page.all("tr")

      # Row 0 is the headers
      expect(rows[1]).to have_content("Plot 1")
      expect(rows[2]).to have_content("Plot 9")
      expect(rows[3]).to have_content("Plot 10")
      expect(rows[4]).to have_content("Plot 11")
      expect(rows[5]).to have_content("Plot 12")
    end

    within "thead" do
      click_on I18n.t("activerecord.models.plot")
    end

    within ".plots" do
      rows = page.all("tr")

      # Row 0 is the headers
      expect(rows[1]).to have_content("Plot 12")
      expect(rows[2]).to have_content("Plot 11")
      expect(rows[3]).to have_content("Plot 10")
      expect(rows[4]).to have_content("Plot 9")
      expect(rows[5]).to have_content("Plot 1")
    end
  end

  it "sorts mixed alphanumeric plots correctly" do
    login_as create(:cf_admin)

    country = create(:country)
    developer = create(:developer, company_name: "Alpha", country_id: country.id)
    development = create(:development, developer: developer)
    phase = create(:phase, development: development)
    create(:plot, number: "12", phase: phase)
    create(:plot, number: "B2", phase: phase)
    create(:plot, number: "10", phase: phase)
    create(:plot, number: "C2", phase: phase)
    create(:plot, number: "C1", phase: phase)
    create(:plot, number: "11E", phase: phase)
    create(:plot, number: "B1", phase: phase)
    create(:plot, number: "1B", phase: phase)
    create(:plot, number: "103", phase: phase)
    create(:plot, number: "10.2", phase: phase)
    create(:plot, number: "1", phase: phase)
    create(:plot, number: "9", phase: phase)

    visit "/developments/#{development.id}/phases/#{phase.id}"

    within ".plots" do
      rows = page.all("tr")

      # Row 0 is the headers
      expect(rows[1].text).to have_content("Plot B1")
      expect(rows[2].text).to have_content("Plot B2")
      expect(rows[3].text).to have_content("Plot C1")
      expect(rows[4].text).to have_content("Plot C2")
      expect(rows[5].text).to have_content("Plot 1")
      expect(rows[6].text).to have_content("Plot 1B")
      expect(rows[7].text).to have_content("Plot 9")
      expect(rows[8].text).to have_content("Plot 10")
      expect(rows[9].text).to have_content("Plot 10.2")
      expect(rows[10].text).to have_content("Plot 11E")
      expect(rows[11].text).to have_content("Plot 12")
      expect(rows[12].text).to have_content("Plot 103")
    end

    within "thead" do
      click_on I18n.t("activerecord.models.plot")
    end

    within ".plots" do
      rows = page.all("tr")

      # Row 0 is the headers
      expect(rows[1].text).to have_content("Plot 103")
      expect(rows[2].text).to have_content("Plot 12")
      expect(rows[3].text).to have_content("Plot 11E")
      expect(rows[4].text).to have_content("Plot 10.2")
      expect(rows[5].text).to have_content("Plot 10")
      expect(rows[6].text).to have_content("Plot 9")
      expect(rows[7].text).to have_content("Plot 1B")
      expect(rows[8].text).to have_content("Plot 1")
      expect(rows[9].text).to have_content("Plot C2")
      expect(rows[10].text).to have_content("Plot C1")
      expect(rows[11].text).to have_content("Plot B2")
      expect(rows[12].text).to have_content("Plot B1")
    end
  end

  it "only finds plots in the correct phase and copes with special characters" do
    login_as create(:cf_admin)

    country = create(:country)
    developer = create(:developer, company_name: "Alpha", country_id: country.id)
    development = create(:development, developer: developer)
    phase = create(:phase, development: development)
    another_phase = create(:phase, development: development)
    create(:plot, number: "A2", phase: phase)
    create(:plot, number: "10", phase: another_phase)
    create(:plot, number: "2C", phase: phase)
    create(:plot, number: "11 E", phase: phase)
    create(:plot, number: "C 3", phase: phase)
    create(:plot, number: "1B", phase: another_phase)
    create(:plot, number: "103", phase: phase)
    create(:plot, number: "10.2", phase: phase)
    create(:plot, number: "C-2", phase: phase)
    create(:plot, number: "1", phase: phase)
    create(:plot, number: "9-5", phase: phase)

    visit "/developments/#{development.id}/phases/#{phase.id}"

    within ".plots" do
      rows = page.all("tr")

      # Row 0 is the headers
      expect(rows[1].text).to have_content("Plot A2")
      expect(rows[2].text).to have_content("Plot C 3")
      expect(rows[3].text).to have_content("Plot C-2")
      expect(rows[4].text).to have_content("Plot 1")
      expect(rows[5].text).to have_content("Plot 2C")
      expect(rows[6].text).to have_content("Plot 9-5")
      expect(rows[7].text).to have_content("Plot 10.2")
      expect(rows[8].text).to have_content("Plot 11 E")
      expect(rows[9].text).to have_content("Plot 103")
    end
  end
end
