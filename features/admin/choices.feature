@javascript @slow @ignore
Feature: Developments
  As a CF Admin
  I want to make choices for plots


Scenario: DevelopmentChoices
    Given I am logged in as an admin
    Given there is a developer
    Given I add appliances and finishes
    When I want to create a development for the developer
    Then choice options should be off by default
    When I submit and view the new development
    Then no choice options should be available
    When I enable the Either option on the development
    Then a Choises contact email should become available
    Then the choices option should be available on the development
    Given I create a unit type with rooms for the development
    And I create a new choice configuration
    Then I should be able to create my config based on the unit_type
    And the configuration should be created successfully
    When I go to the view the configuration
    And the configuration should contain rooms matching the unit type
    When I add a new room configuration
    Then the configuration should contain the new room configuration
    When I select a room configuration
    Then it should contain no room items
    When I add a new room item
    And I associate multiple apliances
    Then the room item should save successfully
    When I select the room item
    Then the room item options should be listed


Scenario: HomeownerChoiceSelection
    Given I am logged in as an admin
    And FAQ metadata is available
    Given there is development where either can make choices
    Then I can associate plots with the choice configuration
    Then I can view choices for a plot
    Then I can only see rooms with available choices
    When I select a room a category and a choice
    Then the room item populates with the selected value
    And I can successfully save the change
    When I log out as a an admin
    And I log in as the plot resident
    Then I have choices available
    Then I can only see rooms with available choices
    And the resident can make a change and save it
    When all the choices are complete
    Then I can commit the choices
    When I log out as a homeowner
    And I log in as an admin
    Then I can see an email confirming the choices
    When I click the first link in the email
    Then I can view the plot choices
    And the "Reject" button should be disabled
    And the "Approve" button should not be disabled
    When I remove a choice
    Then a dialog should appear asking if I want to archive the choice
    And I can acknowledge the dialog and archive the choice
    And the "Reject" button should not be disabled
    And the "Approve" button should be disabled
    When I press the reject button
    Then a dialog appears asking for details of the rejection
    When I fill in the reason for rejection and confirm
    Then I am told the homeowner has been notified
    When I log out as a an admin
    And I log in as the plot resident
    Then I can see a rejection email
    Then I can see a notification containing the rejection reason
    Then I have choices available
    And I see a message telling me the choices have been rejected
    And the archived choice is no longer available for selection
    When I make a new choice for the rejeted item
    Then I can commit the choices
    When I log out as a homeowner
    And I log in as an admin
    Then I can see an email confirming the choices
    When I click the first link in the email
    And I can view the updated plot choices
    Given a clear email queue
    When I approve the choices
    Then I get a confirmation message
    And a confirmation email is sent to the resident
    And a confirmation email is sent to the developer admin
    And I can export the choices as a CSV file
    When I view the rooms
    Then I see a list of the rooms
    And I see the approved choices
    When I log out as a an admin
    And I log in as the plot resident
    Then I dont have the choices tab available
    And my choices are displayed against the rooms
    And my appliance choices are displayed under appliances


Scenario: AdminChoiceSelection
    Given I am logged in as an admin
    Given there is development where only Admin can make choices
    Then I can associate plots with the choice configuration
    Then I can view choices for a plot
    Then I can only see rooms with available choices
    When I select a room a category and a choice
    Then the room item populates with the selected value
    And I can successfully save the change
    When I log out as a an admin
    And I log in as the plot resident
    Then I dont have the choices tab available
    When I log out as a homeowner
    And I log in as an admin
    Then I can complete all the choices
    Then I can approve the choices
    And a confirmation email is sent to the resident
    And a confirmation email is sent to the developer admin
    And I can export the choices as a CSV file
    When I view the rooms
    Then I see a list of the rooms
    And I see the approved choices
    When I log out as a an admin
    And I log in as the plot resident
    Then I dont have the choices tab available
    And my choices are displayed against the rooms
    And my appliance choices are displayed under appliances


Scenario: AdminChoiceSelectionNoResident
    Given I am logged in as an admin
    Given there is plot with no resident where only Admin can make choices
    Then I can associate plots with the choice configuration
    Then I can view choices for a plot
    Then I can only see rooms with available choices
    When I select a room a category and a choice
    Then the room item populates with the selected value
    And I can successfully save the change
    Then I can complete all the choices
    Then I can approve the choices
    And a confirmation email is sent to the developer admin
    And I can export the choices as a CSV file
    When I view the rooms
    Then I see a list of the rooms
    And I see the approved choices
