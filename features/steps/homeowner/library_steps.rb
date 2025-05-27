# frozen_string_literal: true

Given(/^I am logged in as a homeowner want to download my documents$/) do
  MyLibraryFixture.create_room_appliance_and_finish
  MyLibraryFixture.create_documents

  login_as CreateFixture.resident
end

Then(/^I should see recent documents added to my library$/) do
  visit "/"
  within ".library-component" do
    MyLibraryFixture.recent_documents.each do |title, _download_link|
      expect(page).to have_content(title)
    end
    pinned = page.first(".document")
    expect(pinned).to have_content("Development Document")
  end

  click_on t("homeowner.dashboard.cards.library.view_more")
end

When(/^I go to download the documents for my home$/) do
  within ".burger-navigation" do
    check_box = find(".burger")
    check_box.trigger(:click)
  end
  click_on(t("components.homeowner.sub_menu.library"))
end

Then(/^I should see all of the documents related to my home$/) do
  within find(".documents", visible: true)  do
    MyLibraryFixture.default_filtered_documents.each do |title, download_link|
      expect(page).to have_content %r{#{title}}i

      anchor = first("a[href='#{download_link}']")
      expect(anchor).not_to be_nil
    end

    # the pinned document should display first
    pinned = page.first(".document")
    expect(pinned).to have_content("Development Document")

    MyLibraryFixture.default_filtered_out_documents.each do |title, download_link|
      expect(page).not_to have_content(title)
      expect(page).not_to have_selector("a[href='#{download_link}']")
    end
  end

  within ".library-categories" do
    active_category = find(".active").text
    expect(active_category).to eq(MyLibraryFixture.default_category_name)
  end
end

When(/^I filter my documents by a different category$/) do
  click_on MyLibraryFixture.other_category_name
end

Then(/^I should only see the documents for the other category$/) do
  within ".documents" do
    MyLibraryFixture.filtered_documents.each do |title, download_link|
      expect(page).to have_content %r{#{title}}i

      anchor = first("a[href='#{download_link}']")
      expect(anchor).not_to be_nil
    end

    MyLibraryFixture.filtered_out_documents.each do |title, download_link|
      expect(page).not_to have_content(title)
      expect(page).not_to have_selector("a[href='#{download_link}']")
    end
  end

  within ".library-categories" do
    active_category = find(".active").text
    expect(active_category).to eq(MyLibraryFixture.other_category_name)
  end
end

When(/^I filter the documents by appliances$/) do
  within ".categories" do
    click_on MyLibraryFixture.appliances_category_name
  end
end

Then(/^I should only see the appliance manuals to download$/) do
  within ".library" do
    MyLibraryFixture.appliance_manuals.each do |title|
      expect(page).to have_content %r{#{title}}i
    end

    # Appliance guide
    within ".row" do
      expect(page).to have_content(t("homeowners.appliances.show.guide"))
      expect(page).to have_content(t("homeowners.appliances.show.manual"))
    end

    MyLibraryFixture.not_appliance_manuals.each do |title|
      expect(page).not_to have_content(title)
    end
  end

  within ".library-categories" do
    active_category = find(" .active").text
    expect(active_category).to eq(MyLibraryFixture.appliances_category_name)
  end
end

Then(/^I should not see plot documents in the dashboard$/) do
  within ".library-component" do
    expect(page).not_to have_content("Phase Plot Document")
    expect(page).to have_content("Developer Document")
    expect(page).to have_content("Development Document")
  end
end

When(/^I visit the library page$/) do
  visit "/homeowners/library/my_home"
end

Then(/^I should not see plot documents$/) do
  within ".documents" do
    expect(page).not_to have_content %r{#{"Phase Plot Document"}}i
    expect(page).to have_content %r{#{"Developer Document"}}i
    expect(page).to have_content %r{#{"Development Document"}}i
  end
end

When(/^I enable document tenant read$/) do
  visit "/homeowners/library/my_home"

  enable_document = Document.find_by(title: "Phase Plot Document")

  within "[data-document='#{enable_document.id}']" do
    permission_circle = page.find(".document-permission")
    permission_circle.trigger('click')
  end
end

Then(/^I should see the document has been enabled for tenants$/) do
  plot = CreateFixture.phase_plot
  success_message = t("homeowners.library.update.shared", title: "Phase Plot Document", address: plot.to_homeowner_s)

  within ".flash" do
    expect(page).to have_content success_message
  end
end

Given(/^there is another tenant on the plot$/) do
  tenant = FactoryGirl.create(:resident,
                              :with_tenancy,
                              plot: CreateFixture.phase_plot,
                              email: "tenant@example.com",
                              developer_email_updates: true,
                              ts_and_cs_accepted_at: Time.zone.now)
end

When(/^I log in as a tenant$/) do
  tenant_residency = PlotResidency.find_by(role: :tenant)

  tenant = tenant_residency.resident
  login_as tenant
end

Then(/^I should see the enabled document$/) do
  visit "/homeowners/library/my_home"

  within ".documents" do
    expect(page).to have_content %r{#{"Phase Plot Document"}}i
  end
end

Then(/^I should not see any other plot documents$/) do
  within ".documents" do
    expect(page).not_to have_content %r{#{"Developer Document"}}i
    expect(page).not_to have_content %r{#{"Development Document"}}i
    expect(page).not_to have_content %r{#{"Unit Type Document"}}i
  end
end

Then(/^I should see the appliance documents$/) do
  visit "/homeowners/library/appliance_manuals"

  within ".documents" do

    content = page.text.gsub(/\n/, ' ').gsub(/\s+/,' ')
    expect(content).to have_content FileFixture.manual_name_alt
    expect(content).to have_content "Washing Machine Quick Reference Guide"
  end
end
