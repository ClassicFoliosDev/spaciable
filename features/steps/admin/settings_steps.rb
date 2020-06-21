# frozen_string_literal: true

Given(/^I have run the settings seeds$/) do
  load Rails.root.join("db", "seeds", "settings_seeds.rb")
end

When(/^I navigate to the global uploads page$/) do
  goto_config

  click_on t("admin.settings.show.uploads")

  within ".configuration" do
    expect(page).not_to have_content("https")
    expect(page).not_to have_content("vimeo")
  end
end

When(/^I set the video link$/) do
  within ".section-data" do
    find("[data-action='edit']").click
  end

  within ".intro-video" do
    fill_in :setting_video_link, with: SettingsFixture.video_url
  end

  within ".form-actions-footer" do
    click_on t("admin.settings.edit.submit")
  end
end

Then(/^The video link has been configured$/) do
  click_on t("admin.settings.show.uploads")
  within ".configuration" do
    expect(page).to have_content SettingsFixture.video_url
  end
end

When(/^I navigate to the settings page$/) do
  goto_config
end

Then(/^I can select default FAQs for all countries$/) do
  Country.all.each do |country|
    expect(page).to have_content t(".admin.settings.show.faqs.country", country: country.name)
  end
end

Then(/^I can CRUD default FAQs for all countries$/) do

  Country.all.each do |country|
    puts "Country #{country.name}"
    goto_config

    click_on t(".admin.settings.show.faqs.country", country: country.name)

    FaqType.for_country(country).each do |faq_type|
      click_on faq_type.name
      puts faq_type.name

      FaqsFixture.default_faq_attrs.select{ |f| f[:country] == country && f[:type] == faq_type}.each do |faq|
        click_on t("admin.default_faqs.collection.add", type: faq_type.name)

        # add new
        within ".new_default_faq" do
          fill_in :default_faq_question, with: faq[:created][:question]
          fill_in_ckeditor(:default_faq_answer, with: faq[:created][:answer])

          select_from_selectmenu :default_faq_faq_category, with: faq[:created][:category].name
        end
        click_on t("faqs.form.submit")

        expect(page).to have_content(t("controller.success.create", name: faq[:created][:question]))

        # show
        click_on faq[:created][:question]

        within ".section-title" do
          expect(page).to have_content(faq[:created][:question])
        end

        within ".faq" do
          expect(page).to have_content(faq[:created][:answer])
          expect(page).to have_content(faq[:created][:category].name)
        end

        within ".form-actions-footer-container" do
          click_on t("faqs.show.back")
        end

        #edit
        faq_id = DefaultFaq.find_by(question: faq[:created][:question]).id
        within "[data-faq='#{faq_id}']" do
          find("[data-action='edit']").trigger("click")
        end

        within ".faq" do
          fill_in :default_faq_question, with: faq[:updated][:question]
          fill_in_ckeditor(:default_faq_answer, with: faq[:updated][:answer])
          select_from_selectmenu :default_faq_faq_category, with: faq[:updated][:category].name
        end
        click_on t("faqs.form.submit")

        expect(page).to have_content(t("controller.success.update", name: faq[:updated][:question]))
        expect(page).to have_content(faq[:updated][:question])
        expect(page).to have_content(faq[:updated][:category].name)

        #delete
        delete_and_confirm!(scope: "[data-faq='#{faq_id}']")
        expect(page).to have_content(t("controller.success.destroy", name: faq[:updated][:question]))
      end
    end
  end
end

def goto_config
  within ".sidebar-container" do
    click_on t("components.navigation.configuration")
  end
end
