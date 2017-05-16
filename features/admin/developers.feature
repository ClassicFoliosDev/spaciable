Feature: Developers
  As a CF Admin
  I want to add developers
  So that we can invite our clients to use our application

  @javascript
  Scenario: Create and delete developer
    Given I am logged in as an admin
    And I have configured an API key
    When I create a developer
    Then I should see the created developer
    When I update the developer
    Then I should see the updated developer
    When I delete the developer
    Then I should see the delete complete successfully

  Scenario: Cloned Default FAQs for new Developers
    Given I am logged in as an admin
    And default FAQs exist
    When I create a developer
    Then I should see default faqs for the developer
