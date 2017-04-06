# frozen_string_literal: true
When(/^I create a HowTo$/) do
  visit "/"
  click_on t("components.navigation.howtos")

  sleep 0.3
  click_on t("admin.how_tos.collection.add")

  fill_in :how_to_title, with: HowToFixture.title
  fill_in :how_to_summary, with: HowToFixture.summary
  fill_in_ckeditor(:how_to_description, with: HowToFixture.description)

  within ".category" do
    select_from_selectmenu :how_to_category, with: HowToFixture.category
  end

  within ".featured" do
    select_from_selectmenu :how_to_featured, with: HowToFixture.featured
  end

  within ".how_to_tags_name" do
    fill_in t("admin.how_tos.form.new_tag"), with: HowToFixture.tag
  end

  sleep 0.3
  click_on t("faqs.form.submit")
end

Then(/^I should see the created HowTo$/) do
  within ".record-list" do
    expect(page).to have_content(HowToFixture.title)
    expect(page).to have_content(HowToFixture.category)
  end
end

When(/^I update the HowTo$/) do
  within ".record-list" do
    find("[data-action='edit']").trigger("click")
  end

  within ".how-to" do
    fill_in :how_to_title, with: HowToFixture.updated_title
    fill_in :how_to_url, with: HowToFixture.url
    fill_in :how_to_additional_text, with: HowToFixture.additional_text
  end

  within ".how_to_tags_name" do
    fill_in t("admin.how_tos.form.new_tag"), with: HowToFixture.tags
  end

  within ".sub-category" do
    select_from_selectmenu :how_to_how_to_sub_category, with: HowToFixture.sub_category
  end

  picture_full_path = FileFixture.file_path + FileFixture.finish_picture_name
  within ".how_to_picture" do
    attach_file("how_to_picture",
                File.absolute_path(picture_full_path),
                visible: false)
  end

  click_on t("faqs.form.submit")
end

Then(/^I should see the updated HowTo$/) do
  success_flash = t(
    "controller.success.update",
    name: HowToFixture.updated_title
  )

  within ".notice" do
    expect(page).to have_content(success_flash)
  end

  within ".record-list" do
    expect(page).to have_content(HowToFixture.updated_title)
    expect(page).to have_content(HowToFixture.category)
  end

  within ".record-list" do
    click_on HowToFixture.updated_title
  end

  within ".how-to" do
    image = page.find("img")
    expect(image["src"]).to have_content(FileFixture.finish_picture_name)
    expect(image["alt"]).to have_content(FileFixture.finish_picture_alt)

    expect(page).to have_content(HowToFixture.url)
    expect(page).to have_content(HowToFixture.additional_text)
    expect(page).to have_content(HowToFixture.sub_category)
    expect(page).to have_content(HowToFixture.tag)
    expect(page).to have_content(HowToFixture.tag1)
    expect(page).to have_content(HowToFixture.tag2)
  end
end

When(/^I remove a Tag$/) do
  within ".section-data" do
    find("[data-action='edit']").click
  end

  within ".tags" do
    target_btn = page.find("span", text: HowToFixture.tag1).find(".remove", visible: false)
    target_btn.click
  end
end

Then(/^I should see the remove complete successfully$/) do
  within ".record-list" do
    click_on HowToFixture.updated_title
  end

  within ".how-to" do
    expect(page).to have_content(HowToFixture.tag)
    expect(page).not_to have_content(HowToFixture.tag1)
    expect(page).to have_content(HowToFixture.tag2)
  end
end

When(/^I delete the HowTo$/) do
  click_on t("admin.how_tos.show.back")

  delete_and_confirm!
end

Then(/^I should see the how-to deletion complete successfully$/) do
  success_flash = t(
    "controller.success.destroy",
    name: HowToFixture.updated_title
  )
  expect(page).to have_content(success_flash)

  expect(page).not_to have_content(".record-list")

  within ".empty" do
    expect(page).to have_content t("components.empty_list.add", type_name: HowTo.model_name.human.downcase)
  end
end

Then(/^I should not see HowTos$/) do
  visit "/"

  within ".sidebar-container" do
    expect(page).not_to have_content(t("components.navigation.howtos"))
  end
end
