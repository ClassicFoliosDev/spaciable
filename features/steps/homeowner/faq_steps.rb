# frozen_string_literal: true

Given(/^I am logged in as a homeowner wanting to read FAQs$/) do
  MyHomeFaqsFixture.create_homeowner_faqs

  login_as MyHomeFaqsFixture.resident
end

Then(/^I should see recent FAQs on my dashboard$/) do
  visit "/"
  within "[data-test='dashboard-faqs']" do
    MyHomeFaqsFixture.recent_faqs.each do |question, _answer|
      expect(page).to have_content(question)
    end
  end
end

When(/^I go to read the FAQs for my home$/) do
  recent_question = MyHomeFaqsFixture.recent_faqs.first[0]
  click_on recent_question
end

Then(/^I should see the FAQs related to settling in$/) do
  within ".faqs" do
    MyHomeFaqsFixture.default_filtered_faqs.each do |question, answer|
      expect(page).to have_content(question)
      expect(page).to have_content(answer)
    end

    MyHomeFaqsFixture.default_filtered_out_faqs.each do |question, answer|
      expect(page).not_to have_content(question)
      expect(page).not_to have_content(answer)
    end
  end

  within ".sub-navigation-container" do
    active_category = find(".active").text
    expect(active_category).to eq(MyHomeFaqsFixture.default_category_name)
  end
end

When(/^I filter my FAQs by a different category$/) do
  click_on MyHomeFaqsFixture.other_category_name
end

Then(/^I should only see the FAQs in the other category$/) do
  within ".faqs" do
    MyHomeFaqsFixture.filtered_faqs.each do |question, answer|
      expect(page).to have_content(question)
      expect(page).to have_content(answer)
    end

    MyHomeFaqsFixture.filtered_out_faqs.each do |question, answer|
      expect(page).not_to have_content(question)
      expect(page).not_to have_content(answer)
    end
  end

  within ".sub-navigation-container" do
    active_category = find(".active").text
    expect(active_category).to eq(MyHomeFaqsFixture.other_category_name)
  end
end
