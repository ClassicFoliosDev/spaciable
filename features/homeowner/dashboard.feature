Feature: Dashboard
  As a homeowner
  I want to see the dashboard
  So I can see what's changed recently

  Scenario: Dashboard
    Given there is a division plot
    And there are faqs
    And there are documents
    And there are contacts
    And I have logged in as a resident and associated the division development plot
    When I navigate to the dashboard
    Then I see the recent homeowner contents

  Scenario: Password
    Given I have created a homeowner user
    When I change my homeowner password
    Then I should be logged out of homeowner
