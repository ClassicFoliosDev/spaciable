@javascript @slow
Feature: Release Plots
  As a CF Admin
  I want to release plots in bulk
  So that I can release a range of plots simultaneously

  Scenario: Data Validation
    Given I am a CF admin and there are many releasable plots
    Then I add some released plots
    Then I add some completed plots
    When I visit the release plots page
    When I add all plots and set a reservation release date
    And I input the order number
    When I press Submit
    Then there is a message telling me the released pots
    When I set a completion date
    When I press Submit
    Then there is a message telling me the completed pots
    When I enter a range of non-existent plots
    When I press Submit
    Then there is a message telling me the plots dont match this phase
    When I enter a range of existent plots
    When I press Submit
    Then I get a completion confirmation dialog
    When I cancel the dialog
    Then the dialog disappears and the release plot page remains populated
    When I set a reservation date and extended period
    When I press Submit
    Then I get a reservation confirmation dialog
    When I confirm the dialog
    Then I am returned to the phases page with a confirmation message
    Then the plot release data has been updated

  Scenario: Nil Validation
    Given I am a CF admin and there are many releasable plots
    Then I add some released plots
    Then I add some completed plots
    When I visit the release plots page
    When I submit with no parameters
    Then there is a message to telling me to populate the data

  Scenario: Completion
    Given I am a CF admin and there are many releasable plots
    When I visit the release plots page
    When I enter a range of existent plots
    When I set a completion date
    And I input the order number
    When I press Submit
    Then I get a completion confirmation dialog
    When I confirm the dialog
    Then I am returned to the phases page with a confirmation message
    Then the plot completion data has been updated

Scenario: Validity and Extended Access
    Given I am a CF admin and there are many releasable plots
    When I visit the release plots page
    When I enter an existent plot and a date beyond today
    When I press Submit
    Then there is a message to telling me the date is incorrect
    When I set the date to today and a validity value
    And I input the order number
    When I press Submit
    Then I get a reservation and validity confirmation dialog
    When I cancel the dialog
    Then I am returned to the release plots page
    When I enter Validity and Extended periods
    When I press Submit
    Then I get a reservation, validity and extended confirmation dialog
    When I confirm the dialog
    Then I am returned to the phases page with a single plot confirmation message
    Then the plot validity and extended data has been updated