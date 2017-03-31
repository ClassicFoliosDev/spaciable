Feature: Dashboard
  As a homeowner
  I want to see the dashboard
  So I can see what's changed recently

  Scenario: Dashboard
    And I am logged in as a homeowner want to download my documents
    And there is an appliance with a guide
    And there are faqs
    And there are contacts
    And there are how-tos
    When I navigate to the dashboard
    Then I see the recent homeowner contents
    And I can see the data policy page

  Scenario: Password
    Given I have created a homeowner user
    When I change my homeowner password
    Then I should be logged out of homeowner
