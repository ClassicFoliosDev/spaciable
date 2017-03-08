Feature: FAQs
  As a homeowner
  I want to read FAQs related to my home
  So that I can get relevent information about efficiently

  Scenario:
    Given I am logged in as a homeowner wanting to read FAQs
    Then I should see recent FAQs on my dashboard
    When I go to read the FAQs for my home
    Then I should see the FAQs related to settling in

    When I filter my FAQs by a different category
    Then I should only see the FAQs in the other category
