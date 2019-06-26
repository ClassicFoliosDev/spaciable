@javascript

Feature: Finishes
  As a CF Admin
  I want to create finishes
  So that I can add them to make rooms more descriptive

  Scenario:
    Given I am logged in as an admin
    And I have seeded the database
    And I create a finish without a category
    Then I should see the category failure message
    When I create a finish
    Then I should see the created finish
    When I delete the finish manufacturer
    Then I should see a failed to delete message
    When I review the finish category
    Then I should see the finish type shown
    When I delete the finish category
    Then I should see a failed to delete message
    When I review the finish type
    Then I should see the finish manufacturer shown
    When I delete the finish type
    Then I should see a failed to delete message
    When I update the finish
    Then I should see the updated finish
    When I remove an image from a finish
    Then I should see the updated finish without the image

  Scenario: Delete
    Given I am logged in as an admin
    And I have created a finish
    When I delete the finish
    Then I should see the finish deletion complete successfully
