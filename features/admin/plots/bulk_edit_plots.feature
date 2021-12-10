@javascript @poke
Feature: Documents
  As a CF Admin
  I want to edit plots in bulk
  So that I can update a range of plots more quickly

  Scenario: CF Admin
    Given I am a CF admin and there are many plots
    When I bulk edit the plots
    Then there is an error for plots that don't exist
    And the selected plots are updated
    And the unselected plots are not updated
    When I set the postal number for plots
    Then the selected plots have the new postal number

  Scenario Outline: CAS Admin bulk edit
    Given I am a <role> with CAS and there are many plots
    And all the plots are release completed
    When I CAS bulk edit the plots
    Then there is an error for plots that don't exist
    And the selected plots are CAS updated
    And the unselected plots are not CAS updated
    Examples:
      | role              |
      | Developer Admin   |
      | Division Admin    |
      | Development Admin |

  Scenario Outline: CAS Admin unreleased bulk edit
    Given I am a <role> with CAS and there are many plots
    And the phase plot is release completed
    When I CAS bulk edit the plots
    Then there are errors for plots that don't exist and cannot be updated
    And the released plot is CAS updated
    And the unreleased plots are not CAS updated
    Examples:
      | role              |
      | Developer Admin   |
      | Division Admin    |
      | Development Admin |

  Scenario: Unset and not set
    Given I am a CF admin and there is a plot with all fields set
    When I bulk edit the plot but do not set checkboxes
    Then the plot fields are all unchanged
    When I bulk edit the plot and set optional fields to empty
    Then the optional plot fields are unset
    When I bulk edit the plot and set mandatory fields to empty
    Then I see an error for the mandatory fields

  Scenario Outline: Non CAS Admins
    Given I am logged in as a <role>
    And there is a phase plot with a resident
    Then I can not edit bulk plots
    Examples:
      | role              |
      | Site Admin        |

  Scenario: CF Admin
    Given I am a CF admin and there are many spanish plots
    When I bulk edit the spanish plots
    Then I should see spanish address options
