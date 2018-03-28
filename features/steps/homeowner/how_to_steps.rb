# frozen_string_literal: true

Then(/^I should see recent HowTos on my dashboard$/) do
  visit "/"

  within ".dashboard" do
    articles = page.all(".article")
    expect(articles.count).to eq(3)
  end
end

When(/^I go to read the HowTos$/) do
  click_on(t("layouts.homeowner.nav.how_to"))
end

Then(/^I should see the HowTos for Around the home$/) do
  active_category = find(".categories .active").text
  expect(active_category).to eq(HowToFixture.category)

  within ".how-tos" do
    articles = page.all(".article")
    expect(articles.count).to eq(1)
  end
end

When(/^I filter my HowTos by a different category$/) do
  click_on(t("activerecord.attributes.how_to.categories.diy"))
end

Then(/^I should only see the HowTos in the other category$/) do
  active_category = find(".categories .active").text
  expect(active_category).to eq(t("activerecord.attributes.how_to.categories.diy"))

  within ".how-tos" do
    articles = page.all(".article")
    expect(articles.count).to eq(2)
  end
end

When(/^I select a HowTo article$/) do
  within ".how-tos" do
    target_article = page.first("div", text: CreateFixture.how_to_name)
    target_button = target_article.find("a")
    target_button.click
  end
end

Then(/^I should see the HowTo details$/) do
  within ".article-container" do
    expect(page).to have_content(t("homeowners.how_tos.show.tags"))
    expect(page).to have_content(t("activerecord.attributes.how_to.categories.diy"))
    expect(page).to have_content(t("homeowners.how_tos.show.also"))

    other_articles = page.all(".recommended-articles")
    expect(other_articles.count).to eq(1)
  end
end

When(/^I select a HowTo tag$/) do
  within ".tags-container" do
    link = page.first("a")
    link.click
  end
end

Then(/^I should see a list of matching HowTos$/) do
  within ".tag-line" do
    expect(page).to have_content(t("homeowners.how_tos.index.tagged"))
  end

  within ".how-tos" do
    expect(page).to have_content(CreateFixture.how_to_name)
  end

  within ".categories" do
    active_categories = page.all(".active")
    expect(active_categories.length).to be_zero
  end
end

Then(/^I should not see the hidden HowTo$/) do
  within ".dashboard" do
    expect(page).not_to have_content("Hidden how to")
  end
end
