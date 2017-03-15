Feature: Plot Rooms
  As an admin
  I want to configure individual rooms
  So that I do not have to stick to rooms associated with a unit type

  @javascript
  Scenario:
    Given I am logged in as a CF Admin wanting to manage plot rooms
    When I go to review the plot rooms
    Then I should see the plots unit type rooms

    When I add a new plot room
    Then I should see the new plot room

    When I update one of the default unit type rooms
    Then I should see the updated plot room

    When I delete one of the default unit type rooms
    Then I should not see the deleted default unit type room
    
    When I review the plots unit type rooms
    Then I should see the unchanged unit type rooms
