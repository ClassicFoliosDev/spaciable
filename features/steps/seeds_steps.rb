# frozen_string_literal: true

Given(/^There are existing appliances$/) do
  SeedsFixture.create_appliance_manufacturers
end

Then(/^I should not see the seed appliance updatest$/) do
  visit "/appliances"

  within ".tabs" do
    click_on t("appliances.collection.appliance_manufacturers")
  end

  within ".record-list" do
    expect(page).to have_content("Aeg")
    expect(page).to have_content("BauMatic")
    expect(page).to have_content("Beko")
    expect(page).to have_content("Caple")

    expect(page).not_to have_content("Baumatic")
    expect(page).not_to have_content("AEG")
  end
end

Then(/^I should find the default FAQs$/) do
  default_faqs = DefaultFaq.all

  expect(default_faqs.length).to eq 50
  questions = default_faqs.pluck(:question)
  answers = default_faqs.pluck(:answer).join("")

  expect(questions).to include "Why are there small cracks in my walls and ceilings?"
  expect(questions).to include "There is a white powder on my walls. Is this a defect?"
  expect(questions).to include "How can I protect my new carpet?"
  expect(questions).to include "Can I cover my air bricks?"
  expect(questions).to include "Why has an MCB tripped?"
  expect(questions).to include "What should I do if I have no heating or hot water?"
  expect(questions).to include "My radiator is not heating properly. What should I do?"  
  expect(questions).to include "I have heated towel rails – why does my bathroom feel cold?" 
  expect(questions).to include "Why is water draining slowly in my kitchen/bathroom?"
  expect(questions).to include "What should I do if I smell gas?"

  expect(answers).to include "You may notice a white, chalk-like substance on the exterior brickwork of your new home."
  expect(answers).to include "Any stains should be treated as quickly as possible, blotting the area, not rubbing."
  expect(answers).to include "For large or persistent stains, you should call a professional carpet cleaner."
  expect(answers).to include "If your home has a suspended ground floor, you will find air bricks outside"
  expect(answers).to include "Please ensure that no rubbish, garden material or soil covers the damp-proof course or air bricks."
  expect(answers).to include "two brick courses below the damp-proof course."
  expect(answers).to include "instead call a suitably qualified electrician to correct the fault."
  expect(answers).to include "Please note, during the winter, there may be a warm-up period of at least 60 minutes before the effects of any heating will be noticed."
  expect(answers).to include "In this instance, you should follow the steps below:"
  expect(answers).to include "When water starts to escape from the radiator, close the bleed valve by turning it clockwise"
  expect(answers).to include "If your bathroom feels cold, it might be because"
  expect(answers).to include "For serious plumbing issues, please contact a plumber"
  expect(answers).to include "Call the free 24 hour National Gas Emergency helpline on 0800 111 999"
end

Then(/^I should not see duplicate seed content$/) do
  default_faqs = DefaultFaq.all

  expect(default_faqs.length).to eq 50
end
