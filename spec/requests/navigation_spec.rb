# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Navigation", type: :feature do
  it "only adds active link to the current page nav link" do
    login_as create(:cf_admin)

    visit "/developers"

    within ".navbar-menu" do
      active_links = find_all ".active"

      expect(active_links.count).to eq(1)
      expect(active_links.first.text).to eq(I18n.t("components.navigation.developers"))
    end
  end

  it "displays nested breadcrumbs relative to the current page" do
    developer = create(:developer)

    login_as create(:cf_admin)
    visit "/developers/#{developer.id}/edit"

    within ".breadcrumb-container" do
      expect(page).to have_link(I18n.t("components.navigation.dashboard"), href: "/")
      expect(page).to have_link(I18n.t("components.navigation.developers"), href: "/developers")
    end
  end

  context "as a Developer Admin" do
    it "can navigate down to the developments" do
      developer_admin = create(:developer_admin)
      developer = developer_admin.permission_level
      division = create(:division, developer: developer)
      division_development = create(:division_development, division: division)

      login_as developer_admin
      visit "/"

      within "nav" do
        click_on I18n.t("components.navigation.developers")
      end

      click_on developer.to_s
      click_on I18n.t("developers.collection.divisions")
      click_on division.to_s
      click_on division_development.to_s

      within ".breadcrumb-container" do
        expect(page).to have_link(developer.to_s)
        expect(page).to have_link(division.to_s)
        expect(page).to have_content(division_development.to_s)
      end
    end
  end

  context "as a Division Admin" do
    it "can navigate down to the developments" do
      developer = create(:developer)
      division = create(:division, developer: developer)
      division_development = create(:division_development, division: division)
      division_admin = create(:division_admin, permission_level: division)

      login_as division_admin
      visit "/"

      within "nav" do
        click_on I18n.t("components.navigation.developers")
      end

      click_on developer.to_s
      click_on I18n.t("developers.collection.divisions")
      click_on division.to_s
      click_on division_development.to_s

      within ".breadcrumb-container" do
        expect(page).to have_link(developer.to_s)
        expect(page).to have_link(division.to_s)
        expect(page).to have_content(division_development.to_s)
      end
    end
  end

  context "as a Development Admin" do
    it "can navigate down to the developments" do
      developer = create(:developer)
      division = create(:division, developer: developer)
      division_development = create(:division_development, division: division)
      development_admin = create(:development_admin, permission_level: division_development)

      login_as development_admin
      visit "/"

      within "nav" do
        click_on I18n.t("components.navigation.developers")
      end

      click_on developer.to_s
      click_on I18n.t("developers.collection.divisions")
      click_on division.to_s
      click_on division_development.to_s

      within ".breadcrumb-container" do
        expect(page).to have_link(developer.to_s)
        expect(page).to have_link(division.to_s)
        expect(page).to have_content(division_development.to_s)
      end
    end
  end

  context "as a Site Admin" do
    it "can navigate down to the developments" do
      developer = create(:developer)
      division = create(:division, developer: developer)
      division_development = create(:division_development, division: division)
      site_admin = create(:site_admin, permission_level: division_development)

      login_as site_admin
      visit "/"

      within "nav" do
        click_on I18n.t("components.navigation.developers")
      end

      click_on developer.to_s
      click_on I18n.t("developers.collection.divisions")
      click_on division.to_s
      click_on division_development.to_s

      within ".breadcrumb-container" do
        expect(page).to have_link(developer.to_s)
        expect(page).to have_link(division.to_s)
        expect(page).to have_content(division_development.to_s)
      end
    end
  end
end
