Feature: Dashboard
  As a homeowner
  I want to see the dashboard
  So I can see what's changed recently

  Scenario: Dashboard
    Given I am logged in as a homeowner want to download my documents
    And there is an appliance with a guide
    And there are faqs
    And there are contacts
    And there are how-tos
    When I navigate to the dashboard
    Then I see the recent homeowner contents
    When I the plot has a postal number
    Then I see the dashboard address reformatted

  Scenario: Prefix and Password
    Given I have created and logged in as a homeowner user
    When I navigate to the dashboard
    Then I see the plot number as postal number
    When I change my homeowner password
    Then I should be logged out of homeowner

  Scenario: Services
    Given I have created and logged in as a homeowner user
    And the developer has enabled services
    And there are how-tos
    And there are services
    When I navigate to the dashboard
    Then I see the services
    And I only see three articles

