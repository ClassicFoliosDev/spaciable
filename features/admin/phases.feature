Feature: Phases
  As a CF Admin
  I want to add the development phases
  So that the I can match the development approach of the client

  @javascript
  Scenario:
    Given I am logged in as an admin
    And I have a developer with a development
    And I have configured the development address
    When I create a phase for the development
    Then I should see the created phase
    When I update the phase
    Then I should see the updated phase
    And I should see the development address has not been changed
    When I delete the phase
    Then I should see that the deletion completed successfully
    Given I create a phase for the development
    When I delete the phase
    Then I should see the development address has not been changed

  @javascript
  Scenario: Phase plot progress
    Given I am logged in as an admin
    And there is a phase plot with a resident
    When I update the progress for the phase
    Then I should see the plot progress has been updated
