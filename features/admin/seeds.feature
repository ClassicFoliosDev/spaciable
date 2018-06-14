Feature: Seeds
  As an administrator
  I want to be able to run the seeds
  So that I can deploy builds

  Scenario: Existing seeds
    Given I am logged in as a CF Admin
    And There are existing DB contents
    When I have seeded the database
    Then I should see the created seed content
    And I should find the default FAQs
    When I have seeded the database
    Then I should not see duplicate seed content
    